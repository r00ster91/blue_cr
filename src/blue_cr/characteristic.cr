module BlueCr
  class Characteristic
    getter :object, :interface, :all_properties
    @all_properties : Hash(DBus::Type, DBus::Type)

    def initialize(@object : DBus::Object, @interface : DBus::Interface, @proporties : DBus::Interface)
      @all_properties = get_all
    end

    def uuid
      name = @all_properties["UUID"]?
      if name.is_a?(DBus::Variant)
        name.value
      else
        name
      end
    end

    def value
      name = @all_properties["Value"]?
      if name.is_a?(DBus::Variant)
        name.value
      else
        name
      end
    end

    def write_value(value : Slice(UInt8), options : Hash(String, DBus::Variant) = Hash(String, DBus::Variant).new)
      name = @interface.call("WriteValue", [value.to_a, options]).reply.first
      if name.is_a?(DBus::Variant)
        name.value
      else
        name
      end
    end

    def write_value(value : Array(UInt8), options : Hash(String, DBus::Variant) = Hash(String, DBus::Variant).new)
      name = @interface.call("WriteValue", [value, options]).reply.first
      if name.is_a?(DBus::Variant)
        name.value
      else
        name
      end
    end

    def read_value(options : Hash(String, DBus::Variant) = Hash(String, DBus::Variant).new) : DBus::Type
      name = @interface.call("ReadValue", [options]).reply.first
      if name.is_a?(DBus::Variant)
        name.value
      else
        name
      end
    end

    def characteristic_type
      BlueCr::DbGattCharacteristics.by_uuid(uuid.to_s)
    end

    def refresh
      @all_properties = get_all
    end

    private def get_all
      @proporties.call("GetAll", ["org.bluez.GattCharacteristic1"]).reply.first.as(Hash(DBus::Type, DBus::Type))
    end
  end
end
