import 'package:flutter/material.dart';
import 'package:mobile_app/models/model_mapper.dart';
import 'package:mobile_app/models/desk.dart';
import 'package:mobile_app/models/ui_model.dart';
import 'package:mobile_app/screens/base_list_screen/list_title_widget.dart';
import 'package:mobile_app/screens/desk_list_screen/desk_list_view_model.dart';
import 'package:rxdart/rxdart.dart';

class DeskListScreen extends StatefulWidget {
  final int? roomId;
  const DeskListScreen({
    Key? key,
    this.roomId,
  }) : super(key: key);

  @override
  State<DeskListScreen> createState() => _DeskListScreenState();
}

class _DeskListScreenState extends State<DeskListScreen> {
  late List<Desk> deskList = [];
  late DeskListViewModel vm;
  bool isError = false;
  bool isLoading = false;

  @override
  initState() {
    super.initState();

    vm = DeskListViewModel(
      Input(
        PublishSubject(),
        PublishSubject(),
      ),
    );
    vm.output.onStart.listen((data) {
      setState(() {
        debugPrint("${data.state}");
        switch (data.state) {
          case UIState.success:
            deskList = data.data!;
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
    vm.input.onStart.add(widget.roomId);
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
                              onPressed: () =>
                                  vm.input.onStart.add(widget.roomId),
                            ),
                          ],
                        ),
                      ),
                      ...deskList.map(
                        (e) => DeskCell(
                          desk: e,
                          onTap: () {
                            debugPrint("open desk request screen");
                          },
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
                onPressed: () => vm.input.onStart.add(widget.roomId),
              ),
            ),
    );
  }
}

class DeskCell extends StatelessWidget {
  final VoidCallback? onTap;
  final Desk desk;

  const DeskCell({
    Key? key,
    required this.desk,
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
            children: desk.getDisplayData().map((t) => Text(t)).toList(),
          ),
        ),
      ),
    );
  }
}
