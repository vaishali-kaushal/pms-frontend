import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:performance_management_system/pms.dart';

void successToast(String msg) {
  Get.snackbar(
    "Success !!!",
    msg,
    duration: 5.seconds,
    backgroundColor: ColorRes.green,
    colorText: ColorRes.white,
    mainButton: TextButton(
      onPressed: Get.back,
      child: const Icon(
        Icons.close,
        color: ColorRes.white,
      ),
    ),
  );
}

void errorToast(String msg) {
  Get.snackbar(
    "Error !!!",
    msg,
    duration: 10.seconds,
    backgroundColor: ColorRes.appRedColor,
    colorText: ColorRes.white,
    mainButton: TextButton(
      onPressed: Get.back,
      child: const Icon(
        Icons.close,
        color: ColorRes.white,
      ),
    ),
  );
  print("debugMsg=>$msg");
}

String formatDateStringFunc(String? dateString) {
  if (dateString == null) {
    return '';
  }

  try {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    return formattedDate;
  } catch (e) {
    print('Error parsing date: $e');
    return dateString;
  }
}


String formatDateString(String? dateString) {
  if (dateString == null) {
    return '';
  }

  try {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd MMM yyyy').format(dateTime);
    return formattedDate;
  } catch (e) {
    print('Error parsing date: $e');
    return dateString;
  }
}

String formatDateTimeString(String? dateString) {
  if (dateString == null) {
    return '';
  }

  try {
    DateTime dateTime = DateTime.parse(dateString);
    String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
    return formattedDate;
  } catch (e) {
    print('Error parsing date: $e');
    return dateString;
  }
}

commonBoxShadow(){
  return BoxShadow(
    offset: const Offset(0,4),
    color: ColorRes.black.withOpacity(0.25),
    blurRadius: 4,
    spreadRadius: 0,
  );
}

headerText(String headerTitle) {
  return Padding(
    padding: EdgeInsets.only(bottom: 1.h),
    child: Text(
      headerTitle,
      style: styleW600S20.copyWith(color: ColorRes.appBlueColor),
    ),
  );
}

commonSmallDivider({Color? dividerColor}){
  return Center(
      child: Container(
        height: 4.0,
        width: 25.w,
        decoration: BoxDecoration(
          color: dividerColor ?? Colors.black,
          borderRadius: BorderRadius.circular(5.0),
        ),
      )
  );
}

class FilePickerHelper {
  static Future<FileModel?> pickSingleFile({
    required String keyName, // now required from caller
    int maxFileSizeInKB = 100,
    List<String> allowedExtensions = const ['pdf', 'jpg', 'jpeg', 'png'],
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (result != null) {
      PlatformFile file = result.files.single;

      // Validate size
      if (file.size > maxFileSizeInKB * 1024) {
        toastMsg("File size must be less than $maxFileSizeInKB KB");
        return null;
      }

      // Create FileModel for mobile/web
      if (kIsWeb) {
        return FileModel(
          keyName: keyName,
          fileBytes: file.bytes,
          fileName: file.name,
        );
      } else {
        return FileModel(
          keyName: keyName,
          file: io.File(file.path!),
        );
      }
    }
    return null;
  }
}

class ExperienceDropdown extends StatelessWidget {
  final int? selectedYears;
  final int? selectedMonths;
  final Function(int?) onYearsChanged;
  final Function(int?) onMonthsChanged;
  final String? errorText;

  const ExperienceDropdown({
    super.key,
    this.selectedYears,
    this.selectedMonths,
    required this.onYearsChanged,
    required this.onMonthsChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Experience", style: styleW500S14),
        const SizedBox(height: 8),
        Row(
          children: [
            // Years dropdown
            Expanded(
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: "Years",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                value: selectedYears,
                isExpanded: true,
                items: List.generate(31, (i) => DropdownMenuItem(
                  value: i,
                  child: Text("$i"),
                )),
                onChanged: onYearsChanged,
              ),
            ),
            appSizedBox(width: 20),
            // Months dropdown
            Expanded(
              child: DropdownButtonFormField<int>(
                decoration: InputDecoration(
                  labelText: "Months",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                value: selectedMonths,
                isExpanded: true,
                items: List.generate(12, (i) => DropdownMenuItem(
                  value: i,
                  child: Text("$i"),
                )),
                onChanged: onMonthsChanged,
              ),
            ),
          ],
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 8),
            child: Text(
              errorText!,
              style: TextStyle(color: Colors.red[700], fontSize: 12),
            ),
          ),
      ],
    );
  }
}

