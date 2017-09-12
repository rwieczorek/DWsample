/**

Author		Robert Wieczorek
Created		2017-09-12

Purpose		All tables (that have a clustered index), their PS schemes and functions, and the lower and upper boundaries for partitions

**/
CREATE VIEW Auxiliary.PartitionsOnClusteredIndexes
AS

SELECT  
	OBJECT_SCHEMA_NAME(indexes.object_id) AS object_schema
	,OBJECT_NAME(indexes.object_id) AS [object_name]
	,partition_functions.name AS partition_function
	,partition_schemes.name AS partition_scheme
	,partitions.partition_number 
	,data_spaces.name AS partition_filegroup 
	,partition_functions.fanout
	,partition_functions.boundary_value_on_right 	
	,partition_range_values_lower.value AS lower_boundary 
	,partition_range_values_upper.value AS upper_boundary
	,partition_parameters.system_type_id
	,partition_parameters.user_type_id	
FROM    
	sys.destination_data_spaces
    INNER JOIN sys.data_spaces 
		ON destination_data_spaces.data_space_id = data_spaces.data_space_id
	INNER JOIN sys.partition_schemes
		ON destination_data_spaces.partition_scheme_id = partition_schemes.data_space_id
	INNER JOIN sys.partition_functions 
		ON partition_schemes.function_id = partition_functions.function_id
	LEFT JOIN sys.partition_range_values AS partition_range_values_lower
		ON partition_functions.function_id = partition_range_values_lower.function_id
		AND destination_data_spaces.destination_id = partition_range_values_lower.boundary_id + 1													
	LEFT JOIN sys.partition_range_values AS partition_range_values_upper
		ON partition_functions.function_id = partition_range_values_upper.function_id
		AND destination_data_spaces.destination_id = partition_range_values_upper.boundary_id 													
	INNER JOIN sys.indexes
		ON indexes.data_space_id = destination_data_spaces.partition_scheme_id
		AND indexes.type = 1 /* Clustered */
	INNER JOIN sys.partitions
		ON indexes.object_id = partitions.object_id
		AND indexes.index_id = partitions.index_id
		AND destination_data_spaces.destination_id = partitions.partition_number
	INNER JOIN sys.partition_parameters
		ON partition_functions.function_id = partition_parameters.function_id;	

GO
