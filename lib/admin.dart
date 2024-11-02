import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'providers/data_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class AdminPanel extends StatefulWidget {
  const AdminPanel({Key? key}) : super(key: key);

  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A237E),
              Color(0xFF0D47A1),
              Color(0xFF01579B),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildAgendaManager(),
                    _buildInfoManager(),
                    _buildGalleryManager(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              SizedBox(width: 16),
              Text(
                'Admin Panel',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.blue,
        ),
        tabs: [
          Tab(text: 'Agenda'),
          Tab(text: 'Info'),
          Tab(text: 'Galeri'),
        ],
      ),
    );
  }

  Widget _buildAgendaManager() {
    final dataProvider = Provider.of<DataProvider>(context);
    return _buildManagerSection(
      items: dataProvider.agendaItems,
      onEdit: (item) => _editAgenda(item),
      onDelete: (item) => dataProvider.deleteAgendaItem(item),
    );
  }

  Widget _buildInfoManager() {
    final dataProvider = Provider.of<DataProvider>(context);
    return _buildManagerSection(
      items: dataProvider.infoItems,
      onEdit: (item) => _editInfo(item),
      onDelete: (item) => dataProvider.deleteInfoItem(item),
    );
  }

  Widget _buildGalleryManager() {
    final dataProvider = Provider.of<DataProvider>(context);
    return _buildManagerSection(
      items: dataProvider.galleryItems,
      onEdit: (item) => _editGallery(item),
      onDelete: (item) => dataProvider.deleteGalleryItem(item),
    );
  }

  Widget _buildManagerSection({
    required List<Map<String, String>> items,
    required Function(Map<String, String>) onEdit,
    required Function(Map<String, String>) onDelete,
  }) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          color: Colors.white.withOpacity(0.1),
          margin: EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(
              item['title']!,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              item['date']!,
              style: TextStyle(color: Colors.white70),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.white70),
                  onPressed: () => onEdit(item),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.white70),
                  onPressed: () => onDelete(item),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddDialog(BuildContext context) {
    switch (_tabController.index) {
      case 0:
        _showAddAgendaDialog(context);
        break;
      case 1:
        _showAddInfoDialog(context);
        break;
      case 2:
        _showAddGalleryDialog(context);
        break;
    }
  }

  void _showAddAgendaDialog(BuildContext context) {
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final locationController = TextEditingController();
    final timeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Tambah Agenda Baru', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Nama Agenda',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: dateController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Tanggal',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: locationController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Lokasi',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: timeController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Waktu',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Simpan'),
            onPressed: () {
              if (titleController.text.isNotEmpty && dateController.text.isNotEmpty) {
                final newItem = {
                  'title': titleController.text,
                  'date': dateController.text,
                  'location': locationController.text,
                  'time': timeController.text,
                };
                Provider.of<DataProvider>(context, listen: false).addAgendaItem(newItem);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Agenda berhasil ditambahkan'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showAddInfoDialog(BuildContext context) {
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Tambah Informasi Baru', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Judul Informasi',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: dateController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Tanggal',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              style: TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: categoryController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Kategori',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Simpan'),
            onPressed: () {
              if (titleController.text.isNotEmpty && dateController.text.isNotEmpty) {
                final newItem = {
                  'title': titleController.text,
                  'date': dateController.text,
                  'description': descriptionController.text,
                  'category': categoryController.text,
                };
                Provider.of<DataProvider>(context, listen: false).addInfoItem(newItem);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Informasi berhasil ditambahkan'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void _showAddGalleryDialog(BuildContext context) {
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final descriptionController = TextEditingController();
    final imageUrlController = TextEditingController();
    String? selectedFilePath;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          bool isUsingUrl = selectedFilePath == null;
          
          return AlertDialog(
            backgroundColor: Colors.grey[900],
            title: Text('Tambah Foto Baru', style: TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('File', style: TextStyle(color: Colors.white70)),
                      Switch(
                        value: isUsingUrl,
                        onChanged: (value) {
                          setState(() {
                            if (!value) {
                              imageUrlController.clear();
                            } else {
                              selectedFilePath = null;
                            }
                          });
                        },
                      ),
                      Text('URL', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  SizedBox(height: 16),
                  
                  if (isUsingUrl)
                    TextField(
                      controller: imageUrlController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'URL Foto',
                        labelStyle: TextStyle(color: Colors.white70),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70),
                        ),
                        hintText: 'https://example.com/image.jpg',
                        hintStyle: TextStyle(color: Colors.white38),
                      ),
                    )
                  else
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: selectedFilePath != null
                          ? Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    File(selectedFilePath!),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: IconButton(
                                    icon: Icon(Icons.close, color: Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        selectedFilePath = null;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )
                          : IconButton(
                              icon: Icon(Icons.add_photo_alternate, 
                                color: Colors.white70, 
                                size: 40
                              ),
                              onPressed: () async {
                                FilePickerResult? result = 
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.image,
                                );
                                
                                if (result != null) {
                                  setState(() {
                                    selectedFilePath = result.files.single.path;
                                  });
                                }
                              },
                            ),
                    ),
                  
                  SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Judul Foto',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: dateController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Tanggal',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    style: TextStyle(color: Colors.white),
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Deskripsi Foto',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                child: Text('Batal'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Simpan'),
                onPressed: () {
                  if (titleController.text.isNotEmpty && 
                      dateController.text.isNotEmpty &&
                      (isUsingUrl ? imageUrlController.text.isNotEmpty : selectedFilePath != null)) {
                    final newItem = {
                      'title': titleController.text,
                      'date': dateController.text,
                      'description': descriptionController.text,
                      'imageUrl': isUsingUrl ? imageUrlController.text : selectedFilePath!,
                      'isUrl': isUsingUrl.toString(),
                    };
                    Provider.of<DataProvider>(context, listen: false).addGalleryItem(newItem);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Foto berhasil ditambahkan'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Semua field harus diisi'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // Implementasi method untuk mengedit
  void _editAgenda(Map<String, String> item) {
    _showEditDialog(context, item, (newItem) {
      Provider.of<DataProvider>(context, listen: false)
          .editAgendaItem(item, newItem);
    });
  }

  void _editInfo(Map<String, String> item) {
    _showEditDialog(context, item, (newItem) {
      Provider.of<DataProvider>(context, listen: false)
          .editInfoItem(item, newItem);
    });
  }

  void _editGallery(Map<String, String> item) {
    _showEditDialog(context, item, (newItem) {
      Provider.of<DataProvider>(context, listen: false)
          .editGalleryItem(item, newItem);
    });
  }

  void _showEditDialog(BuildContext context, Map<String, String> item, Function(Map<String, String>) onEdit) {
    final titleController = TextEditingController(text: item['title']);
    final dateController = TextEditingController(text: item['date']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Edit Item', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Judul',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: dateController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Tanggal',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Simpan'),
            onPressed: () {
              if (titleController.text.isNotEmpty && dateController.text.isNotEmpty) {
                final newItem = {
                  'title': titleController.text,
                  'date': dateController.text,
                };
                onEdit(newItem);
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Item berhasil diperbarui'),
                    backgroundColor: Colors.green,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Judul dan tanggal harus diisi'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  // Implementasi method untuk menghapus
  void _deleteAgenda(Map<String, String> item) {
    setState(() {
      Provider.of<DataProvider>(context, listen: false).deleteAgendaItem(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Agenda berhasil dihapus')),
    );
  }

  void _deleteInfo(Map<String, String> item) {
    setState(() {
      Provider.of<DataProvider>(context, listen: false).deleteInfoItem(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Info berhasil dihapus')),
    );
  }

  void _deleteGallery(Map<String, String> item) {
    setState(() {
      Provider.of<DataProvider>(context, listen: false).deleteGalleryItem(item);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Galeri berhasil dihapus')),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Konfirmasi Logout',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            child: Text('Batal'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Logout'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login',
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
} 