Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54654 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbZKGTTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 14:19:10 -0500
Subject: Re: [PATCH] b43: work around a locking issue in ->set_tim()
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <4AF5B061.60701@openwrt.org>
References: <4AF5B061.60701@openwrt.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+FDoe07DdVJsVbM+ib8+"
Date: Sat, 07 Nov 2009 20:19:07 +0100
Message-ID: <1257621547.29454.45.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+FDoe07DdVJsVbM+ib8+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-07 at 18:37 +0100, Felix Fietkau wrote:
> According to Michael, the real
> fix would be to allow set_tim() to sleep, since b43 is not the only
> driver that needs to sleep in all callbacks.

According to me, that's pretty much impossible... But patches welcome,
of course. :)

johannes

--=-+FDoe07DdVJsVbM+ib8+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK9cgjAAoJEODzc/N7+QmaajMP/0VUDT2Te8pMywE93ZdZUz5M
vAOxCEBklr4blVoCpBYBkzB/2pQaZziazzNYIVMG/cXxq/fpBxE9vyH6DTAcViK8
fBaEg6epdIoP5uKd6X2i6OpZ0+C0C72JFHumudurPFAP4gVFIbOyKEVHEDryWMzB
dhe7cLHdVnT9w7nIQ68xfYMPlCRvTSuzgewTRR94Ip/Nbhisl8hBEi3RexrNkvVl
GL9a1nCXtAiIdct7EdlgrWcEWwbCsvm6cnArZ8JGcvRx+bH5rqmzNfOyUHPvEKKn
zEiELsWchy1RDGsUvdjCVQav4WSh4YrJmaWPsuqlv1XkGB8iilPP4BIqpyarc6pL
bLyWRi1ATaB17yKGti7FxvBNqJjuFyHfZt8iRQDnORcZ9XcksocR/43LTGbestPF
kUL/omDFzS4b1XPz5N1yo+eWYL6w/eP0bL0PQzSP2g5lB35jFJllTnwkRDpC6p6N
SeBvBMpw1hAP5ORApRZTcG0eH+HaLuw4IQpMt0EeM5V5QwJhqE74ec7OiKahA/Go
nXQKBVkErnKbDZ1+D8uT+JJCBUD0ZImwNG1bhTybZdeZfMsrguyUGrKRhcIJaO+Z
jn9vc1PaHiQqUmqodF6aW5k6oHdv60GMaQouYpa3rOa94WByofHq8rAZVLzBsCBx
bMY+/itMMyOf+ETrYBZ7
=zGpk
-----END PGP SIGNATURE-----

--=-+FDoe07DdVJsVbM+ib8+--

