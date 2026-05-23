class AppUpdateResult {
  final bool hasUpdate;
  final bool forceUpdate;
  final String latestVersion;
  final int skipCount;

  const AppUpdateResult({
    required this.hasUpdate,
    required this.forceUpdate,
    required this.latestVersion,
    required this.skipCount,
  });

  factory AppUpdateResult.fromMap(Map<String, dynamic> map) {
    return AppUpdateResult(
      hasUpdate: map['hasUpdate'] ?? false,
      forceUpdate: map['forceUpdate'] ?? false,
      latestVersion: map['latestVersion'] ?? '',
      skipCount: map['skipCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hasUpdate': hasUpdate,
      'forceUpdate': forceUpdate,
      'latestVersion': latestVersion,
      'skipCount': skipCount,
    };
  }

  @override
  String toString() {
    return 'AppUpdateResult('
        'hasUpdate: $hasUpdate, '
        'forceUpdate: $forceUpdate, '
        'latestVersion: $latestVersion, '
        'skipCount: $skipCount'
        ')';
  }
}