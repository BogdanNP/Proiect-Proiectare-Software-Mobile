import 'package:flutter/material.dart';
import 'package:mobile_app/models/model_mapper.dart';

class BaseTitleWidget extends StatelessWidget {
  final ModelType modelType;
  const BaseTitleWidget(this.modelType, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(ModelMapper.screenTitle(modelType));
  }
}
