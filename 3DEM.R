# ---- 0: Load Packages ----
  
  require(terra)
  require(rayshader)
  require(av)
  require(magick)
  require(gifski)
  require(sf)

# ---- 1: Load & Format DEM ----

  # Load DEM
  dem = rast(file.choose())
  
  # Convert DEM to a matrix
  matdem = raster_to_matrix(dem)

# ---- 2: Pre-Render Shadows & Ambient Shading ----

  shadow = ray_shade(matdem, zscale = 50, lambert = FALSE)
  amb = ambient_shade(matdem, zscale = 50)
  water = detect_water(matdem)
  tex = texture_shade(matdem, detail = 1, contrast = 5, brightness = 6)
  lamb = lamb_shade(matdem,zscale = 50)
  contour = generate_contour_overlay(matdem, linewidth = 2)

# ---- Render 3D ----
  
  matdem %>%
    sphere_shade(sunangle = 350, texture = "imhof3") %>%
    add_shadow(shadow, 0.5) %>%
    add_shadow(amb, 0) %>%
    add_shadow(tex,0) %>%
    # add_shadow(lamb,0) %>%  # Optional
    plot_3d(matdem, zscale = 20, fov = 0, theta = -45, phi = 45,         # Adjust Angle Here
            windowsize = c(900, 900), zoom = 0.6, background = "ivory",
            water = TRUE, waterdepth = 0, wateralpha = 0.7, watercolor = "imhof3",
            waterlinecolor = "white", waterlinealpha = 0.7, baseshape = "circle")
  Sys.sleep(0.2)
  
  render_movie(filename = "DEM_Circle_Animation.gif", type = "orbit", 
               frames = 360, fps = 60,  phi = 45, zoom = 0.6, theta = -45,
               width = 1920, height = 1080)
  
  # Optional Ray-tracing Render
  render_highquality(lightintensity = 750, lightcolor = "antiquewhite", clear=TRUE)
  