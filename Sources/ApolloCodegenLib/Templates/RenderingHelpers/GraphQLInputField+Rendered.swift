import JavaScriptCore

extension GraphQLInputField {
  func renderInputValueType(includeDefault: Bool = false) -> String {
    "\(type.renderAsInputValue())\(isSwiftOptional ? "?" : "")\(includeDefault && hasSwiftNilDefault ? " = nil" : "")"
  }

  private var isSwiftOptional: Bool {
    !isNullable && hasDefaultValue
  }

  private var hasSwiftNilDefault: Bool {
    isNullable && !hasDefaultValue
  }

  var isNullable: Bool {
    switch type {
    case .nonNull: return false
    default: return true
    }
  }

  var hasDefaultValue: Bool {
    switch defaultValue {
    case .none, .some(nil):
      return false
    case let .some(value):
      guard let value = value as? JSValue else {
        fatalError("Cannot determine default value for Input field: \(self)")
      }

      return !value.isUndefined
    }
  }
}