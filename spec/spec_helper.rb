def define_const(type, name)
  klass = name.split('::').inject(Object) do |parent, name|
    if parent.const_defined?(name)
      parent.const_get(name)
    else
      parent.const_set(name, type.new)
    end
  end
end

def remove_const(name)
  names = name.split('::')

  parents = names[0..-2].inject([Object]) do |parents, name|
    parents << parents.last.const_get(name)
  end

  names.reverse.each do |name|
    parent = parents.pop
    parent.class_eval { remove_const name }
    break unless parent.constants.empty?
  end
end

def slot_stub
  stub.tap do |s|
    s.stub!(:[]).and_return { |language_spec| "item for #{language_spec}" }
  end
end
