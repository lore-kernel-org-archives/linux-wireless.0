Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:53061 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951Ab0AOVWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 16:22:52 -0500
Received: by pzk1 with SMTP id 1so1259725pzk.33
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jan 2010 13:22:51 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 15 Jan 2010 13:22:51 -0800
Message-ID: <fd145f7d1001151322y6e0b2a74hb4c9971db8fe435c@mail.gmail.com>
Subject: compat-wireless 2010-01-13 fails to build
From: Jeffrey Baker <jwbaker@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

/root/compat-wireless-2010-01-13/net/wireless/nl80211.c:17:50: error:
missing ')' in expression
make[5]: *** [/root/compat-wireless-2010-01-13/net/wireless/nl80211.o] Error 1
make[4]: *** [/root/compat-wireless-2010-01-13/net/wireless] Error 2
make[3]: *** [_module_/root/compat-wireless-2010-01-13] Error 2
make[2]: *** [sub-make] Error 2
make[1]: *** [all] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.30-2-486'
make: *** [modules] Error 2

# uname -a
Linux mango 2.6.30-2-486 #1 Sat Sep 26 00:03:46 UTC 2009 i586 GNU/Linux
# gcc-4.3 -v
Using built-in specs.
Target: i486-linux-gnu
Configured with: ../src/configure -v --with-pkgversion='Debian
4.3.4-6' --with-bugurl=file:///usr/share/doc/gcc-4.3/README.Bugs
--enable-languages=c,c++,fortran,objc,obj-c++ --prefix=/usr
--enable-shared --enable-multiarch --enable-linker-build-id
--with-system-zlib --libexecdir=/usr/lib --without-included-gettext
--enable-threads=posix --enable-nls
--with-gxx-include-dir=/usr/include/c++/4.3 --program-suffix=-4.3
--enable-clocale=gnu --enable-libstdcxx-debug --enable-objc-gc
--enable-mpfr --enable-targets=all --with-tune=generic
--enable-checking=release --build=i486-linux-gnu --host=i486-linux-gnu
--target=i486-linux-gnu
Thread model: posix
gcc version 4.3.4 (Debian 4.3.4-6)

Full build log is here: http://pastebin.com/m6ee0f005

-jwb