class CommonMultiSelectDropdown<T> extends StatefulWidget {
  final List<T> items;
  final List<String> selectedIds;
  final String labelText;
  final String Function(T) getId;
  final String Function(T) getLabel;
  final Function(List<String>) onSelectionChanged;
  final String? errorText;
  final bool isRequired;

  const CommonMultiSelectDropdown({
    Key? key,
    required this.items,
    required this.selectedIds,
    required this.getId,
    required this.getLabel,
    required this.onSelectionChanged,
    this.errorText,
    required this.labelText,
    this.isRequired = false,
  }) : super(key: key);

  @override
  State<CommonMultiSelectDropdown<T>> createState() => _MultiSelectDropdownState<T>();
}

class _MultiSelectDropdownState<T> extends State<CommonMultiSelectDropdown<T>> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final GlobalKey _key = GlobalKey();

  late List<String> _tempSelected;
  late List<T> _filteredItems;
  void Function(void Function())? _setOverlayState;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selectedIds);
    _filteredItems = List.from(widget.items);
    _updateControllerText();

    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      if (_setOverlayState != null) {
        _setOverlayState!(() {
          _filteredItems = widget.items
              .where((item) => widget.getLabel(item).toLowerCase().contains(query))
              .toList();
        });
      } else {
        setState(() {
          _filteredItems = widget.items
              .where((item) => widget.getLabel(item).toLowerCase().contains(query))
              .toList();
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant CommonMultiSelectDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items || oldWidget.selectedIds != widget.selectedIds) {
      _filteredItems = List.from(widget.items);
      _tempSelected = List.from(widget.selectedIds);
      _updateControllerText();
      setState(() {});
    }
  }

  void _updateControllerText() {
    _controller.text = widget.items
        .where((item) => _tempSelected.contains(widget.getId(item)))
        .map(widget.getLabel)
        .join(', ');
  }

  void _toggleDropdown() {
    // Check if items are available, if not, do not open the dropdown
    if (widget.items.isEmpty) {
      return; // If no items, return without opening dropdown
    }

    _tempSelected = List.from(widget.selectedIds); // Sync on open
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void _closeDropdown() {
    widget.onSelectionChanged(_tempSelected);
    _updateControllerText();
    _overlayEntry?.remove();
    _overlayEntry = null;
    _searchController.clear();
    _filteredItems = List.from(widget.items);
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // 👇 This handles tap outside to close
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeDropdown,
                behavior: HitTestBehavior.translucent,
                child: Container(), // transparent overlay
              ),
            ),

            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 5,
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0.0, size.height + 5),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(8),
                  child: StatefulBuilder(
                    builder: (context, setOverlayState) {
                      _setOverlayState = setOverlayState;
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: "Search...",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 200),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              children: _filteredItems.map((item) {
                                final id = widget.getId(item);
                                final name = widget.getLabel(item);
                                final isSelected = _tempSelected.contains(id);
                                return CheckboxListTile(
                                  title: Text(name, style: styleW400S14),
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setOverlayState(() {
                                      if (value == true) {
                                        _tempSelected.add(id);
                                      } else {
                                        _tempSelected.remove(id);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            child: ElevatedButton(
                              onPressed: _closeDropdown,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorRes.appBlueColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Done",
                                style: styleW400S12.copyWith(color: ColorRes.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: AbsorbPointer(
          child: TextFormField(
            key: _key,
            controller: _controller,
            readOnly: true,
            style: styleW400S14,
            decoration: InputDecoration(
              labelText: widget.labelText,
              errorText: widget.errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
                suffixIcon: Icon(
                  Icons.arrow_drop_down,
                  color: widget.items.isEmpty ? Colors.grey.shade400 :  Colors.grey.shade800 // grey if disabled, black otherwise
                ),
          ),
          ),
        ),
      ),
    );
  }
}

class DatePickerFormField extends StatelessWidget {
  final String label;
  final DateTime? selectedDate;
  final Function(DateTime) onDateSelected;
  final String? errorText;

  const DatePickerFormField({
    super.key,
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final text = selectedDate != null
        ? "${selectedDate!.day.toString().padLeft(2, '0')}-"
        "${selectedDate!.month.toString().padLeft(2, '0')}-"
        "${selectedDate!.year}"
        : "";

    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: text),
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? now,
          firstDate: DateTime(1950),
          lastDate: DateTime(now.year + 1),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
    );
  }
}

class CommonSearchableDropdown<T> extends StatelessWidget {
  final List<T> items;
  final String? valueId; // 👈 selected value's id
  final String Function(T) getItemValue; // 👈 how to extract id
  final String Function(T) getItemLabel;
  final void Function(T?) onChanged;
  final String? Function(T?)? validator;
  final String? errorText;
  final String labelText;
  final String searchHintText;
  final bool isExpanded;
  final bool isRequired;
  final TextEditingController? searchController;
  final bool Function(T item, String searchValue)? searchMatchFn;

  const CommonSearchableDropdown({
    Key? key,
    required this.items,
    required this.getItemValue,
    this.valueId,
    required this.getItemLabel,
    required this.onChanged,
    this.validator,
    this.errorText,
    required this.labelText,
    this.searchHintText = 'Search...',
    this.isExpanded = true,
    this.isRequired = false,
    this.searchController,
    this.searchMatchFn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    T? selectedItem;
    if (valueId != null) {
      try {
        selectedItem = items.firstWhere((item) => getItemValue(item) == valueId);
      } catch (e) {
        selectedItem = null;
      }
    }return DropdownButtonFormField2<T>(
      isExpanded: isExpanded,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 8), // Tighten input box
      ),
      value: selectedItem,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(
            getItemLabel(item),
            style: styleW400S14,
            overflow: TextOverflow.ellipsis, // Optional: prevent overflow
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.symmetric(horizontal: 8), // 👈 Control left padding here
        height: 48,
        width: double.infinity,
      ),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      dropdownSearchData: DropdownSearchData(
        searchController: searchController,
        searchInnerWidget: Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: searchHintText,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        searchInnerWidgetHeight: 50,
        searchMatchFn: (item, searchValue) {
          if (searchMatchFn != null) {
            return searchMatchFn!(item.value!, searchValue);
          }
          return getItemLabel(item.value!).toLowerCase().contains(searchValue.toLowerCase());
        },
      ),
      onMenuStateChange: (isOpen) {
        if (!isOpen) {
          searchController?.clear();
        }
      },
    );

  }
}

class CommonFilePickerField extends StatelessWidget {
  final String labelText;
  final String? selectedFileName;
  final VoidCallback onTap;
  final bool isRequired;

  const CommonFilePickerField({
    super.key,
    required this.labelText,
    required this.onTap,
    this.selectedFileName,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: InkWell(
        onTap: onTap,
        child: InputDecorator(
          decoration: buildInputDecoration(
            labelText: isRequired ? "$labelText *" : labelText,
            suffixIcon: const Icon(Icons.attach_file),
          ),
          child: Text(
            selectedFileName ?? "No file selected",
            style: styleW400S14,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}

void showRightSlideDialog({
  required BuildContext context,
  required Widget child,
  String barrierLabel = "",
  double widthFactor = 0.4,
  Color backgroundColor = Colors.white,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: barrierLabel,
    barrierColor: Colors.black.withOpacity(0.2),
    transitionDuration: const Duration(milliseconds: 100),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: backgroundColor,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * widthFactor,
            height: MediaQuery.of(context).size.height,
            child: child, // No padding or margin
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

class TableColumnConfig {
  final String title;
  final double? width;
  final int? flex;

  TableColumnConfig(this.title, {this.width, this.flex});
}

class CommonPaginatedTable<T> extends StatelessWidget {
  final List<T> data;
  final bool isLoading;
  final List<TableColumnConfig> headers;
  final TableRow Function(T, int) rowBuilder;
  final int rowsPerPage;
  final List<int> rowsPerPageOptions;
  final Function(int?)? onRowsPerPageChanged;
  final Function(String)? onSearchChanged;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final int currentPage;
  final int totalItems;

  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;

  const CommonPaginatedTable({
    required this.data,
    required this.isLoading,
    required this.headers,
    required this.rowBuilder,
    required this.rowsPerPage,
    required this.rowsPerPageOptions,
    required this.onRowsPerPageChanged,
    required this.onSearchChanged,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.currentPage,
    required this.totalItems,
    this.emptyTitle = "No Data Found!",
    this.emptySubtitle = "Data will appear here once available",
    this.emptyIcon = LucideIcons.info,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalPages = (totalItems / rowsPerPage).ceil();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          _buildTopControls(context),
          appSizedBox(height: 1.h),
          if (isLoading)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: const Center(child: CircularProgressIndicator()),
            )
          else if (data.isEmpty)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: NoDataWidget(
                title: emptyTitle,
                subtitle: emptySubtitle,
                icon: emptyIcon,
              ),
            )
          else ...[
              Container(
                decoration: BoxDecoration(border: Border.all(color: Colors.grey)), // Outer table border
                child: Column(
                  children: [
                    // Header Row
                    Row(
                      children: headers.map((h) {
                        return Expanded(
                          flex: h.flex ?? 1,
                          child: Container(
                            height: 60,
                            padding: const EdgeInsets.all(2),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(color: Colors.grey),
                                bottom: BorderSide(color: Colors.grey),
                              ),
                            ),
                            child: Text(h.title, style: styleW600S14,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    // Data Rows
                    ...List.generate(data.length, (index) {
                      final row = rowBuilder(data[index], index); // returns a Row or list of widgets
                      return Row(
                        children: List.generate(headers.length, (colIndex) {
                          return Expanded(
                            flex: headers[colIndex].flex ?? 1,
                            child: Container(
                              height: 60,
                              padding: const EdgeInsets.all(2),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border(
                                  right: BorderSide(color: Colors.grey),
                                  bottom: BorderSide(color: Colors.grey),
                                ),
                              ),
                              child: DefaultTextStyle.merge(
                                style: styleW400S13,
                                child: row.children[colIndex],
                              ),
                             // child: row.children[colIndex],
                            ),
                          );
                        }),
                      );
                    }),
                  ],
                ),
              ),
               appSizedBox(height: 1.5.h),
              _buildPaginationControls(totalPages),
            ],
        ],
      ),
    );
  }

  Widget _buildTopControls(BuildContext context) {
    return Row(
      children: [
        Row(
          children: [
            const Text('Show'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: rowsPerPage,
                  isDense: true,
                  onChanged: onRowsPerPageChanged,
                  items: rowsPerPageOptions
                      .map((value) => DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  ))
                      .toList(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text('entries'),
          ],
        ),
        const Spacer(),
        SizedBox(
          width: 250,
          child: TextField(
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              isDense: true,
              hintText: "Search...",
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade400)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade600)),
              contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            ),
            onChanged: onSearchChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationControls(int totalPages) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: currentPage > 0 ? onPreviousPage : null,
        ),
        Text("Page ${currentPage + 1} of $totalPages"),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: (currentPage + 1) * rowsPerPage < totalItems ? onNextPage : null,
        ),
      ],
    );
  }

  static Widget _cell(String text, [TextStyle? style]) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8.0),
      child: Text(text, style: style, textAlign: TextAlign.center),
    );
  }
}

Widget commonTableCell(String text, {TextStyle? style, Alignment alignment = Alignment.center}) {
  return Container(
    height: 60,
    alignment: alignment,
    padding: const EdgeInsets.all(8.0),
    child: Text(
      text,
      style: style,
      textAlign: TextAlign.center,
    ),
  );
}

Widget commonDeleteButtonCell({
  required BuildContext context,
  required VoidCallback onConfirm,
  Color iconColor = Colors.red,
}) {
  return SizedBox(
    height: 60,
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: IconButton(
          icon: Icon(Icons.delete, color: iconColor),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Confirm Delete'),
                content: const Text('Are you sure you want to delete this role?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                      onConfirm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorRes.appBlueColor,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}

class CommonInfoRow extends StatelessWidget {
  final String title;
  final String value;
  final bool highlightStatus;
  final TextStyle? titleStyle;
  final TextStyle? valueStyle;

  const CommonInfoRow({
    super.key,
    required this.title,
    required this.value,
    this.highlightStatus = false,
    this.titleStyle,
    this.valueStyle,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
        return Colors.green;
      case "pending":
        return Colors.orange;
      case "delayed":
        return Colors.red;
      case "in progress":
      case "verified":
        return Colors.blueAccent;
      default:
        return Colors.black87;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: "$title: ",
              style: titleStyle ?? styleW500S14,
            ),
            TextSpan(
              text: value.isNotEmpty ? value : '-',
              style: valueStyle ??
                  styleW400S14.copyWith(color: highlightStatus ? _getStatusColor(value) : ColorRes.black),
            ),
          ],
        ),
      ),
    );
  }
}

class CommonSectionCard extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final String? sectionName; // <- field for section name above the card

  const CommonSectionCard({
    required this.children,
    this.title,
    this.sectionName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center, // for centering the section name
      children: [
        if (sectionName != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              sectionName!,
              style: styleW500S18, // use your preferred style
              textAlign: TextAlign.center,
            ),
          ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          shadowColor: Colors.grey.shade400,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(title!, style: styleW600S18),
                if (title != null)
                  const SizedBox(height: 12),
                ...children,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StatusTimeline<T> extends StatelessWidget {
  final List<T> logs;
  final String title;
  final TextStyle? titleStyle;
  final TextStyle? statusStyle;
  final TextStyle? dateStyle;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  // Mappers to extract fields from T
  final String? Function(T) getStatus;
  final String? Function(T) getStatusUpdatedAt;
  final String? Function(T) getRemarks;
  final String? Function(T) getDueDate;

  const StatusTimeline({
    Key? key,
    required this.logs,
    required this.getStatus,
    required this.getStatusUpdatedAt,
    required this.getRemarks,
    required this.getDueDate,
    this.title = "Action Logs",
    this.titleStyle,
    this.statusStyle,
    this.dateStyle,
    this.labelStyle,
    this.valueStyle,
  }) : super(key: key);

  IconData getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return LucideIcons.checkCircle;
      case 'pending':
        return LucideIcons.clock;
      case 'in progress':
        return LucideIcons.refreshCw;
      case 'verified':
        return LucideIcons.badgeCheck;
      case 'delayed':
        return LucideIcons.alertTriangle;
      default:
        return LucideIcons.info;
    }
  }

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.red;
      case 'in progress':
        return Colors.orange;
      case 'verified':
        return Colors.blue;
      case 'delayed':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  String formatDateTimeString(String? datetime) {
    return datetime ?? '';
  }

  String formatDateString(String? date) {
    return date ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 2.h),
        Text(title, style: titleStyle ?? const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 20),
        ...logs.asMap().entries.map((entry) {
          final index = entry.key;
          final log = entry.value;

          final status = getStatus(log);
          final statusUpdatedAt = getStatusUpdatedAt(log);
          final remarks = getRemarks(log);
          final dueDate = getDueDate(log);

          final iconColor = getStatusColor(status);
          final iconData = getStatusIcon(status);

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
                    child: Icon(iconData, color: Colors.white, size: 16),
                  ),
                  if (index != logs.length - 1)
                    Container(width: 2, height: 60, color: Colors.grey.shade300),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(status ?? "Unknown", style: statusStyle ?? const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(
                        formatDateTimeString(statusUpdatedAt),
                        style: dateStyle ?? const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      if (remarks?.isNotEmpty == true)
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: "Remarks: ", style: labelStyle ?? const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                              TextSpan(text: remarks, style: valueStyle ?? const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      if (dueDate != null)
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(text: "Next Review Date: ", style: labelStyle ?? const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                              TextSpan(text: formatDateString(dueDate), style: valueStyle ?? const TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
}

class Header {
  final String title;
  final int? flex;

  Header({required this.title, this.flex});
}

Widget commonDropdown(String label, List<String> items, String? value, void Function(String?) onChanged) {
  return DropdownButtonFormField<String>(
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey), // Default border color
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey), // Change border color when not focused
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey), // Change border color when focused
      ),
    ),
    value: value,
    onChanged: onChanged,
    items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
  );
}
