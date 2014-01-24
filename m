Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ring0.de ([91.143.88.219]:34720 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674AbaAXVxi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 16:53:38 -0500
Date: Fri, 24 Jan 2014 22:53:22 +0100
From: Sebastian Reichel <sre@ring0.de>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Tony Lindgren <tony@atomide.com>, linux-wireless@vger.kernel.org,
	linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 0/5] wl1251 device tree support
Message-ID: <20140124215321.GA25727@earth.universe> (sfid-20140124_225343_432410_CCF260D5)
References: <1382890469-25286-1-git-send-email-sre@debian.org>
 <1386289336-26704-1-git-send-email-sre@debian.org>
 <20140106225709.GA23070@earth.universe>
 <20140117014514.GA604@earth.universe>
 <20140117150127.GA15145@tuxdriver.com>
 <20140117174415.GG7993@atomide.com>
 <20140117192204.GB15145@tuxdriver.com>
 <20140118174705.GE7235@atomide.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
In-Reply-To: <20140118174705.GE7235@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 18, 2014 at 09:47:06AM -0800, Tony Lindgren wrote:
> [...]
>=20
> The reason was for keeping things building and git bisect working.
>=20
> I do have wl1251-pdata-signed as the base for branch
> omap-for-v3.14/omap3-board-removal. However the board removal was
> considered too early for v3.14, so that's been postponed. This is
> because people are still updating their systems to device tree
> based booting. So I can redo my omap-for-v3.14/omap3-board-removal
> against v3.14.
>=20
> So if you want to, feel free to pick all the wl12xx patches to your
> wireless tree. AFAIK my omap-for-v3.14/omap3-board-removal is the
> only other user for those patches, and that I can redo that on
> v3.14.
>=20
> So for the arch/arm/*omap* touching patches, feel free to add:
>=20
> Acked-by: Tony Lindgren <tony@atomide.com>

Another ping. If this does not go into 3.14 via wireless tree
it will become complicated for 3.15 again.

-- Sebastian

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJS4uDRAAoJENju1/PIO/qaAOkP/AnKO//56D5poxvhpsDbnG1/
kQz24cexjIPlWeeWHlFQaiU7gTl5ftqhhtR0xBES6CbPfQKD3zFMqN3I6llN66eA
SaNVP6/l/AN6PTvMKxrf2EYzRw/tD/axGKyl2DfTylcZlXjVaW0kErbtLAts/ghl
fHbAT4R3B2OoHOlzlFDrm/0rw7/uVSoiXFcIZwmwxTItQXJrOMwL/OmpoOdbmoqE
Q+uXEl6qroM2lH+JjAhIoj04z66R9bWawBr18Xb36jNhRFHwhEz3WZx+feqoM9JI
bdNyl35iUDba/hgDxoTLsa9NXPeWQd7j6ONbcCYypOF748ix9AW8Du8hefdEY5ab
Pa0eVfa7191+SulBFAwhddNeXzlHy+KiBi9CTqSDGOO7/K3Wh3ISBHl8ZdlUvt+o
k4w8lcF//K8D9IG1k1dk1+0OFrCfcOOPLYXznTbt1zPkLr2sxci7K4Rt48jBahyF
q9A93IQEJ/GUlp//HSybLUGG5Pkz3SU7qHvRc+MdsWBSvqIvWndAzDgRmA4kSS2d
pJju2qTMavqNcxxOjksR6hQ3U7j2HJ1V867UeM60TmvnDiHODPlJb9z5zr3MvGEK
vObVFoWEK+sRrZV2CjeeN8rmL3fsW9d5ODKfc/vnTlZAWTrwsyzC291sK7YoJh/b
9FhEweMck6Ia3so0s7th
=4YoO
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
