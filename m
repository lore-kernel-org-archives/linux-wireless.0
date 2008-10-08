Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39415 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbYJHJVJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 05:21:09 -0400
Subject: Re: [PATCH ] mac80211: use HWSIM_STA_MAGIC in
	hwsim_check_sta_magic() and hwsim_set_sta_magic().
From: Johannes Berg <johannes@sipsolutions.net>
To: Rami Rosen <ramirose@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <eb3ff54b0810080218j4b335ccfy74b6df5e8c7cbba0@mail.gmail.com> (sfid-20081008_111831_792788_52712AE1)
References: <eb3ff54b0810080218j4b335ccfy74b6df5e8c7cbba0@mail.gmail.com>
	 (sfid-20081008_111831_792788_52712AE1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LBlwC+cEEVF1XYKNX8JI"
Date: Wed, 08 Oct 2008 11:21:08 +0200
Message-Id: <1223457668.3618.47.camel@johannes.berg> (sfid-20081008_112113_400316_7A546235)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-LBlwC+cEEVF1XYKNX8JI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-08 at 11:18 +0200, Rami Rosen wrote:
> This patch (wireless-next-2.6) fixes a typo in mac80211_hwsim.c:
> use HWSIM_STA_MAGIC in hwsim_check_sta_magic() and hwsim_set_sta_magic()
> instead of HWSIM_VIF_MAGIC.
>=20
>=20
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Indeed, thanks.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

--=-LBlwC+cEEVF1XYKNX8JI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7HuBAAoJEKVg1VMiehFY+XEQAMJlmilrncdEHAF76jlmm01p
9iwcLpYixtg6l1X6sDYj+aKr3QIlhDHsCDBj0Y0FSRFuw6XMMKhpr/bo3PCNoJn7
/AliBZGxKGhYpOr6C6O5EVNSWk2p8LCzj7vdSg4c6VsROavO6ygW7ssidoe6W9j0
iq42Fj1fWroaciZbOx8XEBVtQ1d4jA1wDdvvAi5pmIWI74LM8NjfhRIHssF8UKQq
KRhuke8/MtSxb0oGqm9YgAkDACRzGisTnwP/TX+eWmgRseN1ZZ8/4qJHDm1GSA9a
Rd9ud9JeD0efdGjaon7hTQeZfJVLfMunqiDeFkIsqAzvfociQ57tNBYYXZa0KHO7
0th1GSP8z7tYfBdg0e7kkEMlEDGnxRXR1q3TF6TE8ZMKp8yry212zuFmvCQ9abc+
hheVbo+4b3gh3rSo/V/RPPrd0JImDsxKswEuAEeY1eB8p02vXCBN8IU2t56K1lnX
ny5ePS/hmkHJZKqb/cGAsrvPIoOAbOYhPnTAg5np9oHwVzv8BSfITgYqbzqq2AtL
omp7uZggST+y/Y2vXYCIb+DfYWKuf3HmVcTujZS++8NAJG5z72039VMCFSDEN8VS
mSGLTtJLi7sw4OVH8qbmlkPrmE2DpniycsVfUZCbAk4TDwY7MYU88GzUuyZyNMHr
ZOZP5Y6nX28wPSMlVrPS
=ZWIR
-----END PGP SIGNATURE-----

--=-LBlwC+cEEVF1XYKNX8JI--

