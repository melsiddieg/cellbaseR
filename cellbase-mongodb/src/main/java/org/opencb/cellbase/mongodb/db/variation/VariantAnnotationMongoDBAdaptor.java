/*
 * Copyright 2015 OpenCB
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.opencb.cellbase.mongodb.db.variation;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import com.mongodb.DBObject;
import org.opencb.biodata.models.core.Gene;
import org.opencb.biodata.models.core.Region;
import org.opencb.biodata.models.variant.Variant;
import org.opencb.biodata.models.variant.avro.*;
import org.opencb.cellbase.core.common.regulatory.RegulatoryRegion;
import org.opencb.cellbase.core.db.api.core.ConservedRegionDBAdaptor;
import org.opencb.cellbase.core.db.api.core.GeneDBAdaptor;
import org.opencb.cellbase.core.db.api.core.GenomeDBAdaptor;
import org.opencb.cellbase.core.db.api.core.ProteinDBAdaptor;
import org.opencb.cellbase.core.db.api.regulatory.RegulatoryRegionDBAdaptor;
import org.opencb.cellbase.core.db.api.variation.ClinicalDBAdaptor;
import org.opencb.cellbase.core.db.api.variation.VariantAnnotationDBAdaptor;
import org.opencb.cellbase.core.db.api.variation.VariationDBAdaptor;
import org.opencb.cellbase.core.variant.annotation.*;
import org.opencb.cellbase.mongodb.db.MongoDBAdaptor;
import org.opencb.datastore.core.QueryOptions;
import org.opencb.datastore.core.QueryResult;
import org.opencb.datastore.mongodb.MongoDataStore;

import java.util.*;
import java.util.concurrent.*;

/**
 * Created by imedina on 11/07/14.
 * @author Javier Lopez fjlopez@ebi.ac.uk;
 */
public class  VariantAnnotationMongoDBAdaptor extends MongoDBAdaptor implements VariantAnnotationDBAdaptor {

    private GeneDBAdaptor geneDBAdaptor;
    private RegulatoryRegionDBAdaptor regulatoryRegionDBAdaptor;
    private VariationDBAdaptor variationDBAdaptor;
    private ClinicalDBAdaptor clinicalDBAdaptor;
    private ProteinDBAdaptor proteinDBAdaptor;
    private ConservedRegionDBAdaptor conservedRegionDBAdaptor;
    private GenomeDBAdaptor genomeDBAdaptor;

    private ObjectMapper geneObjectMapper;

    public VariantAnnotationMongoDBAdaptor(String species, String assembly, MongoDataStore mongoDataStore) {
        super(species, assembly, mongoDataStore);

        geneObjectMapper = new ObjectMapper();

        logger.debug("VariantAnnotationMongoDBAdaptor: in 'constructor'");
    }


    @Override
    public QueryResult getAllConsequenceTypesByVariant(Variant variant, QueryOptions queryOptions) {
        long dbTimeStart = System.currentTimeMillis();

        // We process include and exclude query options to know which annotators to use.
        // Include parameter has preference over exclude.
        Set<String> annotatorSet = getAnnotatorSet(queryOptions);

        // This field contains all the fields to be returned by overlapping genes
        String includeGeneFields = getIncludedGeneFields(annotatorSet);
        List<Gene> geneList = getAffectedGenes(variant, includeGeneFields);

        // TODO the last 'true' parameter needs to be changed by annotatorSet.contains("regulatory") once is ready
        List<ConsequenceType> consequenceTypeList = getConsequenceTypeList(variant, geneList, true);

        QueryResult queryResult = new QueryResult();
        queryResult.setId(variant.toString());
        queryResult.setDbTime(Long.valueOf(System.currentTimeMillis() - dbTimeStart).intValue());
        queryResult.setNumResults(consequenceTypeList.size());
        queryResult.setNumTotalResults(consequenceTypeList.size());
        queryResult.setResult(consequenceTypeList);

        return queryResult;

    }

    @Override
    public List<QueryResult> getAllConsequenceTypesByVariantList(List<Variant> variants, QueryOptions options) {
        List<QueryResult> queryResults = new ArrayList<>(variants.size());
        for (Variant variant : variants) {
            try {
                queryResults.add(getAllConsequenceTypesByVariant(variant, options));
            } catch (UnsupportedURLVariantFormat e) {
                logger.error("Consequence type was not calculated for variant {}. Unrecognised variant format.",
                        variant.toString());
            }
        }
        return queryResults;
    }

