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

package org.opencb.cellbase.mongodb.impl;

import com.mongodb.client.model.Aggregates;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Projections;
import org.bson.Document;
import org.bson.conversions.Bson;
import org.opencb.biodata.models.core.Gene;
import org.opencb.biodata.models.core.Region;
import org.opencb.cellbase.core.api.GeneDBAdaptor;
import org.opencb.cellbase.mongodb.MongoDBCollectionConfiguration;
import org.opencb.commons.datastore.core.Query;
import org.opencb.commons.datastore.core.QueryOptions;
import org.opencb.commons.datastore.core.QueryResult;
import org.opencb.commons.datastore.mongodb.MongoDataStore;

import java.util.*;
import java.util.function.Consumer;

/**
 * Created by imedina on 25/11/15.
 */
public class GeneMongoDBAdaptor extends MongoDBAdaptor implements GeneDBAdaptor<Gene> {

    public GeneMongoDBAdaptor(String species, String assembly, MongoDataStore mongoDataStore) {
        super(species, assembly, mongoDataStore);
        mongoDBCollection = mongoDataStore.getCollection("gene");

        logger.debug("GeneMongoDBAdaptor: in 'constructor'");
    }

    @Override
    public QueryResult<Gene> next(Query query, QueryOptions options) {
        return null;
    }

    @Override
    public QueryResult nativeNext(Query query, QueryOptions options) {
        return null;
    }

    @Override
    public QueryResult getIntervalFrequencies(Query query, int intervalSize, QueryOptions options) {
        if (query.getString("region") != null) {
            Region region = Region.parseRegion(query.getString("region"));
            Bson bsonDocument = parseQuery(query);
            return getIntervalFrequencies(bsonDocument, region, intervalSize, options);
        }
        return null;
    }

    @Override
    public QueryResult<Long> count(Query query) {
        Bson bsonDocument = parseQuery(query);
        return mongoDBCollection.count(bsonDocument);
    }

    @Override
    public QueryResult distinct(Query query, String field) {
        Bson bsonDocument = parseQuery(query);
        return mongoDBCollection.distinct(field, bsonDocument);
    }

    @Override
    public QueryResult stats(Query query) {
        return null;
    }

    @Override
    public QueryResult<Gene> get(Query query, QueryOptions options) {
        return null;
    }

    @Override
    public QueryResult nativeGet(Query query, QueryOptions options) {
        Bson bson = parseQuery(query);
        return mongoDBCollection.find(bson, options);
    }

    @Override
    public Iterator<Gene> iterator(Query query, QueryOptions options) {
        return null;
    }

    @Override
    public Iterator nativeIterator(Query query, QueryOptions options) {
        Bson bson = parseQuery(query);
        return mongoDBCollection.nativeQuery().find(bson, options).iterator();
    }

    @Override
    public void forEach(Query query, Consumer<? super Object> action, QueryOptions options) {
        Objects.requireNonNull(action);
        Iterator iterator = nativeIterator(query, options);
        while (iterator.hasNext()) {
            action.accept(iterator.next());
        }
    }

    @Override
    public QueryResult rank(Query query, String field, int numResults, boolean asc) {
        return null;
    }

    @Override
    public QueryResult groupBy(Query query, String field, QueryOptions options) {
        Bson bsonQuery = parseQuery(query);
        return groupBy(bsonQuery, field, "name", options);
    }

    @Override
    public QueryResult groupBy(Query query, List<String> fields, QueryOptions options) {
        Bson bsonQuery = parseQuery(query);
        return groupBy(bsonQuery, fields, "name", options);
    }

    @Override
    public QueryResult getTfbs(Query query, QueryOptions queryOptions) {
        Bson bsonQuery = parseQuery(query);
        Bson match = Aggregates.match(bsonQuery);

        Bson project = Aggregates.project(Projections.include("transcripts.tfbs"));
        Bson unwind = Aggregates.unwind("$transcripts");
        Bson unwind2 = Aggregates.unwind("$transcripts.tfbs");

        // This project the three fields of Xref to the top of the object
        Document document = new Document("tfName", "$transcripts.tfbs.tfName");
        document.put("pwm", "$transcripts.tfbs.pwm");
        document.put("chromosome", "$transcripts.tfbs.chromosome");
        document.put("start", "$transcripts.tfbs.start");
        document.put("end", "$transcripts.tfbs.end");
        document.put("strand", "$transcripts.tfbs.strand");
        document.put("relativeStart", "$transcripts.tfbs.relativeStart");
        document.put("relativeEnd", "$transcripts.tfbs.relativeEnd");
        document.put("score", "$transcripts.tfbs.score");
        Bson project1 = Aggregates.project(document);

        return mongoDBCollection.aggregate(Arrays.asList(match, project, unwind, unwind2, project1), queryOptions);
    }

    private Bson parseQuery(Query query) {
        List<Bson> andBsonList = new ArrayList<>();

        createRegionQuery(query, QueryParams.REGION.key(), MongoDBCollectionConfiguration.GENE_CHUNK_SIZE, andBsonList);

        createOrQuery(query, QueryParams.ID.key(), "id", andBsonList);
        createOrQuery(query, QueryParams.NAME.key(), "name", andBsonList);
        createOrQuery(query, QueryParams.BIOTYPE.key(), "biotype", andBsonList);
        createOrQuery(query, QueryParams.XREFS.key(), "transcripts.xrefs.id", andBsonList);

        createOrQuery(query, QueryParams.TRANSCRIPT_ID.key(), "transcripts.id", andBsonList);
        createOrQuery(query, QueryParams.TRANSCRIPT_NAME.key(), "transcripts.name", andBsonList);
        createOrQuery(query, QueryParams.TRANSCRIPT_BIOTYPE.key(), "transcripts.biotype", andBsonList);

        createOrQuery(query, QueryParams.TFBS_NAME.key(), "transcripts.tfbs.name", andBsonList);
        createOrQuery(query, QueryParams.ANNOTATION_DISEASE_ID.key(), "annotation.diseases.id", andBsonList);
        createOrQuery(query, QueryParams.ANNOTATION_DISEASE_NAME.key(), "annotation.diseases.name", andBsonList);
        createOrQuery(query, QueryParams.ANNOTATION_EXPRESSION_GENE.key(), "annotation.expression.gene", andBsonList);
        createOrQuery(query, QueryParams.ANNOTATION_EXPRESSION_TISSUE.key(), "annotation.expression.tissue", andBsonList);
        createOrQuery(query, QueryParams.ANNOTATION_DRUGS_NAME.key(), "annotation.drugs.name", andBsonList);
        createOrQuery(query, QueryParams.ANNOTATION_DRUGS_GENE.key(), "annotation.drugs.gene", andBsonList);

        if (andBsonList.size() > 0) {
            return Filters.and(andBsonList);
        } else {
            return new Document();
        }
    }

}
