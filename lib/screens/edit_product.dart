import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class TempProduct {
  String title;
  String id;
  String description;
  double price;
  String imageUrl;
  bool isFavorite;

  TempProduct({
    this.id,
    this.title,
    this.price,
    this.description,
    this.imageUrl,
    this.isFavorite,
  });
}

class _EditProductScreenState extends State<EditProductScreen> {
  var check = true;
  final _priceNode = FocusNode();
  final _descNode = FocusNode();
  final _imageCont = TextEditingController();
  final _imgNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _editedProduct =
      TempProduct(id: null, title: "", description: "", price: 0, imageUrl: "");

  var initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': '',
  };

  @override
  void dispose() {
    _priceNode.dispose();
    _descNode.dispose();
    _imageCont.dispose();
    _imgNode.removeListener(_updateURL);
    _imgNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imgNode.addListener(_updateURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (check) {
      final prodId = ModalRoute.of(context).settings.arguments as String;
      if (prodId != null) {
        final product =
            Provider.of<Products>(context, listen: false).findById(prodId);
        _editedProduct.id = product.id;
        _editedProduct.title = product.title;
        _editedProduct.description = product.description;
        _editedProduct.imageUrl = product.imageUrl;
        _editedProduct.price = product.price;
        _editedProduct.isFavorite = product.isFavorite;
        initValues = {
          'title': product.title,
          'description': product.description,
          'price': product.price.toString(),
          'imageUrl': ''
        };
        _imageCont.text = product.imageUrl;
      }
    }
    check = false;
    super.didChangeDependencies();
  }

  void _updateURL() {
    if (!_imgNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      if (_editedProduct.id == null) {
        _editedProduct.id = DateTime.now().toString();
        Provider.of<Products>(context, listen: false)
            .addProduct(Product.fromTemp(_editedProduct));
      } else {
        Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, Product.fromTemp(_editedProduct));
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Form(
          key: _form,
          autovalidate: true,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: initValues['title'],
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a title.';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceNode);
                  },
                  onSaved: (value) {
                    _editedProduct.title = value;
                  },
                ),
                TextFormField(
                  initialValue: initValues['price'],
                  decoration: InputDecoration(labelText: 'Price'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceNode,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a price.';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please provide a valid price';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please provide a valid price';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descNode);
                  },
                  onSaved: (value) {
                    _editedProduct.price = double.parse(value);
                  },
                ),
                TextFormField(
                  initialValue: initValues['description'],
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descNode,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a description.';
                    }
                    if (value.length < 10) {
                      return 'Description must be at least 10 characters';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedProduct.description = value;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(
                        top: 10,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: _imageCont.text.isEmpty
                          ? Text('Enter URL')
                          : FittedBox(
                              child: Image.network(_imageCont.text),
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Image URL'),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageCont,
                        focusNode: _imgNode,
                        onSaved: (value) {
                          _editedProduct.imageUrl = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide a image URL.';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please provide a valid URL';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          _saveForm();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
