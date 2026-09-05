/// Mapping toggle sensor dewasa -> parameter contentRating MangaDex.
/// `lib/core/utils/content_rating_filter.dart`.
class ContentRatingFilter {
  ContentRatingFilter._();

  /// adultFilter ON (default): hanya safe + suggestive.
  /// OFF: tambah erotica. `pornographic` selalu dikecualikan di v1.
  static List<String> forQuery({required bool adultFilterOn}) => adultFilterOn
      ? const ['safe', 'suggestive']
      : const ['safe', 'suggestive', 'erotica'];

  static String label(String? rating) => switch (rating) {
        'safe' => 'Aman',
        'suggestive' => 'Sugestif',
        'erotica' => 'Erotica',
        'pornographic' => 'Pornografi',
        _ => '-',
      };
}
