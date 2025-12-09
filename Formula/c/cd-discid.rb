class CdDiscid < Formula
  desc "Read CD and get CDDB discid information"
  homepage "https://github.com/tiesjan/cd-discid"
  url "https://github.com/tiesjan/cd-discid/archive/refs/tags/1.5.1.tar.gz"
  sha256 "8a3aa06e887d7a202c3c0b1e9310794a41103137d2df2bc542da3e88312c5045"
  license "GPL-2.0-or-later"
  head "https://github.com/tiesjan/cd-discid.git", branch: "master"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "cd-discid"
    man1.install "cd-discid.1"
  end

  test do
    assert_equal "cd-discid #{version}.", shell_output("#{bin}/cd-discid --version 2>&1").chomp
  end
end
