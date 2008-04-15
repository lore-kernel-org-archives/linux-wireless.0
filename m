Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59639 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbYDOLDz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 07:03:55 -0400
Subject: Re: Does mac80211 support ap mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: cao jing <caojing.china@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1208202280.12139.23.camel@localhost.localdomain> (sfid-20080414_204742_445593_54A5FE8E)
References: <9f33c5230804141218j5778195ajc1a7bae011eb9528@mail.gmail.com>
	 <1208202280.12139.23.camel@localhost.localdomain>
	 (sfid-20080414_204742_445593_54A5FE8E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-u2SbDY2TO/RD/aLEpu80"
Date: Tue, 15 Apr 2008 13:03:47 +0200
Message-Id: <1208257427.3502.28.camel@johannes.berg> (sfid-20080415_120358_281281_BF77409A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-u2SbDY2TO/RD/aLEpu80
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I read the mac80211 code. I found only the STA, IBSS and Mesh_Point
> > interface type are processed by the code. So does it support the ap
> > mode.
>=20
> Yes, it does.  I'd suggest using hostapd as your AP daemon and the
> nl80211 hostap driver.  While it's still under pretty heavy development,
> it all should be fairly usable.  Johannes Berg would probably have a
> more up-to-date description of the status of the hostapd nl80211 driver
> and mac80211 AP-mode support.

As for drivers, b43 is known to work (I test this), rt2500pci seems to
have some trouble (Bas Hulsken was trying it) and I don't know about any
others.

johannes

--=-u2SbDY2TO/RD/aLEpu80
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASASLkqVg1VMiehFYAQKgvQ//dLCdJttu6qTrLKMQbt1XpRhYnoVWTDjt
yc0Xn+OZ2rrKYim2JzwgFHKUE4A0SpbgN7v7BwwytSd90qEpzIfXCdg3IpbVHkq5
XcGRMseJ4cKaKrOTAGkswMWgOedQ5418YNGSbJZRgNutEmGMDqe5FF8hxebro/qN
ICl4dMekXKUK7hfOG89inseZKUV73+NXdsPUuWq0rcXvvA3mS7sGrvX8Us3UnMex
s5wIBPKp/osT1Jb4vjuFbDr9CMtQg70kgfEfJ/OLeNfZ+YSsa+rl1YtajVfLHi3E
KRamD4IycXkqTiM5QzfbBs4WNeF6KEPU8C5FRu94eGdJ78ApZc2eEzK9pI9P3nuy
Mj9XpxMF1E5/yul/76szroDUduk78DqR/T7Ngu5Ia61QdLxfslgkTTBcIQV166w0
WmAxBH4aCoaXE7/RfNzapEA6GYmPxpAYBSFJ7O7YkBslvvLg8FMhc21XLZ7hXhAK
X5wDI8v7UT7+tkkSdWMI57y7msub7IeZfEXWgBv9/6reXChtTkok6blctu0Mphqz
XTrKKNZqmyifPxCNteMH64QNC7TA96a6dXPbKg8DoQhYbOSw+Ex6kdKwVWO/ihmf
C9XYfWtgs2gYxoQkpYqOxK3LRuq5/08wPuqUnYgHTNdSY1BJMckz30c92p5yNNBj
kPRvKDDkp3A=
=MYj5
-----END PGP SIGNATURE-----

--=-u2SbDY2TO/RD/aLEpu80--

