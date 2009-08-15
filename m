Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54829 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057AbZHOMPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2009 08:15:25 -0400
Subject: Re: [PATCH v4 32/34] wireless: make mac80211 select cfg80211
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net
In-Reply-To: <69e28c910908150512o68c51875j2dc644e9c5ce3359@mail.gmail.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
	 <1250281559-13041-33-git-send-email-lrodriguez@atheros.com>
	 <1250283993.4411.1.camel@johannes.local>
	 <69e28c910908150512o68c51875j2dc644e9c5ce3359@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DXOZtm+vs9/qMwHbmduN"
Date: Sat, 15 Aug 2009 14:15:17 +0200
Message-Id: <1250338517.15069.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DXOZtm+vs9/qMwHbmduN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[please trim your quotes]

On Sat, 2009-08-15 at 14:12 +0200, G=C3=A1bor Stefanik wrote:

> > NAK this change, because with it, it's possible to select
> > mac80211 =3D Y
> > -> cfg80211 =3D Y
> > while rfkill =3D M

> Why not make cfg80211 select rfkill?

Because it doesn't require it. See net/wireless/Kconfig.

johannes

--=-DXOZtm+vs9/qMwHbmduN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKhqbSAAoJEODzc/N7+QmaKDAQAJJclUss8DNnix8ktoweLsdR
RpTBmUN7geN7TYvJYMtRPN0NeZfxWiOpKwEI+p5T7I8DEJceQxD3qaTJK1JXBzfQ
SNetTMhp8r78pK1NtSPQ4jDe7daZY/HRZnBQBOcKaFceRUzzSXvaWJrC3sPGsWE1
y5TUJ4z5HSf4IHh6eOF3jh0RjF0cITnu6BpGGm2Y3QqZ5SGvu5MU4UdYEr1F5D/0
nD1RPBmeGzayx9yHzzToQRmJq2Dsd8Nb/mdM4bgp2t+Yz0TJecRlFZJj67u1ItIH
+KR+gsmRJP/gEErEsjOoRbx/pbTGWdSPcAXe77/w/Bn56/oOrgkAVyJeLuC8SjV4
UAgUasUyuMvWLZVyQoJxrH2n4wHBoChRQfg9KkklCcb7lohaQep7KEvyfOAWJsWe
6hS6F/SgDbBCe9P05//DZBVixQmwsjGcwcK+wrSOKGdwoHo5BaHE2OGk0p2gDj7/
yq9IJp3C4ZsBZyVcSR/tSyQIKTxNpM0ztLSZOXuSQiGVaZ/eiO3wKAq3GNrTz+wq
ElHWcerPrQC8lW4SIvOk8wkt5o6QBUiCktsLi7v4FL/L9U9KdmlHZ+s674bKZZYJ
tThsZ3X60+DwA0sPvv6MMEEzD0z0rNwU+7zJdPiJ8fCOPUfAyFMXHNsYjSG9nGgk
Iw/cTaTIGCi64cXZoK2z
=LtiO
-----END PGP SIGNATURE-----

--=-DXOZtm+vs9/qMwHbmduN--

