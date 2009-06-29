Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbZF2LBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2009 07:01:45 -0400
Subject: Re: [PATCH] p54: re-enable power save feature
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200906280232.45959.chunkeey@web.de>
References: <200906280232.45959.chunkeey@web.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5d/UQAhYVOgtb81Ey1nA"
Date: Mon, 29 Jun 2009 13:01:45 +0200
Message-Id: <1246273306.7775.42.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5d/UQAhYVOgtb81Ey1nA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-06-28 at 02:32 +0200, Christian Lamparter wrote:
> This patch re-enables p54's power save features and adds a workaround
> which temporarily alters the device's power state in order to allow
> ps-polls to be sent and buffered data to be retrieved during psm.
>=20
> Signed-off-by: Christian Lamparter <chunkeey@web.de>
> ---
> Johannes,
>=20
> can you please give this patch a go with your cisco ap?

No, the patch doesn't (currently) apply.

johannes

--=-5d/UQAhYVOgtb81Ey1nA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKSJ8WAAoJEODzc/N7+QmawQMP/3YquNV1oLE40sBEgEZS9Lt6
f9kMiDlkdsABqlthzRs/NHMTjO1FYJUXktANpezp5udTQy5b3vz5HLlM4PEP4MH8
k8deKJiyCKcNcDfaMrfsV9fKPnFCJ3PTmMz6rIm/XpNWGCw4+2eloWVLwDw6zwkg
jp9jhKsTGy7z7YCtRpHtaLg9wCz9XXy2bmtIGFIB/5jL6kQEMl8mSDQk8fYKsSZk
9eWbLfgxpRsKE/yjF9n9IeyKUoXkx7///dPJzYOluiQXTWOdOp839dR4/XWgC+JE
t4x04Gf3kSxu4yL/CoEA755NKdp9NzinL2p/DXlfCnDn89C+nYPtJ6AYqyXOx77M
G0K3uM/WQctmjHwGJ21vngUUwzyGxb4eSPECRCmQ3FKYH/Szqfi/v4s4nXVerBCD
bOrS4HL1HanvDkv6dRlB+U4V6sGPIaMRxTlk++7nwjjZebuRkwVZUAYBestbPEc9
m4T9aHWTZN3z7Uuhmkt/AXXCDh8azfVH4OWOiOhZ86ghXSOJIG456GhEDRHP+be/
RNVRX66U18FlPRb4IIbLiyRuPI97f55jX/lDnad94SOLMBMUYzOfjXoO9jHsWbZ2
LEH8plEUjh79couSeNprjWKMztfNcB3/XQG6WflQCrAbmrlUqq351e9t884uE9MI
jGCDZPEBJufuQ4sCgNIQ
=x5ol
-----END PGP SIGNATURE-----

--=-5d/UQAhYVOgtb81Ey1nA--

