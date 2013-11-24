Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:58848 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3KXA4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Nov 2013 19:56:31 -0500
Received: by mail-lb0-f169.google.com with SMTP id y6so2205764lbh.0
        for <linux-wireless@vger.kernel.org>; Sat, 23 Nov 2013 16:56:29 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 24 Nov 2013 08:56:29 +0800
Message-ID: <CAKH5=LuKOqndw2j1Zj6wpdv_TLoM_W+kgNvri63aKKQJRg5CFw@mail.gmail.com> (sfid-20131124_015645_183075_B9DED944)
Subject: how to solve /bin/sh: line 11: /bin/arch: No such file or directory ??
From: Naughtboy <skylvlinux@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dear all   i meet  thefollw problem , look for help ,  if you kown the
solution ,!!
thanks advance!!!

        CC=mipsel-uclibc-linux26-gcc ./configure \
                --target=mipsel-uclibc-linux26 \
                --host=mipsel-uclibc-linux26 \
                --build=`/bin/arch`-linux \
                --enable-shared \
                --disable-static \
                --disable-cups \
                --disable-iprint \
                --disable-pie \
                --disable-fam \
                --localstatedir=/tmp/samba/lib/ \
                --with-configdir=/tmp/samba/lib/ \
                --with-privatedir=/tmp/samba/private \
                --with-lockdir=/tmp/samba/var/locks \
                --with-piddir=/tmp/samba/var/locks \
                --without-ldap \
                --without-sys-quotas \
                --without-cifsmount \
                --prefix=/tmp/samba; \
        )
/bin/sh: line 11: /bin/arch: No such file or directory
SAMBA VERSION: 3.0.25b
LIBREPLACE_LOCATION_CHECKS: START
checking build system type... configure: error: /bin/sh ./config.sub
-linux failed
configure: WARNING: Cache variable ac_cv_build contains a newline.
make[3]: *** [configure] Error 1
