/// @desc Parse <map><objectgroup>
/// @args layers the layers map to use
var layers = argument0;

// get attributes
var layer_map = ds_map_create();
ds_map_add(layer_map, "type", "instance");
ds_map_add(layer_map, "id", DerpXmlRead_CurGetAttribute("id"));
ds_map_add(layer_map, "name", DerpXmlRead_CurGetAttribute("name"));
var instances_list = ds_list_create()
ds_map_add_list(layer_map, "instances", instances_list);
var layer_index = ds_list_size(layers);
ds_list_add(layers, layer_map);
ds_list_mark_as_map(layers, layer_index);

// get children
while (DerpXmlRead_Read()) {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <objectgroup>: " + type + ", " + value)
	
	switch (type) {
		case DerpXmlType_Whitespace:
			break;
		case DerpXmlType_OpenTag:
			switch (value) {
				case "object":
					Xtiled_parse_object(instances_list);
					break;
				default:
					show_error("Tiled Parse error: OpenTag " + DerpXmlRead_CurValue() + " not supported in objectgroup", true)
			}
			break;
		case DerpXmlType_CloseTag:
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