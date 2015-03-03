require 'formula'

class Plplot < Formula
  homepage 'http://plplot.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/plplot/plplot/5.10.0%20Source/plplot-5.10.0.tar.gz'
  sha1 'ea962cb0138c9b4cbf97ecab1fac1919ea0f939f'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'pango'
  depends_on :x11 => :optional

  option 'with-java'

  # Fix from upstream to accommodate CMAKE 3.10
  # See http://sourceforge.net/p/plplot/plplot/ci/772223c638ecf5dc740c9f3dd7a6883c6d2c83d2/
  patch do
    url "https://gist.githubusercontent.com/mwcraig/32f6b8645de3e862a7c3/raw/97770aa2eddd3174145517ff47be398b851a8ddb/pkg-config.diff"
    sha1 "2754717622cf5a61805af499eb298e0646c54f5c"
  end

  # Fix from upstream to avoid conflicting definitions of HAVE_CONFIG_H
  # See http://sourceforge.net/p/plplot/bugs/147/
  patch do
    url "https://gist.githubusercontent.com/mwcraig/5059504e65dd0b804bd8/raw/8869cd9b6d188bad9be87c23154bfe0bde054f62/better_fix.diff"
    sha1 "6e9bf8e09d500546cfe872c3f3d92b4ffe39588c"
  end

  def install
    args = std_cmake_args
    args << '-DPLD_wxwidgets=OFF' << '-DENABLE_wxwidgets=OFF'
    args << '-DENABLE_java=OFF' if build.without? 'java'
    args << '-DPLD_xcairo=OFF' if build.without? 'x11'
    mkdir "plplot-build" do
      system "cmake", "..", *args
      system "make"
      system "make install"
    end
  end
end
