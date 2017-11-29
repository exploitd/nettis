class HtmlException < Exception

  setter :tag

  def initialize(msg="Can not find tag", tag="<>")
    @tag = tag
    super(msg)
  end
end
