import 'package:flutter/material.dart';
import 'package:mobile_app/models/desk_request.dart';
import 'package:mobile_app/models/model_mapper.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/models/user.dart';
import 'package:mobile_app/screens/base_list_screen/list_title_widget.dart';
import 'package:mobile_app/screens/desk_request_list_screen/desk_request_list_view_model.dart';
import 'package:rxdart/rxdart.dart';

class DeskRequestListScreen extends StatefulWidget {
  final User user;
  const DeskRequestListScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<DeskRequestListScreen> createState() => _DeskRequestListScreenState();
}

class _DeskRequestListScreenState extends State<DeskRequestListScreen> {
  late List<DeskRequest> deskRequestList = [];
  late DeskRequestListViewModel vm;
  bool isError = false;
  bool isLoading = false;

  @override
  initState() {
    super.initState();

    vm = DeskRequestListViewModel(
      widget.user.id,
      Input(
        PublishSubject(),
      ),
    );
    vm.output.onStart.listen((data) {
      setState(() {
        debugPrint("${data.state}");
        switch (data.state) {
          case UIState.success:
            deskRequestList = data.data!;
            isLoading = false;
            isError = false;
            break;
          case UIState.error:
            debugPrint("${data.error}");
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Error: ${data.error}")));
            isError = true;
            isLoading = false;
            break;
          case UIState.loading:
            // ScaffoldMessenger.of(context)
            //     .showSnackBar(SnackBar(content: Text("Loading...")));
            isLoading = true;
            break;
        }
      });
    });
    vm.input.onStart.add(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BaseTitleWidget(ModelType.desk),
      ),
      body: !isError
          ? Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              child: const Text("Refresh"),
                              onPressed: () => vm.input.onStart.add(true),
                            ),
                          ],
                        ),
                      ),
                      ...deskRequestList.map(
                        (deskRequest) => DeskRequestCell(
                          deskRequest: deskRequest,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  const Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.transparent,
                      strokeWidth: 5,
                    ),
                  ),
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                child: const Text("Refresh"),
                onPressed: () => vm.input.onStart.add(true),
              ),
            ),
    );
  }
}

class DeskRequestCell extends StatelessWidget {
  final VoidCallback? onTap;
  final DeskRequest deskRequest;

  const DeskRequestCell({
    Key? key,
    required this.deskRequest,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: InkWell(
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          // color: Theme.of(context).cardColor,
          color: Colors.blue,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: deskRequest.getDisplayData().map((t) => Text(t)).toList(),
          ),
        ),
      ),
    );
  }
}
