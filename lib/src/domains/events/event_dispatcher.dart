import 'package:mineral/src/domains/events/event.dart';
import 'package:mineral/src/domains/events/internal_event_params.dart';
import 'package:rxdart/rxdart.dart';

abstract interface class EventDispatcherContract {
  void dispatch({required Event event, required List params});

  void dispose();
}

final class EventDispatcher implements EventDispatcherContract {
  final BehaviorSubject<InternalEventParams> _events;

  EventDispatcher(this._events);

  @override
  void dispatch(
      {required Event event,
      required List params,
      bool Function(String?)? constraint}) {
    _events.add(InternalEventParams(event, params, constraint));
  }

  @override
  void dispose() => _events.close();
}