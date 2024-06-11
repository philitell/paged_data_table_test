import 'dart:math';

import 'package:flutter/material.dart';
import 'package:paged_data_table_test/post.dart';
import 'package:paged_datatable/paged_datatable.dart';

class TableTestPage extends StatefulWidget {
  const TableTestPage({super.key});

  @override
  State<TableTestPage> createState() => _TableTestPageState();
}

class _TableTestPageState extends State<TableTestPage> {
  final tableController = PagedDataTableController<String, Post>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PagedDataTableTheme(
        data: PagedDataTableThemeData(
          selectedRow: const Color(0xFFCE93D8),
          rowColor: (index) => index.isEven ? Colors.purple[50] : null,
        ),
        child: PagedDataTable<String, Post>(
          controller: tableController,
          initialPageSize: 100,
          configuration: const PagedDataTableConfiguration(),
          pageSizes: const [10, 20, 50, 100],
          fetcher: (pageSize, sortModel, filterModel, pageToken) async {
            final data = await PostsRepository.getPosts(
              pageSize: pageSize,
              pageToken: pageToken,
              sortBy: sortModel?.fieldName,
              sortDescending: sortModel?.descending ?? false,
              gender: filterModel["authorGender"],
              searchQuery: filterModel["content"],
            );
            return (data.items, data.nextPageToken);
          },
          filters: [
            TextTableFilter(
              id: "content",
              chipFormatter: (value) => 'Content has "$value"',
              name: "Content",
            ),
            DropdownTableFilter<Gender>(
              items: Gender.values.map((e) => DropdownMenuItem(value: e, child: Text(e.name))).toList(growable: false),
              chipFormatter: (value) => 'Author is ${value.name.toLowerCase()}',
              id: "authorGender",
              name: "Author's Gender",
            ),
          ],
          filterBarChild: PopupMenuButton(
            icon: const Icon(Icons.more_vert_outlined),
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                child: const Text("Print selected rows"),
                onTap: () {
                  debugPrint(tableController.selectedRows.toString());
                  debugPrint(tableController.selectedItems.toString());
                },
              ),
              PopupMenuItem(
                child: const Text("Select random row"),
                onTap: () {
                  final index = Random().nextInt(tableController.totalItems);
                  tableController.selectRow(index);
                },
              ),
              PopupMenuItem(
                child: const Text("Select all rows"),
                onTap: () {
                  tableController.selectAllRows();
                },
              ),
              PopupMenuItem(
                child: const Text("Unselect all rows"),
                onTap: () {
                  tableController.unselectAllRows();
                },
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                child: const Text("Remove first row"),
                onTap: () {
                  tableController.removeRowAt(0);
                },
              ),
              PopupMenuItem(
                child: const Text("Remove last row"),
                onTap: () {
                  tableController.removeRowAt(tableController.totalItems - 1);
                },
              ),
              PopupMenuItem(
                child: const Text("Remove random row"),
                onTap: () {
                  final index = Random().nextInt(tableController.totalItems);
                  tableController.removeRowAt(index);
                },
              ),
              PopupMenuItem(
                child: const Text("Replace first"),
                onTap: () {
                  tableController.replace(
                    0,
                    Post(
                      id: 999999,
                      author: "Replaced",
                      authorGender: Gender.male,
                      content: "This row was replaced",
                      createdAt: DateTime.now(),
                      isEnabled: true,
                      number: 12151502,
                    ),
                  );
                },
              ),
              PopupMenuItem(
                child: const Text("Insert first"),
                onTap: () {
                  tableController.insertAt(
                    0,
                    Post(
                      id: 2121,
                      author: "Created",
                      authorGender: Gender.male,
                      content: "This row was inserted",
                      createdAt: DateTime.now(),
                      isEnabled: true,
                      number: 12151502,
                    ),
                  );
                },
              ),
              PopupMenuItem(
                child: const Text("Insert last"),
                onTap: () {
                  tableController.insert(
                    Post(
                      id: 999999,
                      author: "Created",
                      authorGender: Gender.male,
                      content: "This row was inserted last",
                      createdAt: DateTime.now(),
                      isEnabled: true,
                      number: 12151502,
                    ),
                  );
                },
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                child: const Text("Set filter"),
                onTap: () {
                  tableController.setFilter("authorGender", Gender.male);
                },
              ),
              PopupMenuItem(
                child: const Text("Remove filter"),
                onTap: () {
                  tableController.removeFilter("authorGender");
                },
              ),
              PopupMenuItem(
                child: const Text("Clear filters"),
                onTap: () {
                  tableController.removeFilters();
                },
              ),
            ],
          ),
          fixedColumnCount: 2,
          columns: [
            TableColumn(
              title: const Text("Id"),
              cellBuilder: (context, item, index) => Text(item.id.toString()),
              // size: const FixedColumnSize(100),
            ),
            TableColumn(
              title: const Text("Author"),
              cellBuilder: (context, item, index) => Text(item.author),
              sortable: true,
              id: "author",
            ),
            TableColumn(
              title: const Text("Author2"),
              cellBuilder: (context, item, index) => Text(item.author),
              sortable: true,
              id: "author2",
            ),
            TableColumn(
              title: const Text("Author Gender"),
              cellBuilder: (context, item, index) => Text(item.authorGender.name),
              sortable: true,
              id: "authorGender",
            ),
            TableColumn(
              title: const Text("Author Gender1"),
              cellBuilder: (context, item, index) => Text(item.authorGender.name),
              sortable: true,
              id: "authorGender1",
            ),
            TableColumn(
              title: const Text("Author Gender2"),
              cellBuilder: (context, item, index) => Text(item.authorGender.name),
              sortable: true,
              id: "authorGender2",
            ),
            TableColumn(
              title: const Text("Author3"),
              cellBuilder: (context, item, index) => Text(item.author),
              sortable: true,
              id: "author3",
              // size: const FractionalColumnSize(.15),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
