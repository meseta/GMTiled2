/// @desc Parse <map>
/// @args all_data the datastructure to use
var all_data = argument0;

var map_attribs = all_data[? "map_attribs"];
var tilesets = all_data[? "tilesets"];
var layers = all_data[? "layers"];

// get attributes
ds_map_add(map_attribs, "version", DerpXmlRead_CurGetAttribute("version"));
ds_map_add(map_attribs, "tiledversion", DerpXmlRead_CurGetAttribute("tiledversion"));
ds_map_add(map_attribs, "orientation", DerpXmlRead_CurGetAttribute("orientation"));
ds_map_add(map_attribs, "renderorder", DerpXmlRead_CurGetAttribute("renderorder"));
ds_map_add(map_attribs, "width", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("width")));
ds_map_add(map_attribs, "height", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("height")));
ds_map_add(map_attribs, "tilewidth", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("tilewidth")));
ds_map_add(map_attribs, "tileheight", Xtiled_real_or_undef(DerpXmlRead_CurGetAttribute("tileheight")));

while DerpXmlRead_Read() {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <map>: " + type + ", " + value)
	
	switch (type) {
		case DerpXmlType_Whitespace:
			break;
		case DerpXmlType_OpenTag:
			switch (value) {
				case "tileset":
					Xtiled_parse_tileset(tilesets);
					break;
				case "layer":
					Xtiled_parse_layer(layers);
					break;
				case "objectgroup":
					Xtiled_parse_objectgroup(layers);
					break;
				default:
					show_error("Tiled Parse error: OpenTag " + value + " not supported in map", true)
			}
			break;
		case DerpXmlType_CloseTag:
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