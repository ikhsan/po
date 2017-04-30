import Foundation
import Kitura
import KituraTemplateEngine

public struct Page {
    let template: String
    let context: [String : Any]
}

extension RouterResponse {

    @discardableResult
    public func renderStencilPage(_ page: Page, options: RenderingOptions = NullRenderingOptions()) throws -> RouterResponse {
        return try render("\(page.template).stencil", context: page.context, options: options)
    }

}