    @Override
    public QueryResult getAnnotationByVariant(Variant variant, QueryOptions queryOptions) {
        return getAnnotationByVariantList(Collections.singletonList(variant), queryOptions).get(0);
    }

    @Override
    public List<QueryResult> getAnnotationByVariantList(List<Variant> variantList, QueryOptions queryOptions) {

        // We process include and exclude query options to know which annotators to use.
        // Include parameter has preference over exclude.
        Set<String> annotatorSet = getAnnotatorSet(queryOptions);
        logger.debug("Annotators to use: {}", annotatorSet.toString());

        // This field contains all the fields to be returned by overlapping genes
        String includeGeneFields = getIncludedGeneFields(annotatorSet);

        // Object to be returned
        List<QueryResult> variantAnnotationResultList = new ArrayList<>(variantList.size());

        long globalStartTime = System.currentTimeMillis();
        long startTime;
        queryOptions = new QueryOptions();

        /*
         * Next three async blocks calculate annotations using Futures, this will be calculated in a different thread.
         * Once the main loop has finished then they will be stored. This provides a ~30% of performance improvement.
         */
        ExecutorService fixedThreadPool = Executors.newFixedThreadPool(3);
        FutureVariationAnnotator futureVariationAnnotator = null;
        Future<List<QueryResult>> variationFuture = null;
        if (annotatorSet.contains("variation") || annotatorSet.contains("populationFrequencies")) {
            futureVariationAnnotator = new FutureVariationAnnotator(variantList, queryOptions);
            variationFuture = fixedThreadPool.submit(futureVariationAnnotator);
        }

        FutureConservationAnnotator futureConservationAnnotator = null;
        Future<List<QueryResult>> conservationFuture = null;
        if (annotatorSet.contains("conservation")) {
            futureConservationAnnotator = new FutureConservationAnnotator(variantList, queryOptions);
            conservationFuture = fixedThreadPool.submit(futureConservationAnnotator);
        }

        FutureClinicalAnnotator futureClinicalAnnotator = null;
        Future<List<QueryResult>> clinicalFuture = null;
        if (annotatorSet.contains("clinical")) {
            futureClinicalAnnotator = new FutureClinicalAnnotator(variantList, queryOptions);
            clinicalFuture = fixedThreadPool.submit(futureClinicalAnnotator);
        }

        /*
         * We iterate over all variants to get the rest of the annotations and to create the VariantAnnotation objects
         */
        List<Gene> geneList;
        startTime = System.currentTimeMillis();
        for (int i = 0; i < variantList.size(); i++) {
            // Fetch overlapping genes for this variant
            geneList = getAffectedGenes(variantList.get(i), includeGeneFields);

            // TODO: start & end are both being set to variantList.get(i).getPosition(), modify this for indels
            VariantAnnotation variantAnnotation = new VariantAnnotation();
            variantAnnotation.setChromosome(variantList.get(i).getChromosome());
            variantAnnotation.setStart(variantList.get(i).getStart());
            variantAnnotation.setEnd(variantList.get(i).getEnd());
            variantAnnotation.setReference(variantList.get(i).getReference());
            variantAnnotation.setAlternate(variantList.get(i).getAlternate());

            if (annotatorSet.contains("consequenceType")) {
                try {
                    List<ConsequenceType> consequenceTypeList = getConsequenceTypeList(variantList.get(i), geneList, true);
                    variantAnnotation.setConsequenceTypes(consequenceTypeList);
                } catch (UnsupportedURLVariantFormat e) {
                    logger.error("Consequence type was not calculated for variant {}. Unrecognised variant format.",
                            variantList.get(i).toString());
                } catch (Exception e) {
                    logger.error("Unhandled error when calculating consequence type for variant {}",
                            variantList.get(i).toString());
                    throw e;
                }
            }

            /*
             * Gene Annotation
             */
            if (annotatorSet.contains("expression")) {
                variantAnnotation.setExpression(new ArrayList<>());
                for (Gene gene : geneList) {
                    if (gene.getAnnotation().getExpression() != null) {
                        variantAnnotation.getExpression().addAll(gene.getAnnotation().getExpression());
                    }
                }
            }

            if (annotatorSet.contains("geneDisease")) {
                variantAnnotation.setGeneTraitAssociation(new ArrayList<>());
                for (Gene gene : geneList) {
                    if (gene.getAnnotation().getDiseases() != null) {
                        variantAnnotation.getGeneTraitAssociation().addAll(gene.getAnnotation().getDiseases());
                    }
                }
            }

            if (annotatorSet.contains("drugInteraction")) {
                variantAnnotation.setGeneDrugInteraction(new ArrayList<>());
                for (Gene gene : geneList) {
                    if (gene.getAnnotation().getDrugs() != null) {
                        variantAnnotation.getGeneDrugInteraction().addAll(gene.getAnnotation().getDrugs());
                    }
                }
            }

            QueryResult queryResult = new QueryResult(variantList.get(i).toString());
            queryResult.setDbTime((int)(System.currentTimeMillis() - startTime));
            queryResult.setNumResults(1);
            queryResult.setNumTotalResults(1);
            //noinspection unchecked
            queryResult.setResult(Collections.singletonList(variantAnnotation));

            variantAnnotationResultList.add(queryResult);

        }
        logger.debug("Main loop iteration annotation performance is {}ms for {} variants", System.currentTimeMillis() - startTime, variantList.size());


        /*
         * Now, hopefully the other annotations have finished and we can store the results.
         * Method 'processResults' has been implemented in the same class for sanity.
         */
        if (futureVariationAnnotator != null) {
            futureVariationAnnotator.processResults(variationFuture, variantAnnotationResultList, annotatorSet);
        }
        if (futureConservationAnnotator != null) {
            futureConservationAnnotator.processResults(conservationFuture, variantAnnotationResultList);
        }
        if (futureClinicalAnnotator != null) {
            futureClinicalAnnotator.processResults(clinicalFuture, variantAnnotationResultList);
        }
        fixedThreadPool.shutdown();


        logger.debug("Total batch annotation performance is {}ms for {} variants", System.currentTimeMillis() - globalStartTime, variantList.size());
        return variantAnnotationResultList;
    }

