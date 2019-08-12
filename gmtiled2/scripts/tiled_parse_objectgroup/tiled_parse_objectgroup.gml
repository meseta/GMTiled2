/// @desc Parse <map><objectgroup>

// get attributes
var layer_map = ds_map_create();
ds_map_add(layer_map, "type", "instance");
ds_map_add(layer_map, "id", DerpXmlRead_CurGetAttribute("id"));
ds_map_add(layer_map, "name", DerpXmlRead_CurGetAttribute("name"));
var layer_index = ds_list_size(layers);
ds_list_add(layers, layer_map);
ds_list_mark_as_map(layers, layer_index);

// get children
while (DerpXmlRead_Read()) {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <objectgroup>: " + type + ", " + value)
	
	switch (type) {
		case "Whitespace":
			break;
		case "OpenTag":
			show_error("Tiled Parse error: OpenTag " + value + " not supported in objectgroup", true)
			break;
		case "CloseTag":
			if (value == "objectgroup") {
				return;
			}
			else {
				show_error("Tiled Parse error: unexpected CloseTag " + value + " in objectgroup", true)
			}
		default:
			show_error("Tiled Parse error: " + type + " not supported in objectgroup", true)
			break;
	}
}