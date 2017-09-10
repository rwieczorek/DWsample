CREATE PARTITION SCHEME [CustomerArchivePS]
    AS PARTITION [CustomerArchivePF]
    TO ([Archive], [Archive], [Archive], [Archive]);
