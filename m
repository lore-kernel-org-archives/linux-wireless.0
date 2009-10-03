Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35664 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749AbZJCDAC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 23:00:02 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1Mtuqq-0000N7-11
	for linux-wireless@vger.kernel.org; Sat, 03 Oct 2009 05:00:04 +0200
Received: from knvl-01-1736.dsl.iowatelecom.net ([71.7.54.200])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2009 05:00:04 +0200
Received: from vpndist100 by knvl-01-1736.dsl.iowatelecom.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 03 Oct 2009 05:00:04 +0200
To: linux-wireless@vger.kernel.org
From: Parker <vpndist100@yahoo.com>
Subject: unable to compile - error: implicit declaration of function =?utf-8?b?4oCYRElWX1JPVU5EX0NMT1NFU1TigJk=?=
Date: Sat, 3 Oct 2009 02:58:24 +0000 (UTC)
Message-ID: <loom.20091003T045434-645@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm trying to compile compat-wireless-2.6.32-rc1.

Here is my term output.  Not sure what's wrong.

$ make
make -C /lib/modules/2.6.28-11-generic/build
M=/home/xxx/Desktop/compat-wireless-2.6.32-rc1 modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.28-11-generic'
  CC [M]  /home/xxx/Desktop/compat-wireless-2.6.32-rc1/drivers/net/b44.o
/home/xxx/Desktop/compat-wireless-2.6.32-rc1/drivers/net/b44.c: In function
‘b44_chip_reset’:
/home/xxx/Desktop/compat-wireless-2.6.32-rc1/drivers/net/b44.c:1300: error:
implicit declaration of function ‘DIV_ROUND_CLOSEST’
make[3]: *** [/home/xxx/Desktop/compat-wireless-2.6.32-rc1/drivers/net/b44.o]
Error 1
make[2]: *** [/home/xxx/Desktop/compat-wireless-2.6.32-rc1/drivers/net] Error 2
make[1]: *** [_module_/home/xxx/Desktop/compat-wireless-2.6.32-rc1] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.28-11-generic'
make: *** [modules] Error 2


