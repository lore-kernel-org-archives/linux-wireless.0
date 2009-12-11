Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbZLKLxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 06:53:33 -0500
Subject: Re: [PATCH 21/31] wl1271: prevent power save entry while not
 associated
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
In-Reply-To: <1260531682-4695-22-git-send-email-luciano.coelho@nokia.com>
References: <1260531682-4695-1-git-send-email-luciano.coelho@nokia.com>
	 <1260531682-4695-22-git-send-email-luciano.coelho@nokia.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-MdON8mvAi6CAPjVkYJKw"
Date: Fri, 11 Dec 2009 12:53:38 +0100
Message-ID: <1260532418.2442.129.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MdON8mvAi6CAPjVkYJKw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-12-11 at 13:41 +0200, Luciano Coelho wrote:
> From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>=20
> The mac80211 sometimes requests power save entry while not associated - t=
his
> will cause problems, so prevent it if not associated. Go to powersave onc=
e
> association is complete.

Does it? It's not supposed to, and I imagine that causing trouble with
other drivers too. Do you know how that happens?

johannes

--=-MdON8mvAi6CAPjVkYJKw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLIjK+AAoJEODzc/N7+QmaxtMP/0oWJnBvu5+M0OeEIrMnsXgO
VNjgim7Dd0xiiJwgJbjX6/9h/LtRqY9ewsRkIsTnW43PMGmpVP8SYHTPmdEpiTqa
QzIn5IAAc1jV93gnhCnCgoCh1yu6D2d7wX5Cu3jTKuALIWxKuKDI0JqDq6KeaTHH
KUOESiTkfZbl5ZoJuf07Q1vDRzRaC/gvTafJVYgpprBAJfZrwZbJnu1XzO5hJXkW
Jd4Ovr9ZNVhpn+jn9/HCHcUhA7Mx/JkcZWBSa5dY63tZuSntKYHeWRehmCBZTRqu
RxbURhjEo7jc0DEue83k0ows5P4yzgnwUxPrkfbB/xU1+p3D2P1Se53VTF60Kir1
FpIHwW11MJ/oXWS1IpaH3Q/ACf4l95F3NWB7imejaVcQIJw65UvszLJ5UEGFeNGq
l2HKIhxhokOpkwvZopL2Ky2ZFEvpYRQWA0RgooxFTm3YVoWncOpLZhkyXuLeQF99
BrHShFyMzw6Z7hvcTXVLD9xgc2nPo9sEqTohz/GFKQFczqVKOw5YEoYyX/WCTncR
08rDpSag9rwXQoCEZEo2mMOQzJd31Ubwi91tTWVmkPdTaSRGwYtIQ4muEQ8o7U7O
MRNASZXvBNiBm9tr5oySn1c8qD1tS6ChBCwy7uINp0DDQCWXtqvsXqNZlBIe1FS+
vUweVPBJljedXa376C4j
=G2Ov
-----END PGP SIGNATURE-----

--=-MdON8mvAi6CAPjVkYJKw--