    private Set<String> getAnnotatorSet(QueryOptions queryOptions) {
        Set<String> annotatorSet;
        List<String> includeList = queryOptions.getAsStringList("include");
        if (includeList.size() > 0) {
            annotatorSet = new HashSet<>(includeList);
        } else {
            annotatorSet = new HashSet<>(Arrays.asList("variation", "clinical", "conservation",
                    "consequenceType", "expression", "geneDisease", "drugInteraction", "populationFrequencies"));
            List<String> excludeList = queryOptions.getAsStringList("exclude");
            excludeList.forEach(annotatorSet::remove);
        }
        return annotatorSet;
    }

    private String getIncludedGeneFields(Set<String> annotatorSet) {
        String includeGeneFields = "name,id,start,end,transcripts.id,transcripts.start,transcripts.end,transcripts.strand," +
                "transcripts.cdsLength,transcripts.annotationFlags,transcripts.biotype,transcripts.genomicCodingStart," +
                "transcripts.genomicCodingEnd,transcripts.cdnaCodingStart,transcripts.cdnaCodingEnd,transcripts.exons.start," +
                "transcripts.exons.end,transcripts.exons.sequence,transcripts.exons.phase,mirna.matures,mirna.sequence," +
                "mirna.matures.cdnaStart,mirna.matures.cdnaEnd";

        if (annotatorSet.contains("expression")) {
            includeGeneFields += ",annotation.expression";
        }
        if (annotatorSet.contains("geneDisease")) {
            includeGeneFields += ",annotation.diseases";
        }
        if (annotatorSet.contains("drugInteraction")) {
            includeGeneFields += ",annotation.drugs";
        }
        return includeGeneFields;
    }

