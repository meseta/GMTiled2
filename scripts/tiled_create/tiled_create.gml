/// @desc Creates the tile layers from the tile
/// @args all_data the datastructure to use
var all_data = argument0;

var map_attribs = all_data[? "map_attribs"];
var tilesets = all_data[? "tilesets"];
var layers = all_data[? "layers"];

// datastructures for undoing/unloading later
var new_layers = ds_list_create();
ds_map_add_list(all_data, "new_layers", new_layers)

var original_depths = ds_map_create();
ds_map_add_map(all_data, "original_depths", original_depths)

var new_instances = ds_list_create();
ds_map_add_list(all_data, "new_instances", new_instances);

// check attribs
if (map_attribs[? "orientation"] != "orthogonal") {
	show_error("Orientation type " + map_attribs[? "orientation"] + " not supported. Use orthogonal only", true);
}
if (map_attribs[? "renderorder"] != "right-down") {
	show_error("Render order " + map_attribs[? "renderorder"] + " not supported. Use right-down only", true);
}
	
// calculate layer gid mapping
var tilesets_gid = [];
for(var key=ds_map_find_first(tilesets); not is_undefined(key);  key=ds_map_find_next(tilesets, key)) { 
    var tileset = ds_map_find_value(tilesets, key);
	var firstgid = real(tileset[? "firstgid"]);
	for (var j=firstgid; j<firstgid+real(tileset[? "tilecount"]); j++) {
		tilesets_gid[j] = key;
	}
}

var propmap = [0, 6, 2, 7, 1, 4, 3, 5]; // tiled to GM property mapping

// create the layers and whatnot
for (var i = 0; i<ds_list_size(layers); i++) {
	var layer_map = layers[| i];
	var type = layer_map[? "type"]
	var name = layer_map[? "name"]
	show_debug_message("Layer[" + string(i) + "]: " + name + " type " + type);
	
	// check and create layer
	var new_depth = depth - (i+1) * 100;
	var layer_id = layer_get_id(name);
	if (layer_id == -1) {
		layer_id = layer_create(new_depth);
		ds_list_add(new_layers, layer_id);
	}
	else {
		show_debug_message("Moving layer " + name + " to " + string(new_depth));
		if (not ds_map_exists(original_depths, name)) { // store depth for later restore
			original_depths[? name] = layer_get_depth(layer_id);	
		}
		layer_depth(layer_id, new_depth);
	}
	
	switch (type) {
		case "instance":
			var instance_list = layer_map[? "instances"];
			for (var j=0; j<ds_list_size(instance_list); j++) {
				var instance = instance_list[| j];
				
				if (not is_string(instance[? "name"])) {  // skip instances with no name
					show_debug_message("Object has no name, skipping");
					continue;
				}
				if (asset_get_type(instance[? "name"]) != asset_object) { // not an object
					show_debug_message("Object " + instance[? "name"] + " doesn't exist, skipping");
					continue; 
				}
				
				var object = asset_get_index(instance[? "name"]);
				var inst = instance_create_layer(instance[? "x"], instance[? "y"], layer_id, object);
				show_debug_message("Create instance " + instance[? "name"])
				ds_list_add(new_instances, inst);
				
				var properties = instance[? "properties"];
				
				for (var k=0; k<ds_list_size(properties); k++) {
					var	prop = properties[| k];
					var value = prop[? "value"];
					switch (prop[? "type"]) {
						case "float":
						case "int":
							value = real(value);
							break;
						case "bool":
							value = (value == "true")
							break;
						case "color":
							value = Xtiled_convert_color(value);
							break;
					}
					
					show_debug_message("Set property " + prop[? "name"] + " to " + string(value));
					variable_instance_set(inst, prop[? "name"], value);
				}
				
				if (not is_undefined(instance[? "visible"]) and instance[? "visible"] == "0") {
					inst.visible = false;
				}
				
			}
			break;
		case "tile":
			// data
			var raw = layer_map[? "data"];
			var encoding = layer_map[? "encoding"];
			var compression = layer_map[? "compression"];
			
			if (encoding == "base64") {
				var trimmed = string_replace_all(raw, " ", "");
				var decoded = buffer_base64_decode(trimmed);
				
				if (compression == "zlib") {
					var data = buffer_decompress(decoded);
					buffer_delete(decoded);
				}
				else if (is_undefined(compression)) {
					var data = decoded;
				}
				else {
					show_error("Compression " + compression + " not supported! Use zlib or raw", true)	
				}
			}
			else {
				show_error("Encoding " + encoding + " not supported! use base64", true);
			}
			
			// prep assets
			var new_tilelayers = ds_map_create();
			
			// loop through data
			buffer_seek(data, buffer_seek_start, 0);
			for (var j=0; j<buffer_get_size(data)/4; j++) {
				var tile_raw = buffer_read(data, buffer_u32);
				if (tile_raw == 0) continue;
				
				// TODO: filter tile number here
				var tile = tile_raw & 0x1fffffff;
				var props = tile_raw >> 29;
				var gmprops = propmap[props];
				
				// fetch tile data
				var tileset_name = tilesets_gid[tile];
				var tileset_map = tilesets[? tileset_name];
				
				// calculate tile number
				var tile_number = tile - tileset_map[? "firstgid"];
				tile_number |= gmprops << 28; // re-attach tile properties
				
				// calculate tilelayer, create tilemap if it doesn't exist
				var tilelayer = new_tilelayers[? tileset_name]
				if (is_undefined(tilelayer)) {
					var tileset = asset_get_index(tileset_name);
					if (tileset == -1) {
						show_error("Could not find tileset " + tileset_name, true);	
					}
					var tilewidth = layer_map[? "width"];
					var tileheight = layer_map[? "height"];
			
					var offsetx = layer_map[? "offsetx"]
					var offsety = layer_map[? "offsety"]
					if (is_undefined(offsetx)) offsetx = 0;
					if (is_undefined(offsety)) offsety = 0;
					tilelayer = layer_tilemap_create(layer_id, offsetx, offsety, tileset, tilewidth, tileheight);
					new_tilelayers[? tileset_name] = tilelayer;
				}
				
				// calculate cell position
				var xscale = map_attribs[? "tilewidth"] / tileset_map[? "tilewidth"];
				var yscale = map_attribs[? "tileheight"] / tileset_map[? "tileheight"];
				var xcell = floor(xscale * (j % layer_map[? "width"]));
				var ycell = floor(yscale * (j / layer_map[? "width"]));
				
				// assign tile
				tilemap_set(tilelayer, tile_number, xcell, ycell);
				//show_debug_message(tileset_name + ": " + string(tile) + "("+string(gmprops)+"), " + string(xcell) + ", " + string(ycell));
			}
			
			buffer_delete(data);
			ds_map_destroy(new_tilelayers);
			
			break;
		default:
			show_error("Layer type " + type + " not supported", true);
	}
	
}