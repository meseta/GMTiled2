/// @desc Parse <map><tileset><image>
/// @arg tilesets the tileset map to use to use
/// @arg tileset_name the name of the tileset, needed for adding to the right ds_map
var tilesets = argument0;
var tileset_name = argument1;

// get attributes
var tileset_map = ds_map_find_value(tilesets, tileset_name);
ds_map_add(tileset_map, "image_source", DerpXmlRead_CurGetAttribute("source"));
ds_map_add(tileset_map, "image_width", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("width")));
ds_map_add(tileset_map, "image_height", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("height")));

// get children
while (DerpXmlRead_Read()) {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <image>: " + type + ", " + value)
	
	switch (type) {
		case DerpXmlType_Whitespace:
			break;
		case DerpXmlType_OpenTag:
			show_error("Tiled Parse error: OpenTag " + DerpXmlRead_CurValue() + " not supported in image", true)
			break;
		case DerpXmlType_CloseTag:
			if (value == "image") {
				return;
			}
			else {
				show_error("Tiled Parse error: unexpected CloseTag " + value + " in image", true)
			}
		default:
			show_error("Tiled Parse error: " + DerpXmlRead_CurType() + " not supported in image", true)
			break;
	}
}