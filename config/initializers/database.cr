require "granite/adapter/pg"

Granite::Connections << Granite::Adapter::Pg.new(name: "pg", url: ENV["DATABASE_URL"]? || Amber.settings.database_url)
Granite.settings.default_timezone = Time::Location.local
Granite.settings.logger = Amber.settings.logger.dup
Granite.settings.logger.not_nil!.progname = "Granite"

class Granite::Base
  macro enum_column(decl)
    @{{decl.var}} : {{decl.type}}? = nil
    column {{decl.var}}_number : Int32

    def {{decl.var}}?
      @{{decl.var}} ||= {{decl.type}}.from_value({{decl.var}}_number) if @{{decl.var}}_number
      @{{decl.var}}
    end

    def {{decl.var}}
      {{decl.var}}?.not_nil!
    end

    def {{decl.var}}=({{decl.var}} : {{decl.type}})
      @{{decl.var}} = {{decl.var}}
      @{{decl.var}}_number = {{decl.var}}.value
    end

    def {{decl.var}}=(number : Int)
      if %enum = {{decl.type}}.from_value?(number)
        self.{{decl.var}} = %enum
      end
    end

    def {{decl.var}}=(name : String)
      if %enum = {{decl.type}}.parse?(name)
        self.{{decl.var}} = %enum
      end
    end
  end

  macro alias_column(a, b)
    {%
      a = a.id
      b = b.id
    %}
    def {{a}}
      {{b}}
    end

    def {{a}}!
      {{b}}!
    end

    def {{a}}=(value)
      self.{{b}} = value
    end
  end
end

module BytesConverter
  def self.to_db(value : String)
    value.to_slice
  end

  def self.from_rs(result : DB::ResultSet)
    value = result.read(Bytes)
    String.new value
  end
end
