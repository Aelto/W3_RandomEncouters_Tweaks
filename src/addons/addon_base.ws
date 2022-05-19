
/**
 * The base class you can extend if you want to inject a statemachine in the RER
 * class. Useful if you want to run something with an interval.
 *
 * If you want it to run through the whole session you can also push it to the
 * RER_AddonsData.addons array so the garbage collector does not delete it.
 */
abstract class RER_BaseAddon {}