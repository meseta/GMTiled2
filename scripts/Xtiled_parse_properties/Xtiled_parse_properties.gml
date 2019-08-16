/// @desc Parse <map><objectgroup><object><properties>
/// @arg properties_list the index of the list containing the properties
var properties_list = argument0;

// get children
while DerpXmlRead_Read() {
	var type = DerpXmlRead_CurType();
	var value =  DerpXmlRead_CurValue();
    show_debug_message("Parse <properties>: " + type + ", " + value)
	
	switch (type) {
		case DerpXmlType_Whitespace:
			break;
		case DerpXmlType_OpenTag:
			switch (value) {
				case "property":
					Xtiled_parse_property(properties_list);
					break;
				default:
					Xtiled_parse_skip(value);
			}
			break;
		case DerpXmlType_CloseTag:
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