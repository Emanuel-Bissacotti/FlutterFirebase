import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_firestore_first/firestore_produtos/helpers/enum_order.dart';
import 'package:flutter_firebase_firestore_first/firestore_produtos/model/produto.dart';

class ProdutoService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  adicionarProduto({required String listinId, required Produto produto}) {
    firestore
        .collection('listins')
        .doc(listinId)
        .collection("produtos")
        .doc(produto.id)
        .set(produto.toMap());
  }

  Future<List<Produto>> lerProdutos(
      {required String listinId,
      required OrdemProduto ordem,
      required bool isDecrescente}) async {
    List<Produto> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('listins')
        .doc(listinId)
        .collection('produtos')
        // .where("isComprado", isEqualTo: isComprado)
        .orderBy(ordem.name, descending: isDecrescente)
        .get();

    for (var doc in snapshot.docs) {
      Produto produto = Produto.fromMap(doc.data());
      temp.add(produto);
    }

    return temp;
  }

  Future<void> alternarProduto(
      {required String listinId, required Produto produto}) async {
    return firestore
        .collection('listins')
        .doc(listinId)
        .collection('produtos')
        .doc(produto.id)
        .update({'isComprado': produto.isComprado});
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      conectarStreamProdutos({
    required Function refresh,
    required String listinId,
    required OrdemProduto ordem,
    required bool isDecrescente,
  }) {
    return firestore
        .collection("listins")
        .doc(listinId)
        .collection("produtos")
        .orderBy(ordem.name, descending: isDecrescente)
        .snapshots()
        .listen(
      (snapshot) {
        refresh(snapshot: snapshot);
      },
    );
  }

  Future<void> removerProduto({required String listinId, required Produto produto}){
    return firestore
        .collection("listins")
        .doc(listinId)
        .collection("produtos")
        .doc(produto.id)
        .delete();
  }
}
