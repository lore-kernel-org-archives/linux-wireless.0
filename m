Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757944AbZDSOxO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 10:53:14 -0400
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090419144108.158790@gmx.net> (sfid-20090419_164139_347477_E9AF49DE)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240147370.898.0.camel@johannes.local>
	 <20090419142631.158790@gmx.net>
	 (sfid-20090419_162703_506410_10175D69) <1240151561.898.12.camel@johannes.local>
	 <20090419144108.158790@gmx.net> (sfid-20090419_164139_347477_E9AF49DE)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-C1icJB9HiChx0QR4sH6o"
Date: Sun, 19 Apr 2009 16:53:10 +0200
Message-Id: <1240152790.898.15.camel@johannes.local> (sfid-20090419_165318_220324_4EA31200)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-C1icJB9HiChx0QR4sH6o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 16:41 +0200, Alina Friedrichsen wrote:
> Hello Johannes!
>=20
> > That's not what I was referring to -- and wext doesn't actually allow
> > what I'm referring to afaik.
>=20
> You must budget it, when you want implement the old wext code clean with =
cfg80211.
>=20
> > When you want to create an IBSS on channel 5, what do you do?
> >=20
> > I think you have to
> > 	iwconfig wlan0 essid test
> > 	iwconfig wlan0 channel 5
> > 	iwconfig wlan0 ap off # clear fixed channel bit
> >=20
> > which is ... weird.
>=20
> Why not make simply the following?
>=20
> iwconfig wlan0 channel 5
> iwconfig wlan0 essid test

That fixes the channel to 5.

johannes

--=-C1icJB9HiChx0QR4sH6o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6zrTAAoJEKVg1VMiehFYuNgP/i3UBEpXs7sDgcLClvhTxMpH
lrXqpNCV9+0rCxrx1LNOZKh9UW21aIni8bdcQNoUPvQdxDI7tKeqF9ZMMv+MKoC6
RAmJeVV1Otz16BAy4i72n+mTyVQglfW8T2LnAG5SapNben+YXOMmFER+KQTPPZvE
Z4WoEjnokqNSIT9+XFDnmcY+3BdFL1MUMOv1kuBNIuazjxBVc56xJ8+WJhnQLxgm
tFCOj58AFTFP42m3pg3MebkUCeVp0WPvIje8/vmlHiRugVDJweMgejxPnyI/MgXR
KFDxApwBWJTSA5+kMMr+sRC0kpWOi1ApFwo6DqUbRUrc8wf4P8F888yfr+Hbmr/M
+Q/4dwWlCEAkqeK3UQKHtz+OZuzyV8vVJRhpFfUDoKuZkE7ixQoowWfJRVXjsrhZ
MmATzxlt738PjybkaEguzBkyQBy5NUEmN4Asdka+N+CRz8tAB/CESWVYVu5RTP0O
c03Z7CzIxdqDbaRNufoikKc6KFavYVxlQa0KKJlHifQpMWOu6G8LA7a2qgcfDa+J
7hYDTyxvgaqxokXk+P/1nrNppF7/lGNc1iSOc8zLAQvlRwPgPEByYOHKMt2BkxH9
L6VkK15RiCOsKRKCvQnoH84w0n/2FJM5Cpp4rHtqvZj0CxJinBPgPd0y5+SFusF7
W+eukN5YNzo8c68a9XM9
=9/T7
-----END PGP SIGNATURE-----

--=-C1icJB9HiChx0QR4sH6o--

