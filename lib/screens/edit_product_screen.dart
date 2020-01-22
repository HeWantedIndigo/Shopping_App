import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {

  static const routeName = '/edit_product_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();

}

class _EditProductScreenState extends State<EditProductScreen> {

  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _isInit = true;
  var _isLoading = false;

  var _initValues = {
    'title' : '',
    'description' : '',
    'price' : '',
    'imageUrl' : '',
  };

  var _product = Product(
    id: null,
    title: "",
    price: 0,
    description: "",
    imageUrl: "",
  );

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _product = Provider.of<Products>(context).findById(productId);
        _initValues = {
          'title' : _product.title,
          'description' : _product.description,
          'price' : _product.price.toString(),
          //'imageUrl' : _product.imageUrl,
        };
        _imageUrlController.text = _product.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {
      });
    }
  }

  Future<void> _saveForm() async {
    final path = _form.currentState.validate();
    if (!path) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_product.id != null) {
      await Provider.of<Products>(context, listen: false).updateProduct(_product.id, _product);
    } 
    else {
      try {
        _product = Product(
          id: DateTime.now().toString(),
          title: _product.title,
          price: _product.price,
          description: _product.description,
          imageUrl: _product.imageUrl,
        );
        await Provider.of<Products>(context, listen: false).addProduct(_product);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(
              "ERROR",
              style: Theme.of(context).textTheme.title,
            ),
            content: Text(
              "Product Addition failed!",
              style: Theme.of(context).textTheme.display1,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("OKAY"),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      } 
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.pop(context);
      // }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit/Add Product",
          style: Theme.of(context).textTheme.title,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _saveForm(),
          )
        ],
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator(backgroundColor: Colors.red,),) 
      : Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _initValues['title'],
                  decoration: InputDecoration(
                    labelText: "Title",
                  ),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    _product = Product(
                      id: _product.id,
                      title: value,
                      price: _product.price,
                      description: _product.description,
                      imageUrl: _product.imageUrl,
                      isFavorite: _product.isFavorite,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please add a title!";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  initialValue: _initValues['price'],
                  decoration: InputDecoration(
                    labelText: "Price",
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    _product = Product(
                      id: _product.id,
                      title: _product.title,
                      price: double.parse(value),
                      description: _product.description,
                      imageUrl: _product.imageUrl,
                      isFavorite: _product.isFavorite,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please add a price!";
                    } else if (double.tryParse(value) == null) {
                      return "Please enter a valid number!";
                    } else if (double.parse(value) <= 0) {
                      return "Price must be greater than zero!";
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'],
                  decoration: InputDecoration(
                    labelText: "Description",
                  ),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  onSaved: (value) {
                    _product = Product(
                      id: _product.id,
                      title: _product.title,
                      price: _product.price,
                      description: value,
                      imageUrl: _product.imageUrl,
                      isFavorite: _product.isFavorite,
                    );
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Please add a description!";
                    } else {
                      return null;
                    }
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10, top: 20),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        )
                      ),
                      child: _imageUrlController.text.isEmpty ? 
                        Text("No Image selected") : 
                        FittedBox(child: Image.network(_imageUrlController.text, fit: BoxFit.cover)),
                    ),
                    Expanded(
                      child: TextFormField(
                        //initialValue: _initValues['imageUrl'],
                        decoration: InputDecoration(
                          labelText: "Image URL",
                        ),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onFieldSubmitted: (_) {
                          setState(() {
                          });
                          _saveForm();
                        },
                        onSaved: (value) {
                          _product = Product(
                            id: _product.id,
                            title: _product.title,
                            price: _product.price,
                            description: _product.description,
                            imageUrl: value,
                            isFavorite: _product.isFavorite,
                          );
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please add an Image URL!";
                          } else if (!value.startsWith("https") && !value.startsWith("http")) {
                            return "Invalid Image URL";
                          } else if (!value.endsWith(".jpeg") && !value.endsWith(".png") && !value.endsWith(".jpg")) {
                            return "Invalid Image URL";
                          } else {
                            return null;
                          }
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