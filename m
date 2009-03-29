Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:45654 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757569AbZC2Udu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 16:33:50 -0400
Message-ID: <49CFDB1F.7040902@hauke-m.de> (sfid-20090329_223407_944959_40DAED62)
Date: Sun, 29 Mar 2009 22:33:35 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Bringfried Stecklum <stecklum@tls-tautenburg.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: compile error compat-wireless-2009-03-29
References: <49CFD043.6020708@tls-tautenburg.de>
In-Reply-To: <49CFD043.6020708@tls-tautenburg.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bringfried Stecklum wrote:
> When trying to compile the latest compat-wireless packagev
> (2.6.29-20327-g8f2487d) on an Ubuntu 8.10 system running linux kernel
> 2.6.27-12 I get the following error
>=20
> /home/stecklum/System/src/compat-wireless-2009-03-29/net/mac80211/agg=
-tx.c:
> In function =E2=80=98ieee80211_agg_splice_packets=E2=80=99:
> /home/stecklum/System/src/compat-wireless-2009-03-29/net/mac80211/agg=
-tx.c:385:
> error: implicit declaration of function =E2=80=98skb_queue_splice_tai=
l_init=E2=80=99
> make[3]: ***
> [/home/stecklum/System/src/compat-wireless-2009-03-29/net/mac80211/ag=
g-tx.o]
> Error 1
> make[2]: ***
> [/home/stecklum/System/src/compat-wireless-2009-03-29/net/mac80211] E=
rror 2
> make[1]: ***
> [_module_/home/stecklum/System/src/compat-wireless-2009-03-29] Error =
2
> make[1]: Leaving directory `/usr/src/linux-headers-2.6.27-12-mygeneri=
c'
> make: *** [modules] Error 2

Hi,

This is already know. The patch can be found here:
http://marc.info/?l=3Dlinux-wireless&m=3D123825765019764

Hauke
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
