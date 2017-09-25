CREATE PARTITION SCHEME [FeedExampleOnePS]
    AS PARTITION [FeedExampleOnePF]
    TO ([Secondary], [Secondary], [Secondary], [Secondary]);