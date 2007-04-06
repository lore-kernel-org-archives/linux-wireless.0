Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp116.iad.emailsrvr.com ([207.97.245.116]:53248 "EHLO
	smtp116.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933275AbXDFWnp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2007 18:43:45 -0400
Message-ID: <4616CD15.80405@gentoo.org>
Date: Fri, 06 Apr 2007 18:43:33 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: mac80211 debugfs compile failure
References: <200704070028.02143.mb@bu3sch.de>
In-Reply-To: <200704070028.02143.mb@bu3sch.de>
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> net/mac80211/debugfs.c: In function =E2=80=98stats_wme_rx_queue_read=E2=
=80=99:
> net/mac80211/debugfs.c:266: error: =E2=80=98struct ieee80211_local=E2=
=80=99 has no member named =E2=80=98wme_rx_queue=E2=80=99
> net/mac80211/debugfs.c: In function =E2=80=98stats_wme_tx_queue_read=E2=
=80=99:
> net/mac80211/debugfs.c:286: error: =E2=80=98struct ieee80211_local=E2=
=80=99 has no member named =E2=80=98wme_tx_queue=E2=80=99
> make[2]: *** [net/mac80211/debugfs.o] Error 1
> make[1]: *** [net/mac80211] Error 2
> make: *** [net] Error 2
>=20
> Seems like some ifdefs missing or something. Does a patch exist?
>=20

 From Johannes:
[PATCH] fix debugfs compile w/o debug counters

-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
