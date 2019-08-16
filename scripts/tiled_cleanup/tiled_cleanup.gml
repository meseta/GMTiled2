/// @desc cleanup tiled artefacts without unloading any tiles
///       This requires the map outputted by tiled_read
///       You only need either tiled_destroy or tiled_cleanup
///
/// @arg all_data datastructure used by tiled
var all_data = argument0;
if (ds_exists(all_data, ds_type_map)) ds_map_destroy(all_data);