/// @desc Parse <map>
// get attributes
ds_map_add(map_attribs, "version", DerpXmlRead_CurGetAttribute("version"));
ds_map_add(map_attribs, "tiledversion", DerpXmlRead_CurGetAttribute("tiledversion"));
ds_map_add(map_attribs, "orientation", DerpXmlRead_CurGetAttribute("orientation"));
ds_map_add(map_attribs, "renderorder", DerpXmlRead_CurGetAttribute("renderorder"));
ds_map_add(map_attribs, "width", real_or_undef(DerpXmlRead_CurGetAttribute("width")));
ds_map_add(map_attribs, "height", real_or_undef(DerpXmlRead_CurGetAttribute("height")));
ds_map_add(map_attribs, "tilewidth", real_or_undef(DerpXmlRead_CurGetAttribute("tilewidth")));
ds_map_add(map_attribs, "tileheight", real_or_undef(DerpXmlRead_CurGetAttribute("tileheight")));

while DerpXmlRead_Read() {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <map>: " + type + ", " + value)
	
	switch (type) {
		case "Whitespace":
			break;
		case "OpenTag":
			switch (value) {
				case "tileset":
					tiled_parse_tileset();
					break;
				case "layer":
					tiled_parse_layer();
					break;
				case "objectgroup":
					tiled_parse_objectgroup();
					break;
				default:
					show_error("Tiled Parse error: OpenTag " + value + " not supported in map", true)
			}
			break;
		case "CloseTag":
			if (value == "map") {
				return;
			}
			else {
				show_error("Tiled Parse error: unexpected CloseTag " + value + " in map", true)
			}
		default:
			show_error("Tiled Parse error: " + type + " not supported in map", true)
			break;
	}
}