import 'package:flutter/material.dart';

void main() => runApp(const ProNotesApp());

class ProNotesApp extends StatelessWidget {
  const ProNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ProNotesScreen(),
    );
  }
}

// نموذج البيانات
class Note {
  final String id;
  final String title;
  final String content;
  final DateTime date;
  final Color color;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.color,
  });
}

class ProNotesScreen extends StatefulWidget {
  const ProNotesScreen({super.key});

  @override
  State<ProNotesScreen> createState() => _ProNotesScreenState();
}

class _ProNotesScreenState extends State<ProNotesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // إضافة ملاحظات تجريبية
    _notes.add(Note(
      id: '1',
      title: 'خطة المشروع',
      content: 'إنهاء تصميم الواجهات قبل نهاية الأسبوع.',
      date: DateTime.now(),
      color: Colors.amber.shade100,
    ));
  }

  void _addNote() {
    setState(() {
      _notes.add(Note(
        id: DateTime.now().toString(),
        title: 'ملاحظة جديدة',
        content: 'محتوى ملاحظة ذكية...',
        date: DateTime.now(),
        color: Colors.blue.shade100,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 150.0,
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('ملاحظاتي المتقدمة', style: TextStyle(fontWeight: FontWeight.bold)),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.deepPurple.shade200],
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: const [
                Tab(text: 'الكل', icon: Icon(Icons.all_inclusive)),
                Tab(text: 'العمل', icon: Icon(Icons.business_center)),
                Tab(text: 'الأرشيف', icon: Icon(Icons.archive)),
              ],
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildNoteList(),
            const Center(child: Text('لا توجد مهام عمل حالياً')),
            const Center(child: Text('الأرشيف فارغ')),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNote,
        label: const Text('ملاحظة'),
        icon: const Icon(Icons.edit_note),
      ),
    );
  }

  Widget _buildNoteList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return Dismissible(
          key: Key(note.id),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            setState(() => _notes.removeAt(index));
          },
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Hero(
            tag: note.id,
            child: Card(
              color: note.color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                title: Text(note.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(note.content),
                    const SizedBox(height: 8),
                    Text(
                      '${note.date.hour}:${note.date.minute}',
                      style: const TextStyle(fontSize: 10, color: Colors.black54),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.push_pin_outlined),
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
