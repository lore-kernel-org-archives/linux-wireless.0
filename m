Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51042 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYF1Lmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 07:42:36 -0400
Subject: Re: Missing channels on iwl3945 shipped with 2.6.26-rc8
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: janconrads@gmx.de, linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910806280419r40eb037cv858f89b8f2638ef2@mail.gmail.com> (sfid-20080628_131925_704712_0A661CD6)
References: <4865B3C6.1030007@gmx.de>
	 <1214640029.5507.10.camel@johannes.berg>
	 <69e28c910806280419r40eb037cv858f89b8f2638ef2@mail.gmail.com>
	 (sfid-20080628_131925_704712_0A661CD6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bKz08QXlRYRakt81dsOJ"
Date: Sat, 28 Jun 2008 13:42:21 +0200
Message-Id: <1214653341.5507.16.camel@johannes.berg> (sfid-20080628_134303_073899_D53F40F9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bKz08QXlRYRakt81dsOJ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-06-28 at 13:19 +0200, Stefanik G=C3=A1bor wrote:
> On Sat, Jun 28, 2008 at 10:00 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >> vermagic:       2.6.26-rc8-jan SMP mod_unload modversions CORE2
> >> parm:           ieee80211_regdom:IEEE 802.11 regulatory domain code (c=
harp)
> >>
> >> I read, that 64 should be ok, but if I set any option only the 2.4GHz
> >> Band is listed. For germany 276 is a common valve on atheros cards, bu=
t
> >> this doesn not work, too.
> >
> > As you can see, it's a charp, i.e. a string. Try setting "EU".
> >
> > johannes
> >
>=20
> Does 2.6.26-rc8 (not 2.6.26-rc8-wl) have "EU", or only "US" and "JP"?
> AFAIK it only has "JP" besides "US", though I may be wrong.

We pushed that, if it's not in -rc8 it should be in -rc9.

johannes

--=-bKz08QXlRYRakt81dsOJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIZiOaAAoJEKVg1VMiehFYesoQALxg3tj5yUG/mWo0gSroO6dL
jvEPac/nbQGOh6vklB6KHgcwxKAVme5BBE7OYsh993Zw1w3ReuK2HY4itA55bHMa
wULZXvz+1Ezr7jR0Rf9lSCNL72qdSxUvrHiY+uZwcUn5CzoJX0VLhX4Vnb/taDTl
I2qPfw0pOzOcEU+BSKdqttoVgkdCKBDFGT0BY0her4bgyKePf7musRMetjPb/Kab
1WyxvRxXMsrDRJjpUoOuUco6TTRQnvWn8zhWFAC6JpYT4aO2GGINjHDON1yVtxzI
8ZHaZiS+7oVLvbPItvjtgXasGtVtAZy5lTdKWMk1mw+ettLrx/dy4rkV3N+0649O
rVih64QDYcfrhnyjhZn74KpJefdEwJoF0iEWCS7Omc8pN5RXo9ecETFKzOSWt94x
TqxYbjS4/QWE2Evv2losxVCEjNMWr243S1uo/bliG7MVkeXC+PhRKZUDVWpQLgzL
Yh+D5YJ/YYxZdUjfvD0vJuUFYntXdMyvccXRXMA/QDf1Mg97jO5O1/zn6XbGgz82
JdQyrEjIXzzjS8fDkyHSth3/RCtD0HF1UAG0Q9eCruR1DkOS4TIkriBE3WEbpnYt
IK4Obr4bDUp/A2ArigrDS3GzF6frA4QGfjPaujN1GV7tPMf7aTiTTWN6igWLJqK3
5vm+p3JTQBAh0zztLneg
=36DN
-----END PGP SIGNATURE-----

--=-bKz08QXlRYRakt81dsOJ--

