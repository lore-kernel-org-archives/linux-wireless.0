Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42858 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbYKZLVr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 06:21:47 -0500
Subject: Re: AP (Master Mode) of wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Koutny <vlado@work.ksp.sk>
Cc: Pavel Roskin <proski@gnu.org>, Mark Ryden <markryde@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <492D0A26.9090801@work.ksp.sk> (sfid-20081126_100034_138731_1E1B1C2B)
References: <dac45060811250735m6922688fn13c03ebe388d3137@mail.gmail.com>
	 <1227633414.15224.6.camel@dv>  <492D0A26.9090801@work.ksp.sk>
	 (sfid-20081126_100034_138731_1E1B1C2B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-04YS7z1Hmx4D7yFFrCHh"
Date: Wed, 26 Nov 2008 11:03:13 +0100
Message-Id: <1227693793.4613.57.camel@johannes.berg> (sfid-20081126_122150_747580_A1659B1B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-04YS7z1Hmx4D7yFFrCHh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-26 at 09:34 +0100, Vladimir Koutny wrote:
> >> More specifically, I am particularly interested to know whether Intel
> >> iwl3945 and Intel iwl4965 support AP (Master Mode), and in case they
> >> do not (as I am afraid is the situation)
> >> - is there any intention to add AP (masted mode) support to these driv=
ers
> >> in the near future ?
> >=20
> > The driver announces AP mode support (look for NL80211_IFTYPE_AP and
> > hw->wiphy->interface_modes in iwl-core.c and iwl3945-base.c), so it
> > might work, or at least the intention is to make it work.  By the way,
> > rt2x00 announces AP mode support too (in some conditions).
>=20
> I've tested AP mode on iwl4965 about 2 weeks ago and a very quick test di=
d
> work (no encryption, just connected a win notebook to it and did some
> browsing). Just be sure to fetch correct (=3Drecent) versions of hostapd =
and
> libnl..

I don't think it'll do mcast buffering correctly.

johannes

--=-04YS7z1Hmx4D7yFFrCHh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJLR7dAAoJEKVg1VMiehFYT9wP/3UN7CfzskpBai1n47MhTKoW
bBzSOTdQXii0EtzaE4QaGB3IYe+C9qdC46l8tE7b/7lt2n8PrlVKuzybyhqzygQb
DuegvqSoEDgissDmziX/9/ZLjaCJPEQ0Ui3N4p0BVTaW4BMclWOnevxuSIJ7mAb0
tp1ykgEO/JJb16gN+KqkZN7gEfoNUP2j534iIP+oaHgVd0JCFESWtiOUIa47WClk
xnl8hsCmIE5Nqbi6vjTQyjaMFo8hd0M9xCsdPVzR1PWFzntsRLgCmVuD7MY07cg4
JjkR516mod/ylsR5RI4r3iK8vNplyfJNEMUtlOdSTAqgqyeK/Oqio9aue8knunRt
SJf+ZCz2rwufgTodZuTvmvAYDosCzLPOPlAOknbTGcAwEN+OBFtYUmZSFwJ6AJXb
HklD4hf3UsT4Kj8663nv25wmtKbt9b1WTl3dt5XYpR1eUO1xuDZ0l8yNu1KOxToQ
g7CO8Wm3bOLl3U3VQqtAaUGNiJEam8u+OGuSHNwXvOGu76udcZpY0aJxixAHJ7KU
ea+iWNB7DVYsyJFNIWxa7CRUjMFapuGahqRV7knBJO6ViOGSnIdYAtjDpmwk8Cj7
f4INIijYDZEb7AYy3wz0udgxqJlg6pFtLxgSnZZg101gUePHtMMmkmalJmwXfil4
9jpvL2txLPGTAz+H2y4u
=u0wo
-----END PGP SIGNATURE-----

--=-04YS7z1Hmx4D7yFFrCHh--

