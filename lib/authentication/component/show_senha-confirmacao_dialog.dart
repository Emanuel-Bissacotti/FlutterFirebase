import 'package:flutter/material.dart';
import 'package:flutter_firebase_firestore_first/authentication/services/auth_service.dart';

showSenhaConfirmacaoDialog({
  required BuildContext context,
  required String email,
}) {
  showDialog(
    context: context,
    builder: (context) {
      TextEditingController senhaConfirmacaoController =
          TextEditingController();
      return AlertDialog(
        title: Text("Deseja remover a conta com o email $email?"),
        content: SizedBox(
          height: 150,
          child: Column(
            children: [
              const Text(
                  "Para confirmar a remocao da conta insira sua senha: "),
              TextFormField(
                controller: senhaConfirmacaoController,
                obscureText: true,
                decoration: const InputDecoration(
                  label: Text("Senha"),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              AuthService()
                  .removerConta(senha: senhaConfirmacaoController.text)
                  .then((String? erro) {
                if (erro == null) {
                  Navigator.pop(context);
                }
              });
            },
            child: const Text("EXCLUIR CONTA"),
          ),
        ],
      );
    },
  );
}
