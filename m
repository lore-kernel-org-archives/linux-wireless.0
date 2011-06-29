Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59036 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609Ab1F2USc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 16:18:32 -0400
Received: by iwn6 with SMTP id 6so1325916iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2011 13:18:32 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 29 Jun 2011 22:18:32 +0200
Message-ID: <BANLkTimsGJo61eLp3NrVtDkh0m3CN3zDxw@mail.gmail.com> (sfid-20110629_221835_948524_E57FF129)
Subject: Compile error in carl9170 on Debian Squeeze
From: Alex <alex9434@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I get the following error when I try to compile carl9170 on Debian
Squeeze (armel)

make[1]: Entering directory `/usr/src/linux-headers-2.6.32-5-kirkwood'
  LD      /usr/src/compat-wireless-2011-06-29/compat/built-in.o
  CC [M]  /usr/src/compat-wireless-2011-06-29/compat/main.o
In file included from
/usr/src/compat-wireless-2011-06-29/include/linux/compat-2.6.h:29,
                 from <command-line>:0:
/usr/src/compat-wireless-2011-06-29/include/linux/compat-2.6.34.h:23:
error: redefinition of 'netdev_name'
/usr/src/linux-headers-2.6.32-5-common/include/linux/netdevice.h:2032:
error: previous definition of 'netdev_name' was here
make[5]: *** [/usr/src/compat-wireless-2011-06-29/compat/main.o] Error 1
make[4]: *** [/usr/src/compat-wireless-2011-06-29/compat] Error 2
make[3]: *** [_module_/usr/src/compat-wireless-2011-06-29] Error 2
make[2]: *** [sub-make] Error 2
make[1]: *** [all] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.32-5-kirkwood'
make: *** [modules] Error 2

Get the same error on older versions from 2010 of compat. Can anybody help me?

Regards,
alex
