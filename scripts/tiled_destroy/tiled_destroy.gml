/// @desc cleanup tiled artefacts
/// @arg all_data datastructure used by tiled
var all_data = argument0;

if (not ds_exists(all_data, ds_type_map)) return;

var new_layers = all_data[? "new_layers"];
var new_instances = all_data[? "new_instances"];
var original_depths = all_data[? "original_depths"];

// destroy all istances
for (var i=0; i<ds_list_size(new_instances); i++) {
	var inst = new_instances[| i];
	if (instance_exists(inst)) instance_destroy(inst);
}

// delete all new layers
for (var i=0; i<ds_list_size(new_layers); i++) {
	var layer_id = new_layers[| i];
	if (layer_exists(layer_id)) layer_destroy(layer_id);
}

// restore original layer depth
for(var layer_name=ds_map_find_first(original_depths); not is_undefined(layer_name);  layer_name=ds_map_find_next(original_depths, layer_name)) { 
    var original_depth = ds_map_find_value(original_depths, layer_name);
    var layer_id = layer_get_id(layer_name);
	if (layer_id != -1) layer_depth(layer_id, original_depth);
}

ds_map_destroy(all_data);