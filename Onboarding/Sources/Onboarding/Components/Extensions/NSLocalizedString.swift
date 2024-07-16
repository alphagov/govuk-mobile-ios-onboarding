import Foundation

public func NSLocalizedString(key: String,
                              tableName: String? = nil,
                              bundle: Bundle = Bundle.main,
                              value: String = "",
                              comment: String = "") -> String {

    NSLocalizedString(key, bundle: bundle, value: value, comment: comment)
}
