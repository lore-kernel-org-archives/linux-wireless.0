Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52175 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975AbZDRNTu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2009 09:19:50 -0400
Subject: Re: ar9710 resume hangs
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200904181504.14870.chunkeey@web.de>
References: <1240041582.4456.0.camel@johannes.local>
	 <200904181504.14870.chunkeey@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-iBGdGZbqnFteAFXDeq3N"
Date: Sat, 18 Apr 2009 15:19:43 +0200
Message-Id: <1240060783.4755.18.camel@johannes.local> (sfid-20090418_152010_463589_AAE400DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-iBGdGZbqnFteAFXDeq3N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-04-18 at 15:04 +0200, Christian Lamparter wrote:
> On Saturday 18 April 2009 09:59:42 Johannes Berg wrote:
> > because it tries to load firmware before userspace is up :/
>=20
> heh, I have 4 different machines and not a single one does=20
> atleast one suspend & resume cycle properly.


Heh.

> here's a patch that compiles, but may not work at all.

Huh, wouldn't it be simpler to just cache the firmware? Everything else
seems ok as-is.

johannes

--=-iBGdGZbqnFteAFXDeq3N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ6dNsAAoJEKVg1VMiehFYUjcP/17e+Jxcyc7tF/Q0hTKEpWQZ
d6QgoMFEeQOmJtFBF5uTe98YujxqZ02bF8HR14vYizsel3FwR2rSq6niTgWso9MI
e4RaaUagKNCBxwZU5dFQVY593cck+CGM4sLT8ekHrqP7zJCDW+GaAmrpOYvOKPxS
tRVRKhr+CD3FEXTmbrED9R+zeoqFG0eqDMyZEqU7EMOB28OJIhWDQ94aBEmyyq5I
ifSdt7Zbz1W3nNbgmToyYWu1X791jLFAuxj/Ee5lVUhqgcOcSXWkeU8N5IES0Z7y
HZSsI9cgO6tgEhByDBPceIyyYKcQiYmcU+o//2oIPtgHzt7YIUPn1xg+mlTa8U7a
FRRONI15gCTLPcHFyoYvCladScPaczMTkRJoNVam+CRBl6eqi42AVjeAKr7hsAkm
NFb32ojmPmQ4X8LsimV5j/SxBcM27yU7U+DFWw1ilyVrwYeeiQTBADC1w5rYJi6G
1EdH9XzSdD4pkB7MFk1YSDZUWin//aKcQq29oeaPIzNKb2sVouRULYHPhi2xowhO
EcONQg3HrRIjPCEyrdv514R/VEh5Eeh7u/XFK/lKILYvxUGmJF90fc+JvW36WoM5
c7pIOyS/SxXz2mb1UYQApr+cqd4IkA1p1XIZwnxxrh0cm1C419t82acqpnmKYRhI
glcgI4mkJ4l78QNuR6ln
=UU+2
-----END PGP SIGNATURE-----

--=-iBGdGZbqnFteAFXDeq3N--

