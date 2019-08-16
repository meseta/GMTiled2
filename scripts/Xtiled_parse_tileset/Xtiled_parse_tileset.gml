/// @desc Parse <map><tileset>
/// @args tilesets the tilesets map to use
var tilesets = argument0;

// get attributes
var tileset_map = ds_map_create();
var tileset_name = DerpXmlRead_CurGetAttribute("name");
ds_map_add(tileset_map, "firstgid", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("firstgid")));
ds_map_add(tileset_map, "tilewidth", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("tilewidth")));
ds_map_add(tileset_map, "tileheight", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("tileheight")));
ds_map_add(tileset_map, "tilecount", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("tilecount")));
ds_map_add(tileset_map, "columns", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("columns")));
ds_map_add_map(tilesets, tileset_name, tileset_map);

// get children
while (DerpXmlRead_Read()) {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <tileset>: " + type + ", " + value)
	
	switch (type) {
		case DerpXmlType_Whitespace:
			break;
		case DerpXmlType_OpenTag:
			switch (value) {
				case "image":
					Xtiled_parse_image(tilesets, tileset_name);
					break;
				case "tile":
					Xtiled_parse_skip("tile");
					break;
				default:
					show_error("Tiled Parse error: OpenTag " + value + " not supported in tileset", true)
			}
			break;
		case DerpXmlType_CloseTag:
			if (value == "tileset") {
				return;
			}
			else {
				show_error("Tiled Parse error: unexpected CloseTag " + value + " in tileset", true)
			}
		default:
			show_error("Tiled Parse error: " + type + " not supported in tileset", true)
			break;
	}
}