    private List<Gene> getAffectedGenes(Variant variant, String includeFields) {
        int variantStart = variant.getReference().isEmpty() ? variant.getStart() - 1 : variant.getStart();
        QueryOptions queryOptions = new QueryOptions("include", includeFields);
        QueryResult queryResult = geneDBAdaptor.getAllByRegion(new Region(variant.getChromosome(),
                variantStart - 5000, variant.getStart() + variant.getReference().length() - 1 + 5000), queryOptions);

        List<Gene> geneList = new ArrayList<>(queryResult.getNumResults());
        for (Object object : queryResult.getResult()) {
            Gene gene = geneObjectMapper.convertValue(object, Gene.class);
            geneList.add(gene);
        }
        return geneList;
    }

    private boolean nonSynonymous(ConsequenceType consequenceType) {
        if (consequenceType.getCodon() == null) {
            return false;
        } else {
            String[] parts = consequenceType.getCodon().split("/");
            String ref = String.valueOf(parts[0]).toUpperCase();
            String alt = String.valueOf(parts[1]).toUpperCase();
            return !VariantAnnotationUtils.isSynonymousCodon.get(ref).get(alt) && !VariantAnnotationUtils.isStopCodon(ref);
        }
    }

    private ProteinVariantAnnotation getProteinAnnotation(ConsequenceType consequenceType) {
        if (consequenceType.getProteinVariantAnnotation() != null) {
            QueryResult proteinVariantAnnotation = proteinDBAdaptor.getVariantAnnotation(
                    consequenceType.getEnsemblTranscriptId(),
                    consequenceType.getProteinVariantAnnotation().getPosition(),
                    consequenceType.getProteinVariantAnnotation().getReference(),
                    consequenceType.getProteinVariantAnnotation().getAlternate(), new QueryOptions());

            if (proteinVariantAnnotation.getNumResults() > 0) {
                return (ProteinVariantAnnotation) proteinVariantAnnotation.getResult().get(0);
            }
        }
        return null;
    }

    private ConsequenceTypeCalculator getConsequenceTypeCalculator(Variant variant) throws UnsupportedURLVariantFormat {
        if (variant.getReference().isEmpty()) {
            return new ConsequenceTypeInsertionCalculator(genomeDBAdaptor);
        } else {
            if (variant.getAlternate().isEmpty()) {
                return new ConsequenceTypeDeletionCalculator(genomeDBAdaptor);
            } else {
                if(variant.getReference().length() == 1 && variant.getAlternate().length() == 1) {
                    return new ConsequenceTypeSNVCalculator();
                } else {
                    throw new UnsupportedURLVariantFormat();
                }
            }
        }
    }

    private List<RegulatoryRegion> getAffectedRegulatoryRegions(Variant variant) {
        int variantStart = variant.getReference().isEmpty() ? variant.getStart() - 1 : variant.getStart();
        QueryOptions queryOptions = new QueryOptions();
        queryOptions.add("include", "chromosome,start,end");
        QueryResult queryResult = regulatoryRegionDBAdaptor.getAllByRegion(new Region(variant.getChromosome(),
                variantStart, variant.getStart() + variant.getReference().length() - 1), queryOptions);

        List<RegulatoryRegion> regionList = new ArrayList<>(queryResult.getNumResults());
        for(Object object : queryResult.getResult()) {
            DBObject dbObject = (DBObject) object;
            RegulatoryRegion regulatoryRegion = new RegulatoryRegion();
            regulatoryRegion.setChromosome((String) dbObject.get("chromosome"));
            regulatoryRegion.setStart((int) dbObject.get("start"));
            regulatoryRegion.setEnd((int) dbObject.get("end"));
            regulatoryRegion.setType((String) dbObject.get("featureType"));
            regionList.add(regulatoryRegion);
        }

        return regionList;
    }

    private List<ConsequenceType> getConsequenceTypeList(Variant variant, List<Gene> geneList, boolean regulatoryAnnotation) {
        List<RegulatoryRegion> regulatoryRegionList = null;
        if (regulatoryAnnotation) {
            regulatoryRegionList = getAffectedRegulatoryRegions(variant);
        }
        ConsequenceTypeCalculator consequenceTypeCalculator = getConsequenceTypeCalculator(variant);
        List<ConsequenceType> consequenceTypeList = consequenceTypeCalculator.run(variant, geneList, regulatoryRegionList);
        for(ConsequenceType consequenceType : consequenceTypeList) {
            if (nonSynonymous(consequenceType)) {
                consequenceType.setProteinVariantAnnotation(getProteinAnnotation(consequenceType));
            }
        }
        return consequenceTypeList;
    }

