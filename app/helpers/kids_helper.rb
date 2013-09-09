module KidsHelper

  def kid_picture(kid, options = { size: 50 })
    base_path="pictures"
    image_path="#{base_path}/no_image.png"
    if !kid.picture.empty?
      image_path="#{base_path}/#{kid.picture}"
    end
    size = options[:size]
    image_tag(image_path, width: size, height: size, alt: kid.name, class: "gravatar")
  end

end
