class CatalogApprovalCard extends StatelessWidget {
  final QueryDocumentSnapshot catalog;
  final VoidCallback onApprove;
  final Function(String) onReject;

  const CatalogApprovalCard({
    Key? key,
    required this.catalog,
    required this.onApprove,
    required this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              catalog['marketName'],
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 8),
            Image.network(
              catalog['imageUrl'],
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.check),
                  label: Text('Onayla'),
                  onPressed: onApprove,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.close),
                  label: Text('Reddet'),
                  onPressed: () => _showRejectDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showRejectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String reason = '';
        return AlertDialog(
          title: Text('Reddetme Nedeni'),
          content: TextField(
            onChanged: (value) => reason = value,
            decoration: InputDecoration(
              hintText: 'Reddetme nedenini yazın',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                if (reason.isNotEmpty) {
                  onReject(reason);
                  Navigator.pop(context);
                }
              },
              child: Text('Reddet'),
            ),
          ],
        );
      },
    );
  }
} 