Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51109 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab0BVSmc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2010 13:42:32 -0500
Subject: Re: [PATCH 06/22] wl1271: Divided driver to two separate modules
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
In-Reply-To: <43e72e891002221005q4840593bs8b937d6d82b44b3c@mail.gmail.com>
References: <1266820722-20202-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1266820722-20202-7-git-send-email-juuso.oikarinen@nokia.com>
	 <43e72e891002221005q4840593bs8b937d6d82b44b3c@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7v+5upnGVhHrtcSQfP+f"
Date: Mon, 22 Feb 2010 19:42:30 +0100
Message-ID: <1266864150.507.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7v+5upnGVhHrtcSQfP+f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-22 at 10:05 -0800, Luis R. Rodriguez wrote:
> On Sun, Feb 21, 2010 at 10:38 PM, Juuso Oikarinen
> <juuso.oikarinen@nokia.com> wrote:
> > From: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
> >
> > Divided wl1271 driver to wl1271 "core" and wl1271_spi modules in
> preparation
> > of integration of the SDIO implementation.
> >
> > Signed-off-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
> > Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
> > Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
>=20
> Which one is it, Reviewed or SOB? If both then just use SOB.

I disagree. I think we should allow for people just sending on patches
(say as part of a company hierarchy) w/o giving them the careful review
the reviewed-by tag should imply.

johannes

--=-7v+5upnGVhHrtcSQfP+f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLgtATAAoJEODzc/N7+QmapzsP/iRJizZ4qioPy++PqGAYNlw5
eNk8JpkCJ3O0GZS4AXsuaIzF0uXWNJvENEEqHHHeO02KjXvA5x7bZzaqWtpKWtsN
06gNvAcg9bETE8pdGX7ipC/0pBdSKxL7vhTLq7UxPaHNUPPwWkjXMiY9rYh5nfDy
EChDb2Bu9Ee/nMTvRQ9cZb8XVnmZ6T1P8+m/ufyybQ9pz+QmCVFUxY8IHWtI4A0W
nmnVHZa6qheCjLUpA0C2Fs7roAltrN3IrdFn+fMrQUe9iabJn9PUip80+kncE8ZG
4AI6YwWbYdhr7W6hnMkrbKkKOqKFl/dL7dztOb4pNGwAc4Kf8QbLOHwEkKSsB5iF
Z/P8KUG/zakGd8GrQXUBVlndC2JZM36NZn38yBHw2cm5uYpF+iILpukMyzWxfnS4
SFI7MUQ3Q+kp7ip3IM48sVR6Nje4TJRDK6aWXzpga2aP/h1mXJcRcv+nXH0Xesoq
n1dP7QyT04hjQEphnlAQhIZt76nLI7+CNv24e5+ehm5Rg5NsONs1lNwVyzcRKHGK
xM4D7IXUq+iX5lRphvwfNhVMetD0tc8TXU7S1tNcUUffAxKATMSvga1TZWg/Pqzb
aR0CTcNvYf/OQEiztspicOuSq0Oso1S6bAKlKrod/8bNkZpA3rFbgnV+a46aPTmw
8vUOWo+nmPGGLgFn53HC
=Tddt
-----END PGP SIGNATURE-----

--=-7v+5upnGVhHrtcSQfP+f--

