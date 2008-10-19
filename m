Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57480 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYJSKQy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 06:16:54 -0400
Subject: Re: [PATCH] mac80211: inform userspace of probe/auth/assoc timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <873ait6s4e.fsf@nokia.com>
References: <1224186284.11127.3.camel@johannes.berg>
	 <873ait6s4e.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SVEvgCLisfC+aIgwh+VN"
Date: Sun, 19 Oct 2008 12:16:35 +0200
Message-Id: <1224411395.6324.36.camel@johannes.berg> (sfid-20081019_121658_817755_4E7C63E4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-SVEvgCLisfC+aIgwh+VN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-19 at 09:01 +0300, Kalle Valo wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > I noticed that when for some reason [1] the probe or auth times
> > out, wpa_supplicant doesn't realise this and only tries the next
> > AP when it runs into its own timeout, which is ten seconds, and
> > that's quite long. Fix this by making mac80211 notify userspace
> > that it didn't associate.
>=20
> Earlier this week I received an internal bug report about this.
> Excellent timing for providing a fix. Thank you, Johannes :)

Heh :)

> > Might be worth backporting to stable?
>=20
> I have to backport the patch anyway so I can provide the patch. But I
> don't think this being that important bug to be fixed in stable
> series. We have had this bug in mac80211 always, right?

I'm not entirely sure, I haven't dug through, it might have been
introduced only with one of the refactorings this code has seen.

johannes

--=-SVEvgCLisfC+aIgwh+VN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI+wj/AAoJEKVg1VMiehFYr8UP/1tFJn1Vl7geCZRrEAl8F2qU
8MKZhHM84vA4jw4g6zLhVlU8w6t7cA9GWHXqbJdUD+avms/TJs3GbFiU3jVhwlUd
n423FW4FSX2mMXha9B86iam98/LMdH5XgIzTt8Yv20RTxa/sXgcUJ7xXJvTxhidv
qaqf+xHmp5U2Jx3fSIkiwKzFx/cXZpAvhr2w/aKbQdLww7JQIak7uxqZTp8pHjgH
u3tqcXFe/3uus4ZZg7Tdx0JRu+URu2ysPE+iZr3fuP8D6kdW4RQfovIxuWoX8IIK
KrV8rHOqsO93YKJA0IGYVO79R7922P9qCCpz/2tTkaYu2ZHbwrHmYZM0nXTMUy1C
UVDXvQV8Svtc+LP1XiodeodB37CObY/gm+wSf2uF8pXWEFBlpw9i6W7LUWpvZTM3
o4nuRrqmLisk3dCdY+kF+xqfgZ+n/sLZbV3lwZ4sgAF/6SWg0lCRBCplPwcnVCcR
sWlrnZovVcb67UB4Jm2p7UJTyGAH8FO5dZbLrsX7qRdsJrmm47m2Am4QQjYygM+q
j6/uXKiwlz5+1QwATuHjfBy2fI2+QOI1LMGoMwPJM8147/IwKUDP0A0AJproGtGo
GxIkulM7XS+FHgRjC7YSSuRyynPCLAO+RgLFb68xedmQOdZHVULXNwqxh4jl3mWW
IdTCafov3APygT/UO5/C
=mGNv
-----END PGP SIGNATURE-----

--=-SVEvgCLisfC+aIgwh+VN--

