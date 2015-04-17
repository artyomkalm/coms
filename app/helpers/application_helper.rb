module ApplicationHelper
  def full_name(user)
    unless user.nil?
      user.email
    else
      "Unknown"
    end
  end

  def scancode(text)
    CodeRay.scan( text, :ruby, :html).div.html_safe
  end

  class MarkdownRenderer < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.highlight(code, language)
    end
  end
  
  def markdown(text)
    rndr = MarkdownRenderer.new(:filter_html => true, :hard_wrap => true)
    options = {
      :fenced_code_blocks => true,
      :no_intra_emphasis => true,
      :autolink => true,
      :strikethrough => true,
      :lax_html_blocks => true,
      :superscript => true,
      :highlight => true
    }
    markdown_to_html = Redcarpet::Markdown.new(rndr, options)
    markdown_to_html
    #.render(text).html_safe
  end

end