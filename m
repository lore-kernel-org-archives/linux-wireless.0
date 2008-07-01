Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3832 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbYGAUq4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 16:46:56 -0400
Date: Tue, 1 Jul 2008 16:37:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Compilation warnings for latest wireless-testing
Message-ID: <20080701203736.GB9225@tuxdriver.com> (sfid-20080701_224709_147194_DDC3CE4D)
References: <486A8DA3.7070805@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <486A8DA3.7070805@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 01, 2008 at 03:03:47PM -0500, Larry Finger wrote:
> On x86_64, the latest wireless-testing gets the following warnings:
>
>   CC [M]  net/mac80211/michael.o
> net/mac80211/michael.c: In function =E2=80=98michael_mic_hdr=E2=80=99=
:
> net/mac80211/michael.c:35: warning: passing argument 1 of =20
> =E2=80=98ieee80211_get_DA=E2=80=99 discards qualifiers from pointer t=
arget type
> net/mac80211/michael.c:36: warning: passing argument 1 of =20
> =E2=80=98ieee80211_get_SA=E2=80=99 discards qualifiers from pointer t=
arget type
> net/mac80211/michael.c:37: warning: passing argument 1 of =20
> =E2=80=98ieee80211_get_qos_ctl=E2=80=99 discards qualifiers from poin=
ter target type

I think this will disappear after I revert the other patch you
mentioned in another thread.

John
--=20
John W. Linville
linville@tuxdriver.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
