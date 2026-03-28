//Capacity mixin to check if there are available seats for an event
mixin CapacityMixin {
  bool hasAvailableSeats(int capacity, int registered) {
    return registered < capacity;
  }
}
