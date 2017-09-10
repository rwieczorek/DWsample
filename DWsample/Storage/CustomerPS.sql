CREATE PARTITION SCHEME [CustomerPS]
    AS PARTITION [CustomerPF]
    TO ([Secondary], [Secondary], [Secondary], [Secondary]);
