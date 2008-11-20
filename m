Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 208-104-20-34.fmgh.2wcm.comporium.net ([208.104.20.34]:52765
	"EHLO router1.tdux.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbYKTLdE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 06:33:04 -0500
Received: from video1 ([10.240.0.2])
	by router1.tdux.com (8.14.1/8.14.1) with ESMTP id mAKBX2IL021299
	for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 06:33:03 -0500
From: "tduckett" <duck@tdux.com>
To: <linux-wireless@vger.kernel.org>
Subject: Error compiling.    Please help
Date: Thu, 20 Nov 2008 06:33:02 -0500
Message-ID: <002d01c94b03$c2544ee0$0200f00a@video1> (sfid-20081120_123317_427189_7B23221D)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I never seem to be able to get things compiled=A0 This is what I get wh=
en I
run make.=A0 What do I need to do to get this to work?



make -C /lib/modules/2.6.23.15-80.fc7/build
M=3D/tmp/t2/compat-wireless-2.6-old modules
make[1]: Entering directory `/usr/src/kernels/2.6.23.15-80.fc7-i686'
/tmp/t2/compat-wireless-2.6-old/config.mk:53: "WARNING: You are running=
 a
kernel >=3D 2.6.23, you should enable in it CONFIG_NETDEVICES_MULTIQUEU=
E for
802.11[ne] support"
=A0 CC [M]=A0 /tmp/t2/compat-wireless-2.6-old/drivers/net/b44.o
In file included from /tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c=
:35:
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.h:361: error: field =E2=
napi=E2
has incomplete type
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c: In function =E2b44_p=
oll=E2:
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c:849: warning: type
defaults to =E2int=E2 in declaration of =E2__mptr=E2
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c:849: warning:
initialization from incompatible pointer type
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c:879: error: too many
arguments to function =E2netif_rx_complete=E2
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c: In function
=E2b44_interrupt=E2:
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c:911: error: too many
arguments to function =E2netif_rx_schedule_prep=E2
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c:917: error: too many
arguments to function =E2__netif_rx_schedule=E2
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c: In function =E2b44_o=
pen=E2:
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c:1433: error: implicit
declaration of function =E2napi_enable=E2
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c:1442: error: implicit
declaration of function =E2napi_disable=E2
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c: At top level:
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c:2051: error: unknown =
field
=E2get_sset_count=E2 specified in initializer
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c:2051: warning:
initialization from incompatible pointer type
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c: In function
=E2b44_init_one=E2:
/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.c:2159: error: implicit
declaration of function =E2netif_napi_add=E2
make[3]: *** [/tmp/t2/compat-wireless-2.6-old/drivers/net/b44.o] Error =
1
make[2]: *** [/tmp/t2/compat-wireless-2.6-old/drivers/net] Error 2
make[1]: *** [_module_/tmp/t2/compat-wireless-2.6-old] Error 2
make[1]: Leaving directory `/usr/src/kernels/2.6.23.15-80.fc7-i686'
make: *** [modules] Error 2


Thank you in advance=20
Duck


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
