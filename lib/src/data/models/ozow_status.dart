enum OzowStatus {
  complete,
  cancelled,
  abandoned,
  pendingInvestigation,
  pending,
  error;

  @override
  String toString() {
    switch (this) {
      case OzowStatus.complete:
        return 'Complete';
      case OzowStatus.cancelled:
        return 'Cancelled';
      case OzowStatus.abandoned:
        return 'Abandoned';
      case OzowStatus.pendingInvestigation:
        return 'PendingInvestigation';
      case OzowStatus.pending:
        return 'Pending';
      case OzowStatus.error:
        return 'Error';
      }
  }
}

OzowStatus ozowStatusFromStr(String? status) {
  switch (status) {
    case 'Complete':
      return OzowStatus.complete;
    case 'Cancelled':
      return OzowStatus.cancelled;
    case 'Abandoned':
      return OzowStatus.abandoned;
    case 'PendingInvestigation':
      return OzowStatus.pendingInvestigation;
    case 'Pending':
      return OzowStatus.pending;
    case 'Error':
      return OzowStatus.error;
    default:
      return OzowStatus.error;
  }
}
