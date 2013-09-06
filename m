Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45412 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3IFJ1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Sep 2013 05:27:47 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn9so609011wib.11
        for <linux-wireless@vger.kernel.org>; Fri, 06 Sep 2013 02:27:46 -0700 (PDT)
MIME-Version: 1.0
From: "Brian O'Connor" <bocon13@gmail.com>
Date: Fri, 6 Sep 2013 02:27:26 -0700
Message-ID: <CAHhaCVjomgED0WW1fyUQbePNS0DnPEfKb5uE-+rEMhx6zgO1ZA@mail.gmail.com> (sfid-20130906_112752_332150_F43F6BE4)
Subject: beginner build question
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying to compile rtl8192su in Ubuntu 13.04 and I get the
following error when I "make all":

make -C /lib/modules/3.10.10-031010-generic/build
M=/home/media/rtl8192su/r92su CONFIG_R92SU=m CONFIG_R92SU_DEBUGFS=y
CONFIG_R92SU_WPC=y all EXTRA_CFLAGS="-DDEBUG -DCONFIG_R92SU=m
-DCONFIG_R92SU_DEBUGFS=y -DCONFIG_R92SU_WPC=y"
make[1]: Entering directory `/usr/src/linux-headers-3.10.10-031010-generic'
make[1]: *** No rule to make target `vmlinux', needed by `all'.  Stop.
make[1]: Leaving directory `/usr/src/linux-headers-3.10.10-031010-generic'
make: *** [all] Error 2

Any suggestions?

Thanks in advance,
Brian
