import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Страница с подробной информацией об облигации
class BondDetailsPage extends StatelessWidget {
  final BondData bond;
  final DateFormat _dateFormat = DateFormat('dd.MM.yyyy');

  BondDetailsPage({required this.bond});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bond.name), // Заголовок страницы - название облигации
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bond.name,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow(context, "Код:", bond.code),
            _buildInfoRow(
                context, "Номинал:", "${bond.faceValue} ${bond.currency}"),
            _buildInfoRow(context, "Ставка купона:", "${bond.couponRate}%"),
            _buildInfoRow(
                context, "НКД:", "${bond.accruedInterest} ${bond.currency}"),
            _buildInfoRow(context, "Дата купона:",
                _dateFormat.format(bond.nextCouponDate)),
            _buildInfoRow(
                context, "Погашение:", _dateFormat.format(bond.maturityDate)),
            _buildInfoRow(context, "Доходность:", "${bond.yieldToMaturity}%"),
            if (bond.issueVolume != null)
              _buildInfoRow(context, "Объем выпуска:",
                  "${bond.issueVolume} ${bond.currency}"),
          ],
        ),
      ),
    );
  }

  // Метод для построения строки с информацией (ключ: значение)
  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).textTheme.caption?.color,
            ),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
