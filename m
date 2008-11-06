Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:4363 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401AbYKFPdf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 10:33:35 -0500
Received: by yx-out-2324.google.com with SMTP id 8so253487yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 07:33:33 -0800 (PST)
Message-ID: <49135499.60707@gmail.com> (sfid-20081106_163339_585611_B74CA521)
Date: Thu, 06 Nov 2008 15:33:29 -0500
From: Gert Steenssens <gsteenss@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: error when building Intel compat wireless
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to build Intel compat wireless drivers for 2.6.22 on Ubuntu
7.10 but get the errors shown below.

At some point during making ( i guess during or after:
=2E/scripts/gen-compat-autoconf.sh config.mk ) it reports: 'Fatal: not =
a
git repository'

any idea how to fix this?

Thanks,
Gert




make -C /lib/modules/2.6.22-15-generic/build
M=3D/home/gsteenss/compat-wireless-2.6-old modules
make[1]: Entering directory `/usr/src/linux-headers-2.6.22-15-generic'
LD /home/gsteenss/compat-wireless-2.6-old/drivers/misc/built-in.o
CC [M] /home/gsteenss/compat-wireless-2.6-old/drivers/misc/eeprom_93cx6=
=2Eo
LD /home/gsteenss/compat-wireless-2.6-old/drivers/net/built-in.o
CC [M] /home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.o
In file included from
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:34:
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.h:361: error:
field =91napi=92 has incomplete type
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c: In function
=91b44_poll=92:
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:849: warning:
type defaults to =91int=92 in declaration of =91__mptr=92
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:849: warning:
initialization from incompatible pointer type
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:879: error: to=
o
many arguments to function =91netif_rx_complete=92
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c: In function
=91b44_interrupt=92:
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:911: error: to=
o
many arguments to function =91netif_rx_schedule_prep=92
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:917: error: to=
o
many arguments to function =91__netif_rx_schedule=92
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c: In function
=91b44_open=92:
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:1433: warning:
implicit declaration of function =91napi_enable=92
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:1442: warning:
implicit declaration of function =91napi_disable=92
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c: At top level:
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:2051: error:
unknown field =91get_sset_count=92 specified in initializer
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:2051: warning:
initialization from incompatible pointer type
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c: In function
=91b44_init_one=92:
/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.c:2159: warning:
implicit declaration of function =91netif_napi_add=92
make[3]: *** [/home/gsteenss/compat-wireless-2.6-old/drivers/net/b44.o]
Error 1
make[2]: *** [/home/gsteenss/compat-wireless-2.6-old/drivers/net] Error=
 2
make[1]: *** [_module_/home/gsteenss/compat-wireless-2.6-old] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.22-15-generic'
make: *** [modules] Error 2




--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
