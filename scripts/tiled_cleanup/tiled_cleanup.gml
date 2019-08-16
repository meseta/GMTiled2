/// @desc cleanup tiled artefacts
/// @arg all_data datastructure used by tiled
var all_data = argument0;

if (ds_exists(all_data, ds_type_map)) ds_map_destroy(all_data);