    private List<Region> variantListToRegionList(List<Variant> variantList) {
        List<Region> regionList = new ArrayList<>(variantList.size());
        for(Variant variant : variantList) {
            regionList.add(new Region(variant.getChromosome(), variant.getStart(), variant.getStart()));
        }
        return regionList;
    }

    /*
     * Future classes for Async annotations
     */
    class FutureVariationAnnotator implements Callable<List<QueryResult>> {
        private List<Variant> variantList;
        private QueryOptions queryOptions;

        public FutureVariationAnnotator(List<Variant> variantList, QueryOptions queryOptions) {
            this.variantList = variantList;
            this.queryOptions = queryOptions;
        }

        @Override
        public List<QueryResult> call() throws Exception {
            long startTime = System.currentTimeMillis();
            List<QueryResult> variationQueryResultList = variationDBAdaptor.getAllByVariantList(variantList, queryOptions);
            logger.debug("Variation query performance is {}ms for {} variants", System.currentTimeMillis() - startTime, variantList.size());
            return variationQueryResultList;
        }

        public void processResults(Future<List<QueryResult>> conservationFuture, List<QueryResult> variantAnnotationResultList, Set<String> annotatorSet) {
            try {
                while (!conservationFuture.isDone()) {
                    Thread.sleep(1);
                }

                List<QueryResult> variationQueryResults = conservationFuture.get();
                if (variationQueryResults != null) {
                    for (int i = 0; i < variantAnnotationResultList.size(); i++) {
                        List<BasicDBObject> variationDBList = (List<BasicDBObject>) variationQueryResults.get(i).getResult();

                        if (variationDBList != null && variationDBList.size() > 0) {
                            ((VariantAnnotation)variantAnnotationResultList.get(i).getResult().get(0))
                                    .setId(variationDBList.get(0).getString("id", ""));

                            if (annotatorSet.contains("populationFrequencies")) {
                                BasicDBList freqsDBList = (BasicDBList) variationDBList.get(0).get("populationFrequencies");
                                if (freqsDBList != null) {
                                    BasicDBObject freqDBObject;
                                    ((VariantAnnotation)variantAnnotationResultList.get(i).getResult().get(0)).setPopulationFrequencies(new ArrayList<>());
                                    for (int j = 0; j < freqsDBList.size(); j++) {
                                        freqDBObject = ((BasicDBObject) freqsDBList.get(j));
                                        if (freqDBObject != null && freqDBObject.get("refAllele") != null) {
                                            if (freqDBObject.containsKey("study")) {
                                                ((VariantAnnotation)variantAnnotationResultList.get(i).getResult().get(0))
                                                        .getPopulationFrequencies().add(new PopulationFrequency(freqDBObject.get("study").toString(),
                                                        freqDBObject.get("pop").toString(), freqDBObject.get("superPop").toString(),
                                                        freqDBObject.get("refAllele").toString(), freqDBObject.get("altAllele").toString(),
                                                        Float.valueOf(freqDBObject.get("refAlleleFreq").toString()),
                                                        Float.valueOf(freqDBObject.get("altAlleleFreq").toString()), 0.0f, 0.0f, 0.0f));
                                            } else {
                                                ((VariantAnnotation)variantAnnotationResultList.get(i).getResult().get(0))
                                                        .getPopulationFrequencies().add(new PopulationFrequency("1000G_PHASE_3",
                                                        freqDBObject.get("pop").toString(), freqDBObject.get("superPop").toString(),
                                                        freqDBObject.get("refAllele").toString(), freqDBObject.get("altAllele").toString(),
                                                        Float.valueOf(freqDBObject.get("refAlleleFreq").toString()),
                                                        Float.valueOf(freqDBObject.get("altAlleleFreq").toString()), 0.0f, 0.0f, 0.0f));
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } catch (InterruptedException | ExecutionException e) {
                e.printStackTrace();
            }
        }
    }

    class FutureConservationAnnotator implements Callable<List<QueryResult>> {
        private List<Variant> variantList;

        private QueryOptions queryOptions;

        public FutureConservationAnnotator(List<Variant> variantList, QueryOptions queryOptions) {
            this.variantList = variantList;
            this.queryOptions = queryOptions;
        }

        @Override
        public List<QueryResult> call() throws Exception {
            long startTime = System.currentTimeMillis();
            List<QueryResult> conservationQueryResultList = conservedRegionDBAdaptor.getAllScoresByRegionList(variantListToRegionList(variantList), queryOptions);
            logger.debug("Conservation query performance is {}ms for {} variants", System.currentTimeMillis() - startTime, variantList.size());
            return conservationQueryResultList;
        }
        public void processResults(Future<List<QueryResult>> conservationFuture, List<QueryResult> variantAnnotationResultList) {
            try {
                while (!conservationFuture.isDone()) {
                    Thread.sleep(1);
                }

                List<QueryResult> conservationQueryResults = conservationFuture.get();
                if (conservationQueryResults != null) {
                    for (int i = 0; i < variantAnnotationResultList.size(); i++) {
                        ((VariantAnnotation)variantAnnotationResultList.get(i).getResult().get(0))
                                .setConservation((List<Score>) conservationQueryResults.get(i).getResult());
                    }
                }
            } catch (InterruptedException | ExecutionException e) {
                e.printStackTrace();
            }
        }

    }

    class FutureClinicalAnnotator implements Callable<List<QueryResult>> {
        private List<Variant> variantList;
        private QueryOptions queryOptions;

        public FutureClinicalAnnotator(List<Variant> variantList, QueryOptions queryOptions) {
            this.variantList = variantList;
            this.queryOptions = queryOptions;
        }

        @Override
        public List<QueryResult> call() throws Exception {
            long startTime = System.currentTimeMillis();
            List<QueryResult> clinicalQueryResultList = clinicalDBAdaptor.getAllByGenomicVariantList(variantList, queryOptions);
            logger.debug("Clinical query performance is {}ms for {} variants", System.currentTimeMillis() - startTime, variantList.size());
            return clinicalQueryResultList;
        }

        public void processResults(Future<List<QueryResult>> clinicalFuture, List<QueryResult> variantAnnotationResultList) {
            try {
                while (!clinicalFuture.isDone()) {
                    Thread.sleep(1);
                }

                List<QueryResult> clinicalQueryResults = clinicalFuture.get();
                if (clinicalQueryResults != null) {
                    for (int i = 0; i < variantAnnotationResultList.size(); i++) {
                        QueryResult clinicalQueryResult = clinicalQueryResults.get(i);
                        if (clinicalQueryResult.getResult() != null && clinicalQueryResult.getResult().size() > 0) {
                            ((VariantAnnotation)variantAnnotationResultList.get(i).getResult().get(0))
                                    .setVariantTraitAssociation((VariantTraitAssociation) clinicalQueryResult.getResult().get(0));
                        }
                    }
                }
            } catch (InterruptedException | ExecutionException e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void setVariationDBAdaptor(VariationDBAdaptor variationDBAdaptor) {
        this.variationDBAdaptor = variationDBAdaptor;
    }

    @Override
    public void setVariantClinicalDBAdaptor(ClinicalDBAdaptor clinicalDBAdaptor) {
        this.clinicalDBAdaptor = clinicalDBAdaptor;
    }

    @Override
    public void setProteinDBAdaptor(ProteinDBAdaptor proteinDBAdaptor) {
        this.proteinDBAdaptor = proteinDBAdaptor;
    }

    @Override
    public void setConservedRegionDBAdaptor(ConservedRegionDBAdaptor conservedRegionDBAdaptor) {
        this.conservedRegionDBAdaptor = conservedRegionDBAdaptor;
    }

    @Override
    public void setGenomeDBAdaptor(GenomeDBAdaptor genomeDBAdaptor) {
        this.genomeDBAdaptor = genomeDBAdaptor;
    }

    public void setGeneDBAdaptor(GeneDBAdaptor geneDBAdaptor) {
        this.geneDBAdaptor = geneDBAdaptor;
    }

    public void setRegulatoryRegionDBAdaptor(RegulatoryRegionDBAdaptor regulatoryRegionDBAdaptor) {
        this.regulatoryRegionDBAdaptor = regulatoryRegionDBAdaptor;
    }

}
