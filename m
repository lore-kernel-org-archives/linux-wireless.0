Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39306 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYJVHg0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 03:36:26 -0400
Subject: Re: [PATCH ] mac80211: check return value of dev_alloc_skb() in
	ieee80211_sta_join_ibss().
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <eb3ff54b0810220000p71a54f53ped88651b62c6d35c@mail.gmail.com> (sfid-20081022_090050_408102_95470F71)
References: <eb3ff54b0810220000p71a54f53ped88651b62c6d35c@mail.gmail.com>
	 (sfid-20081022_090050_408102_95470F71)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rR7LcOeEHV1Zu4QDv1XV"
Date: Wed, 22 Oct 2008 09:36:18 +0200
Message-Id: <1224660978.28639.27.camel@johannes.berg> (sfid-20081022_093631_747042_90D10FD1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rR7LcOeEHV1Zu4QDv1XV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 09:00 +0200, Rami Rosen wrote:
> This patch adds a check on the return value of dev_alloc_skb() in
> ieee80211_sta_join_ibss()
> in net/mac80211/mlme.c.

What's wrong with the current code?


> +               return -1;

don't return -1, return meaningful error values.

johannes

--=-rR7LcOeEHV1Zu4QDv1XV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/tfuAAoJEKVg1VMiehFYiTkP/3s4oo/bUtoqhCqLOreLQYhc
wdSBwsXDfH4inRtFTuO7LXPkEkdM+v/SE0X7BiouUgpU7Yci+F5BU1JXneIjF7Z5
1tTJPFnX/dCLo81ogYKIkIBPrzME/SU4auYaQo5OXP3prz4yHrXe/MNcPDw2faGU
vXxDvhpr2zEB6ouEHTQ0EQxUl1fTS2g6w1lgMRI1hLZJvCkiG1Qke/mJT291FoRS
5c2kVUQHNrsoa0ATpgUX1kjOAwqbPNMpsN8KtZDswvIn1Y4v3s2E9Hzxiuk6NWBc
P+8qrLwSuPRI7TOX6VUdXAGnc43roZLJYPdaQIAJ7IanWdowjJ+5PnRKzufXO/3y
pY35k9lNndXtVtnHVHiQl2/W5IvRB+OE5XsozxumDOuyt6MQd/7+yb3RfeLh0Fw7
G3f1uFSVUhJzethzUuTwgA5rGpShhmoY6GGZgo3bSDvkwy5O2w1ysi9Ug8YsLxyC
JyFueWPeuYQhmmxk1UC9IsAGDnXkhNyMZwCLw+ih22FFQs8OI+BJ5OJWQAaUmT+f
Xj7H4YNLbCyG8G3BT0uP7OJPd1wf/Mwgm6aoRM432PRQsoYd+CGLTnoC7Is6EgTY
Uy+IQ4Kl6/nekTHP2Qp0t8dfjQ7h50wGOrO1FdOguHU45EDLt1q77QKAUA/7MO1D
XBldPsqBSK0Ymo2ynrHf
=cHLL
-----END PGP SIGNATURE-----

--=-rR7LcOeEHV1Zu4QDv1XV--

