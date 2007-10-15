Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp5.oregonstate.edu ([128.193.15.33]:41798 "EHLO
	smtp5.oregonstate.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbXJOXD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 19:03:56 -0400
Message-ID: <4713EBCA.8010700@gmail.com> (sfid-20071016_000400_447813_00A402AF)
Date: Mon, 15 Oct 2007 15:38:02 -0700
From: John Daiker <daikerjohn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: "John W. Linville" <linville@tuxdriver.com>
Subject: Ath5k compile error in wireless-2.6.git
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

I just checked out the wireless-2.6.git tree from Kernel.org to test th=
e=20
new ath5k driver. I get the following compile error on a 'vanilla'=20
git-clone.

CC [M] drivers/net/wireless/ath5k/base.o
In file included from drivers/net/wireless/ath5k/base.h:49,
from drivers/net/wireless/ath5k/base.c:58:
drivers/net/wireless/ath5k/ath5k.h:213: error: redeclaration of=20
enumerator =91MODE_ATHEROS_TURBO=92
include/net/mac80211.h:105: error: previous definition of=20
=91MODE_ATHEROS_TURBO=92 was here
drivers/net/wireless/ath5k/ath5k.h:215: error: redeclaration of=20
enumerator =91MODE_ATHEROS_TURBOG=92
include/net/mac80211.h:107: error: previous definition of=20
=91MODE_ATHEROS_TURBOG=92 was here
drivers/net/wireless/ath5k/base.c: In function =91ath_configure_filter=92=
:
drivers/net/wireless/ath5k/base.c:1419: error: =91FIF_PROMISC_IN_BSS=92=
=20
undeclared (first use in this function)
drivers/net/wireless/ath5k/base.c:1419: error: (Each undeclared=20
identifier is reported only once
drivers/net/wireless/ath5k/base.c:1419: error: for each function it=20
appears in.)
drivers/net/wireless/ath5k/base.c:1419: error: =91FIF_ALLMULTI=92 undec=
lared=20
(first use in this function)
drivers/net/wireless/ath5k/base.c:1419: error: =91FIF_FCSFAIL=92 undecl=
ared=20
(first use in this function)
drivers/net/wireless/ath5k/base.c:1419: error: =91FIF_PLCPFAIL=92 undec=
lared=20
(first use in this function)
drivers/net/wireless/ath5k/base.c:1419: error: =91FIF_CONTROL=92 undecl=
ared=20
(first use in this function)
drivers/net/wireless/ath5k/base.c:1419: error: =91FIF_OTHER_BSS=92=20
undeclared (first use in this function)
drivers/net/wireless/ath5k/base.c:1419: error: =91FIF_BCN_PRBRESP_PROMI=
SC=92=20
undeclared (first use in this function)
drivers/net/wireless/ath5k/base.c: At top level:
drivers/net/wireless/ath5k/base.c:1479: warning: =91enum set_key_cmd=92=
=20
declared inside parameter list
drivers/net/wireless/ath5k/base.c:1479: warning: its scope is only this=
=20
definition or declaration, which is probably not what you want
drivers/net/wireless/ath5k/base.c:1477: error: parameter 2 (=91cmd=92) =
has=20
incomplete type
drivers/net/wireless/ath5k/base.c:1583: error: unknown field =91start=92=
=20
specified in initializer
drivers/net/wireless/ath5k/base.c:1584: warning: initialization from=20
incompatible pointer type
drivers/net/wireless/ath5k/base.c:1589: error: unknown field=20
=91configure_filter=92 specified in initializer
drivers/net/wireless/ath5k/base.c:1589: warning: initialization from=20
incompatible pointer type
drivers/net/wireless/ath5k/base.c:1590: warning: initialization from=20
incompatible pointer type
make[4]: *** [drivers/net/wireless/ath5k/base.o] Error 1
make[3]: *** [drivers/net/wireless/ath5k] Error 2
make[2]: *** [drivers/net/wireless] Error 2
make[1]: *** [drivers/net] Error 2


Maybe you can shed some light?

John
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
