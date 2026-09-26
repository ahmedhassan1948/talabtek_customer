import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talabtek_customer/core/theme/app_theme.dart'

class FAQSection extends StatelessWidget {
  final List<FAQItem> faqs = const [
    FAQItem(
      question: 'كيف أطلب من التطبيق؟',
      answer: 'اختر المطعم أو المتجر المطلوب، تصفح القائمة، أضف الأصناف إلى السلة، اختر عنوان التوصيل، ثم أكمل الطلب.',
    ),
    FAQItem(
      question: 'ما هي طرق الدفع المتاحة؟',
      answer: 'نقبل الدفع نقداً عند الاستلام، بطاقات مدى، فيزا/ماستركارد، Apple Pay، Google Pay، والمحفظة الإلكترونية داخل التطبيق.',
    ),
    FAQItem(
      question: 'كم تستغرق مدة التوصيل؟',
      answer: 'تختلف حسب المطعم والمسافة، عادة ما تكون بين 25-45 دقيقة. يظهر الوقت المتوقع قبل تأكيد الطلب.',
    ),
    FAQItem(
      question: 'كيف ألغي طلبي؟',
      answer: 'يمكنك إلغاء الطلب من صفحة "طلباتي" إذا كان لا يزال في مرحلة "في الانتظار" أو "تم التأكيد". بعد بدء التحضير لا يمكن الإلغاء.',
    ),
    FAQItem(
      question: 'هل يمكنني تتبع السائق؟',
      answer: 'نعم، بعد تأكيد الطلب وتعيين سائق، يمكنك تتبع موقعه مباشرة على الخريطة من صفحة تتبع الطلب.',
    ),
    FAQItem(
      question: 'ماذا لو وصل الطلب ناقصاً أو خاطئاً؟',
      answer: 'تواصل مع الدعم عبر الشات المباشر أو اتصل بنا خلال 30 دقيقة من الاستلام وسنقوم بحل المشكلة فوراً.',
    ),
    FAQItem(
      question: 'كيف أستخدم كود الخصم؟',
      answer: 'في صفحة إتمام الطلب، أدخل الكود في خانة "كود الخصم" واضغط "تطبيق". سيتم خصم المبلغ من المجموع.',
    ),
    FAQItem(
      question: 'ما هي رسوم التوصيل؟',
      answer: 'تختلف حسب المطعم والمسافة. التوصيل مجاني للطلبات فوق حد معين (يظهر في صفحة المطعم).',
    ),
    FAQItem(
      question: 'كيف أضيف عنوان جديد؟',
      answer: 'من الملف الشخصي > عناويني المحفوظة > إضافة عنوان جديد. يمكنك تحديد الموقع على الخريطة بدقة.',
    ),
    FAQItem(
      question: 'هل يمكنني جدولة طلب لوقت لاحق؟',
      answer: 'نعم، في صفحة إتمام الطلب اختر "جدولة لوقت لاحق" وحدد التاريخ والوقت المطلوب.',
    ),
  ];

  const FAQSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الأسئلة الشائعة',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 16.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: faqs.length,
          separatorBuilder: (context, index) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            return FAQTile(faq: faqs[index]);
          },
        ),
      ],
    );
  }
}

class FAQTile extends StatefulWidget {
  final FAQItem faq;

  const FAQTile({super.key, required this.faq});

  @override
  State<FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor, width: 1),
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: _isExpanded,
          onExpansionChanged: (expanded) => setState(() => _isExpanded = expanded),
          title: Text(
            widget.faq.question,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          childrenPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.faq.answer,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  const FAQItem({
    required this.question,
    required this.answer,
  });
}