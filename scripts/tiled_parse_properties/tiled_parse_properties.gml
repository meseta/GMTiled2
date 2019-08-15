/// @desc Parse <map><objectgroup><object><properties>
/// @arg properties_list the index of the list containing the properties

// get attributes
var properties_list = argument0;

// get children
while DerpXmlRead_Read() {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <properties>: " + type + ", " + value)
	
	switch (type) {
		case "Whitespace":
			break;
		case "OpenTag":
			switch (value) {
				case "property":
					tiled_parse_property(properties_list);
					break;
				default:
					tiled_parse_skip(value);
			}
			break;
		case "CloseTag":
			if (value == "properties") {
				return;
			}
			else {
				show_error("Tiled Parse error: unexpected CloseTag " + value + " in properties", true)
			}
		default:
			show_error("Tiled Parse error: " + value + " not supported in properties", true)
			break;
	}
}