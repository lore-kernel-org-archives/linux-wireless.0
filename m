Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58123 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbYLMAFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 19:05:32 -0500
Subject: Re: Userspace tools: Roadmap?
From: Johannes Berg <johannes@sipsolutions.net>
To: pat-lkml <pat-lkml@erley.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4942F867.5020203@erley.org>
References: <1228692546.8826.1288759933@webmail.messagingengine.com>
	 (sfid-20081208_002919_244971_30E436F9) <1228723993.22164.65.camel@johannes.berg>
	 <1228778295.10662.1288975589@webmail.messagingengine.com>
	 <1228778801.22164.156.camel@johannes.berg>  <493DB351.6000103@erley.org>
	 <1228780960.22164.162.camel@johannes.berg>  <4941EF69.5040108@erley.org>
	 <1229099080.14423.15.camel@dv> <1229119118.3572.6.camel@johannes.berg>
	 <4942E7A4.3050206@erley.org> <1229121535.3565.4.camel@johannes.berg>
	 <4942F867.5020203@erley.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eU/9CuISkx99iwO4c9B7"
Date: Sat, 13 Dec 2008 01:05:25 +0100
Message-Id: <1229126725.3565.30.camel@johannes.berg> (sfid-20081213_010541_346842_A0AE7048)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eU/9CuISkx99iwO4c9B7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 18:48 -0500, pat-lkml wrote:
> This converts iw to use libnl-2, and adds compatibility with libnl-1.
> There is not currently a good way to detect the libnl version during
> compilation, as the versioning in the netlink/version.h is defined as
> a
> string "2.0" rather than a major and a minor number, so we must detect
> it in the Makefile.
>=20
> Signed-off-by: Pat Erley <pat-lkml@erley.org>

Ok, I've committed a slightly different version of this (corrected the
type, and made the compat code static inlines), can you verify it still
works against 2.0?

johannes

--=-eU/9CuISkx99iwO4c9B7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQvxCAAoJEKVg1VMiehFYoLoP/j2XbJKgu7H6zxV+zJa5BeKL
ci6KAuFlCe+v6DcbRRq9GkiK1ro2RrrHPVv2bM9OoJRRZ+e1ixAZa5A4uxWIMufM
+sCJJ647/8eidWA4qHhCdfBVID9hftLg8ugjuuKEg1f4yS6jgnGupOPkLq4p0Mdi
lMWo/5XBpMafZ41Irz5d4Zy6oK/V2X1H7gq7+Hi143QZ3vQKMXY6EXXdyZ5tJG6g
m8Vfv+ztV/fSzYuEWSnJu9gaB0m5a0EWbc5/MiTD5uJH+5F8dvG17uwSYazBKCN2
rQRGKUQg83g/As0Rx3SqYvg6W5fZyaYoJ6H1OH/VjFN/3epMFCklCXuVvcyYrgAE
VgA2u6DgTViEk742XgpFvp6CX/uqeZQtKsdJfoSnzwH2zbOaYJD2SI8UA0jYYfMB
NhHzp1hQpOMJiMqbY1eR+Ctkaw3IEFoTHtKE0+5z3TkDX0OYp+RnLGjMWnXyIUdq
hwUxToqJoGhovZ65rouL2ajzSVJEjMAlJOb1d5D3l+6f/IhCw4vzVZ/qBsxYj3Fo
1JzjZZGFNbzrj1vodHLI2yrmymKMf7GdXr6NwBExSKQwYlanAVJyfABAbb9+XiaA
TZTDKH/IkqD6D39yDBiV7l05FiQ/IFt6GAPCfCAGS7E4/Sa95/tpul5Qx0D5HmYf
C5/pzKyvWjRqNjzgZyYv
=kaDt
-----END PGP SIGNATURE-----

--=-eU/9CuISkx99iwO4c9B7--

