/// @desc Parse <map><layer>
/// @args layers the layers map to use
var layers = argument0;

// get attributes
var layer_map = ds_map_create();
ds_map_add(layer_map, "type", "tile");
ds_map_add(layer_map, "id", DerpXmlRead_CurGetAttribute("id"));
ds_map_add(layer_map, "name", DerpXmlRead_CurGetAttribute("name"));
ds_map_add(layer_map, "visible", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("visible")));
ds_map_add(layer_map, "width", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("width")));
ds_map_add(layer_map, "height", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("height")));
ds_map_add(layer_map, "offsetx", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("offsetx")));
ds_map_add(layer_map, "offsety", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("offsety")));
var layer_index = ds_list_size(layers);
ds_list_add(layers, layer_map);
ds_list_mark_as_map(layers, layer_index);

// get children
while DerpXmlRead_Read() {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <layer>: " + type + ", " + value)
	
	switch (type) {
		case DerpXmlType_Whitespace:
			break;
		case DerpXmlType_OpenTag:
			switch (value) {
				case "data":
					Xtiled_parse_data(layer_map);
					break;
				default:
					show_error("Tiled Parse error: OpenTag " + DerpXmlRead_CurValue() + " not supported in layer", true)
			}
			break;
		case DerpXmlType_CloseTag:
			if (value == "layer") {
				return;
			}
			else {
				show_error("Tiled Parse error: unexpected CloseTag " + value + " in layer", true)
			}
		default:
			show_error("Tiled Parse error: " + type + " not supported in layer", true)
			break;
	}
}