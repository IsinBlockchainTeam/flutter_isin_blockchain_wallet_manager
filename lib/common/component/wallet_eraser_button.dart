import 'package:flutter/material.dart';
import 'package:flutter_isin_ui_kit/components/confirmation_button.dart';
import 'package:flutter_isin_ui_kit/utils/restart_widget.dart';

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
