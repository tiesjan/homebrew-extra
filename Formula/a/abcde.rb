class Abcde < Formula
  desc "Better CD Encoder"
  homepage "https://abcde.einval.com"
  url "https://abcde.einval.com/download/abcde-2.9.3.tar.gz"
  sha256 "046cd0bba78dd4bbdcbcf82fe625865c60df35a005482de13a6699c5a3b83124"
  license "GPL-2.0-or-later"
  head "https://git.einval.com/git/abcde.git", branch: "master"

  depends_on "pkgconf" => :build

  depends_on "eye-d3"
  depends_on "flac"
  depends_on "lame"
  depends_on "libcdio-paranoia"
  depends_on "libdiscid"
  depends_on "mkcue"
  depends_on "perl"
  depends_on "tiesjan/extra/cd-discid"
  depends_on "vorbis-tools"

  resource "MusicBrainz::DiscID" do
    url "https://cpan.metacpan.org/authors/id/N/NJ/NJH/MusicBrainz-DiscID-0.06.tar.gz"
    sha256 "ba0b6ed09897ff563ba59872ee93715bef37157515b19b7c6d6f286e6548ecab"

    # Fix for Perl 5.42+
    patch do
      url "https://salsa.debian.org/perl-team/modules/packages/libmusicbrainz-discid-perl/-/raw/master/debian/patches/perl-5.42.patch"
      sha256 "dc2b55aeb0c9c2ca31a622eb37809199dd466f28ce9a981518db3445b11c4386"
    end
  end

  resource "WebService::MusicBrainz" do
    url "https://cpan.metacpan.org/authors/id/B/BF/BFAIST/WebService-MusicBrainz-1.0.5.tar.gz"
    sha256 "523b839968206c5751ea9ee670c7892c8c3be0f593aa591a00c0315468d09099"
  end

  resource "Mojo::Base" do
    url "https://cpan.metacpan.org/authors/id/S/SR/SRI/Mojolicious-8.64.tar.gz"
    sha256 "547a2c592e30ab5f22e42af9a84982b5cd699553f51226b6ed9524b4b7f4b24d"
  end

  # Apply patch for MacOS compatibility
  patch do
    url "https://raw.githubusercontent.com/tiesjan/homebrew-extra/d27d6223edb1f23c29e0747e75e072eb8e03574d/Patches/a/abcde.patch"
    sha256 "57dce81aba1390363c2281edc411b777434443a99ff548018102668b74c45310"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resources.each do |r|
      r.stage do
        system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
        system "make", "install"
      end
    end

    inreplace "abcde-musicbrainz-tool", "#!/usr/bin/perl", "#!/usr/bin/env perl"

    system "make", "install", "prefix=#{prefix}", "sysconfdir=#{etc}"

    bin.env_script_all_files(libexec/"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abcde -v")
  end
end
