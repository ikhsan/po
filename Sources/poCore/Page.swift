import Foundation
import Kitura
import KituraTemplateEngine

public struct Page {
    let template: String
    var context: [String : Any]

    public mutating func setValue(_ value: Any, for key: String) {
        context[key] = value
    }
}

extension RouterResponse {

    @discardableResult
    public func renderStencilPage(_ page: Page, options: RenderingOptions = NullRenderingOptions()) throws -> RouterResponse {
        return try render("\(page.template).stencil", context: page.context, options: options)
    }

}
