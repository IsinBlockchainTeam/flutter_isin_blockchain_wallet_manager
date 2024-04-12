import 'package:flutter/material.dart';
import 'package:flymoov_common_flutter/components/confirmation_button.dart';
import 'package:flymoov_common_flutter/utils/restart_widget.dart';

class WalletEraserButton extends ConfirmationButton {
  WalletEraserButton({super.key, required Function deleteWallets})
      : super(
            onConfirmedAction: (BuildContext context) =>
                {deleteWallets(), RestartWidget.restartApp(context)},
            buttonText: 'Erase wallet',
            alertTitle: 'Erase wallet',
            alertContent: 'Are you sure you want to erase your wallet?',
            alertConfirmation: 'Erase wallet',
            alertCancel: 'Cancel',
            buttonFontWeight: FontWeight.bold);
}
