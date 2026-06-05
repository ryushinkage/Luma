import '../../domain/entities/sleep_entry_draft.dart';
import '../../domain/repositories/sleep_entry_repository.dart';

class MockSleepEntryRepository implements SleepEntryRepository {
  static final List<SleepEntryDraft> savedEntries = [];

  @override
  Future<void> saveSleepEntry(SleepEntryDraft draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    savedEntries.add(draft);
  }
}
