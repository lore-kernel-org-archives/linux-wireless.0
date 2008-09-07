Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51467 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194AbYIGMkZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 08:40:25 -0400
Subject: Re: [PATCH] Ath9k: Add RF kill support.
From: Johannes Berg <johannes@sipsolutions.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
In-Reply-To: <20080907115619.GA15895@khazad-dum.debian.net>
References: <20080906123842.GA27504@vasanth-lnx.users.atheros.com>
	 <1220721347.6714.114.camel@californication>
	 <1220721572.10102.0.camel@johannes.berg>
	 <1220721788.10102.3.camel@johannes.berg>
	 <1220749216.6714.122.camel@californication>
	 <1220771824.31304.2.camel@johannes.berg>
	 <20080907115619.GA15895@khazad-dum.debian.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yM28FBjo8pNsxaFHfmlo"
Date: Sun, 07 Sep 2008 14:40:18 +0200
Message-Id: <1220791218.31304.5.camel@johannes.berg> (sfid-20080907_144041_821306_0CC2783F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yM28FBjo8pNsxaFHfmlo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-09-07 at 08:56 -0300, Henrique de Moraes Holschuh wrote:
> On Sun, 07 Sep 2008, Johannes Berg wrote:
> > On the other hand, if rfkill isn't optional but selected, I lose, udev
> > has been so buggy that I've had to disable rfkill to avoid having it go
> > into an endless loop on some rfkill (re-/de-?)registrations.
>=20
> Which udev?  I am working on rfkill now, and I torture the heck out of it
> with re/de/registrations, and it never went berserk on me so far...

Sorry, not udev, hal, specifically hal-input-addon-listener or something
like that, went into a loop selecting a bad FD of the input device that
had just vanished: http://bugs.debian.org/476086

johannes

--=-yM28FBjo8pNsxaFHfmlo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIw8uuAAoJEKVg1VMiehFYSEoQAJf6SgrqtPJk8Q5JBPM/fhRB
8SVnxio1jC0pO66DZiqt64o7O6G8LK5pbE5h6RzyLNfgW2mikO+KjDHMPdBZMMuA
nNksipEuj1t4GnteQGQPepPyZiwKvopvyclsOd3WUAzBfw3GyV3cWbiiI0d4W9g5
y+3kYp661e5xjLhLAlY4FNyd7xc3J+KILB6EU1X/KmiGEdxGQaYLMLpw5nCv7lQ6
AorhgVffSSs6ZSXdjb8mSKJu0TGmLJgyzf0x5hfZJcE7Rp+1VEcSS29///OJ1p9I
L3SM9zciYVFXmj+fjWJDLW5sChJYra01FqGQnkc/nDFKQvQ6Z9RwaRrOxn1XfjlA
8vi4RahIoEw96sdEyhqUFtqCEfIhVKWnN8nklIzgIZ/O9wlDRQ9nl7fUzmrhix76
8F1G/XhviPyXeZso3Koz5WqmeRil+c6taquaAImyITrUIRiDzTrZH6+U0jedG4Up
HFHbvlR9W+2+x50fMTAz1qjuYjogAVOVxi2ElElHHSGdrtfd1iEO6VeN/rz4pdHz
s5l1mhT98VyLkj2+Kn2BiAnoDy2D9wNJrlhkue0CexDAbCT5motOcBsvaqU7iDl8
ElnHB+wFbnYUtOtbm/yrvICQOxm9PRHEcM5RK6jQjxyLJzoKEgSeVlsYx6Vxz70V
a90ChjuCQZc4CdzyNgkM
=wjl8
-----END PGP SIGNATURE-----

--=-yM28FBjo8pNsxaFHfmlo--

