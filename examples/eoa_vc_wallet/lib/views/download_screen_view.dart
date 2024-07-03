import 'package:flutter/material.dart';
import 'package:polygonid_flutter_sdk/proof/domain/entities/download_info_entity.dart';

import '../shared_data.dart';

class DownloadScreen extends StatefulWidget {
  const DownloadScreen({super.key});

  @override
  State<StatefulWidget> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen> {
  double progressHeight = 40;
  double percentage = 0;
  int currentIndex = 0;
  int filesToDownload = sharedData.circuitsToDownload!.length;
  String currentFile = sharedData.circuitsToDownload![0].circuitsName;

  @override
  void initState() {
    super.initState();
    initDataSource();
  }

  void initDataSource() {
    sharedData.circuitDownloadStream!.listen(
      (downloadInfo) {
        if (downloadInfo is DownloadInfoOnProgress) {
          DownloadInfoOnProgress progress = downloadInfo;

          setState(() {
            percentage = progress.downloaded / progress.contentLength;
            if (percentage >= 1 && currentIndex < filesToDownload - 1) {
              currentIndex++;
              currentFile =
                  sharedData.circuitsToDownload![currentIndex].circuitsName;
            }
          });
        } else if (downloadInfo is DownloadInfoOnDone) {
          Navigator.of(context).pop();
        }
      },
    );
  }

  _calculateLeftPadding(
      double maxWidth, double percentage, double progressHeight) {
    double padding = maxWidth * percentage - 21.0;
    if (padding > (maxWidth - progressHeight)) {
      return maxWidth - progressHeight;
    }
    return padding > 0 ? padding : 0.0;
  }

  _calculateTopPadding(double maxHeight, double progressHeight) {
    return (maxHeight - 10.0) / progressHeight / 10.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsetsDirectional.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'Downloading circuits...',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  'Downloading file: ${currentIndex + 1}/$filesToDownload: $currentFile',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: progressHeight,
                padding: const EdgeInsets.all(5),
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    LinearProgressIndicator(
                      value: percentage,
                      minHeight: progressHeight,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.cyanAccent,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    LayoutBuilder(builder: (context, constraints) {
                      var leftPadding = _calculateLeftPadding(
                          constraints.maxWidth, percentage, progressHeight);
                      var topPadding = _calculateTopPadding(
                          constraints.maxHeight, progressHeight);
                      return Padding(
                        padding:
                            EdgeInsets.only(left: leftPadding, top: topPadding),
                        child: Icon(
                          Icons.double_arrow,
                          size: progressHeight - 10,
                          color: Colors.redAccent,
                        ),
                      );
                    })
                  ],
                ),
              ),
              // Slider(
              //     value: percentage,
              //     onChanged: (val) => {
              //           setState(() {
              //             percentage = val;
              //           })
              //         }),
              // Centered Text
              Center(
                child: Text(
                  '${(percentage * 100).toStringAsFixed(0)}%',
                ),
              ),
            ],
          ),
        ));
  }
}
