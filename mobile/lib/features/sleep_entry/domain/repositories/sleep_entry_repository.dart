import '../entities/sleep_entry_draft.dart';

abstract class SleepEntryRepository {
  Future<void> saveSleepEntry(SleepEntryDraft draft);
}
