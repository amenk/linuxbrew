# Xcode 4.3 provides the Apple libtool.
# This is not the same so as a result we must install this as glibtool.

class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.xz"
  mirror "https://ftp.gnu.org/gnu/libtool/libtool-2.4.6.tar.xz"
  sha1 "3e7504b832eb2dd23170c91b6af72e15b56eb94e"

  bottle do
    cellar :any
    sha1 "2d08e8a6d58d789194efcb3d6e4b822e6ad409cc" => :yosemite
    sha1 "f545d684854815e7a5a5c1d4e6372ac26a7516ff" => :mavericks
    sha1 "dd1e72102dda61ab33da205e9cfb507a269fd0b9" => :mountain_lion
  end

  keg_only :provided_until_xcode43

  option :universal
  option "with-default-names", "Do not prepend 'g' to the binary"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          ("--program-prefix=g" if build.without? "default-names"),
                          "--enable-ltdl-install"
    system "make", "install"

    if build.with? "default-names"
      bin.install_symlink "libtool" => "glibtool"
      bin.install_symlink "libtoolize" => "glibtoolize"
    end
  end

  def caveats; <<-EOS.undent
    In order to prevent conflicts with Apple's own libtool we have prepended a "g"
    so, you have instead: glibtool and glibtoolize.
    EOS
  end

  test do
    system "#{bin}/glibtool", "execute", "/usr/bin/true"
  end
end
