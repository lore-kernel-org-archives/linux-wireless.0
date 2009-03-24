Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34644 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZCXHlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 03:41:06 -0400
Subject: Re: [PATCH 5/5] ar9170: update Makefile, Kconfig and MAINTAINERS
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <200903240126.12692.chunkeey@web.de>
References: <200903212311.49348.chunkeey@web.de>
	 <1237818551.6147.15.camel@johannes.local>
	 <200903240126.12692.chunkeey@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6cVclrpUf8Rj+C5B1MTV"
Date: Tue, 24 Mar 2009 08:41:01 +0100
Message-Id: <1237880461.6147.24.camel@johannes.local> (sfid-20090324_084109_905816_3780C05B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6cVclrpUf8Rj+C5B1MTV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-24 at 01:26 +0100, Christian Lamparter wrote:

> Shh, there's a secret plan, see ar9170/main.c
>=20
> /*
>  * BIG FAT TODO:
>  *
>  * By the looks of things: these devices share a lot of things like
>  * EEPROM layout/design and PHY code with other Atheros WIFI products.
>  * So this driver/library will eventually become ath9k code... or vice ve=
rsa ;-)
>  */
>=20
> And the ath5k<->ath9k merge could provide some "helper" function for this
> driver as well... (wishful thinking, but anyway...)

_Very_ wishful thinking -- only very small parts of the design are
really shared, the PHY stuff, which happens to be relevant to the
eeprom.

> Meanwhile, what about a config option that can be enabled to
> integrate everything into the front-end module (ar9170usb)?
> ( However, I don't think this config solution will stand a chance ;-)=20
>   and we all come to the same "all-in-one works best" conclusion.  )

This seems like a pointless option. Why not just change the Kconfig file
to remove the common option and link both files into one binary,
removing all EXPORT_SYMBOLs?

johannes

--=-6cVclrpUf8Rj+C5B1MTV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyI6LAAoJEKVg1VMiehFYf/8P/0lHVSGB9+QwXHvcRXtXm5Mt
V9kb208zMurgbFOpv7UcbifZLpqlZmk0C5sC6J7dbILSjLVJnWy8O1eAQ9bUN8Ns
DJJw8cUwJQSZG1X7qweb6RXOdbj33CfMS2tQauvK9tK820Br5gY99XvIKsrzxmTE
XIg4MYvRHrD4PX2SWX2n0GE2pKh6zpFia4iQSyUnAblcDpbiWcgxq37/EV0tlLsU
TYgb2QQff82xSNEngwEeD/sWoMDEzzWRTJAjMjQH7R9AlN0rXBsDlUJzji9lQHcB
ZZTMN2wp4yC5hBuml2OvJaGQP/Hd6rnCZ10R+urcPXl08bY/fJOuKN5yiL5vCZGc
QxwIRWXMgtWhYovzuyh8L8aJlb+HalGY6iRTZ8wL7MCaPDe+P+QFpu7Vumv1kYll
VdAf5zcS24JihGOaKUIVviv+SkfpK0TvThqn5aHtJB7AyAPYKGGnZGc6hFxGdkwU
dlpvILzOxCAQMcszLpxDiNL6E0jDgKlMIbOUJwPOxdD4FfM1aNXe2BnfZYDFg3ww
VoSU/k6oGXb3oTBTzyq9skKEWH96TSF8aDc368vXsexp+3+9D44aDugvDc6lxvJk
s68N/pQSu4bGsTtdc2Lp4KwZqZ9WZCr7IiiAA9g4AQ5ADDMldBPU2eWlUmDdHjMO
F1+SM7YPcPgX64bIqjEV
=8w9/
-----END PGP SIGNATURE-----

--=-6cVclrpUf8Rj+C5B1MTV--

