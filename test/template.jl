using PkgTemplates

@testset "Template" begin

    dir = tempdir()
    t = TaijaBase.pkg_template(authors="Jane Doe", dir=dir)
    @test typeof(t) == PkgTemplates.Template

end