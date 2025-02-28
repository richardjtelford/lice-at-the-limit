# render index, outreach
quarto::quarto_render("outreach")

# Make _ directories work
fs::file_create("docs/.nojekyll")


# copy ms to docs
fs::file_copy("lice-at-the-limit.pdf", "docs/lice-at-the-limit.pdf", overwrite = TRUE)
fs::file_copy("lice-at-the-limit.html", "docs/lice-at-the-limit.html", overwrite = TRUE)
fs::dir_copy("lice-at-the-limit_files", "docs/lice-at-the-limit_files", overwrite = TRUE)
