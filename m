Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mta4.srv.hcvlny.cv.net ([167.206.4.199]:63229 "EHLO
	mta4.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568AbYEXO14 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 May 2008 10:27:56 -0400
Received: from [192.168.1.10] (ool-44c60ac6.dyn.optonline.net [68.198.10.198])
 by mta4.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0K1D00E8CLGIYCF0@mta4.srv.hcvlny.cv.net> for
 linux-wireless@vger.kernel.org; Sat, 24 May 2008 09:57:55 -0400 (EDT)
Date: Sat, 24 May 2008 09:57:54 -0400
From: Jerry Quinn <jlquinn@optonline.net>
Subject: compat-wireless failed to build
To: linux-wireless@vger.kernel.org
Message-id: <48381EE2.4070800@optonline.net> (sfid-20080524_162818_785850_1A98C1F6)
MIME-version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi. I'm trying to build the latest compat-wireless tarball (05-23) on t=
he=20
latest Debian
testing kernel 2.6.25-2-686. It fails to compile iface.c:

make[1]: Entering directory `/usr/src/linux-headers-2.6.25-2-686'
CC [M] /root/compat-wireless-2008-05-23/net/mac80211/iface.o
/root/compat-wireless-2008-05-23/net/mac80211/iface.c: In function=20
=91ieee80211_if_add=92:
/root/compat-wireless-2008-05-23/net/mac80211/iface.c:56: error: =91str=
uct=20
net_device=92 has no member named =91needed_headroom=92
/root/compat-wireless-2008-05-23/net/mac80211/iface.c:63: error: =91str=
uct=20
net_device=92 has no member named =91needed_tailroom=92
make[3]: *** [/root/compat-wireless-2008-05-23/net/mac80211/iface.o] Er=
ror 1
make[2]: *** [/root/compat-wireless-2008-05-23/net/mac80211] Error 2
make[1]: *** [_module_/root/compat-wireless-2008-05-23] Error 2
make[1]: Leaving directory `/usr/src/linux-headers-2.6.25-2-686'
make: *** [modules] Error 2
naga:~/compat-wireless-2008-05-23#

Thanks
Jerry Quinn
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
