Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s1.neomailbox.net ([5.148.176.57]:29098 "EHLO s1.neomailbox.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbbFZL6f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 07:58:35 -0400
Message-ID: <558D3729.8080400@meshcoding.com> (sfid-20150626_135855_304895_DDC38968)
Date: Fri, 26 Jun 2015 13:27:37 +0200
From: Antonio Quartulli <antonio@meshcoding.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	Joerg <pommnitz@yahoo.com>, linux-wireless@vger.kernel.org
Subject: Re: iw and non-ASCII SSIDs
References: <loom.20150625T181029-814@post.gmane.org>	  (sfid-20150625_181310_521075_380CF492) <1435255854.2096.18.camel@sipsolutions.net>	 <loom.20150625T224327-49@post.gmane.org>	 (sfid-20150625_225037_608129_0D468D05) <1435308646.2106.4.camel@sipsolutions.net>
In-Reply-To: <1435308646.2106.4.camel@sipsolutions.net>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="2pTbg9lmJbjbXlXA0GfJmIeUfFXKjAP7X"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--2pTbg9lmJbjbXlXA0GfJmIeUfFXKjAP7X
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On 26/06/15 10:50, Johannes Berg wrote:
>=20
> OTOH, what choice do we really have - the only other option would be to=

> add a command line flag indicating that this behaviour is desired?

Why not just using wpa_supplicant with key_mgmt=3DNONE ? It can handle th=
e
case where no encryption is required.

=46rom your previous email I understood that it already supports hex
SSIDs, therefore this should probably work, I guess. Has somebody tried
this ?

This way there is no need to break/extend any other tool.

Cheers,


--=20
Antonio Quartulli


--2pTbg9lmJbjbXlXA0GfJmIeUfFXKjAP7X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJVjTcsAAoJEOb/4TMchkvfb3QQAJnLfXAx3F8IV1fNW/Zyui5B
oJACrVx6jX1NiFYoscEJGW4iY7LP9UuZl8afvc3OpYCzjfF3JmXQYtoz1RDJhK8y
cDhfKzsfxbolO80l7/6f95Jp7+jCXPRQY2j0fcaPlL1skYno6fq8efT47FLjkjzw
kGmkudJRfkXy1h2WELLsMfXnwyXrN8sTnm3W6YNzFlvRLAlyF5xHC3qQbgUhM1GP
EjSotehyYKuR/43H1iYa0Jw6XCurlhMenhruN5t1q6t/407AzNanphTf1ktcZoc8
qQlyjPm/Jz98/jD96v86nC/WnLAtUol6U1doCTBNJStceGGAQjyhH/rmMDc06lN6
YSHKZp9f3sm1eh3cCULgIaSg92vmhFWLqmCou1ZbpphMVL0gL6CbHexit7cLEZuC
UNFjRS+yi8Kiji+W8ZI4Oej/O2xoMl96sgxXETwLJJnsBPF5JMeO6Vjd3msD8l5w
qzgPXQYB9g07Iw2kzoFT3K+Ly8GGtxpKiiZh3RjzeQ+fL7qIK9/2GeBvhbqHp1/e
LD/9LmP+ZomMgO3Srb5NE+hDLoW+TFPaazYsHYJcOF+E8r29zHgocmfsVw31v5hs
vfSy8lxnfMkZ0183/PTlnMC81L3IAoohmMOK6UJc0HEm6xCX1HZCKDyT2QiR4E/Z
CwCokhniMyuO9NnIIViU
=6uQ+
-----END PGP SIGNATURE-----

--2pTbg9lmJbjbXlXA0GfJmIeUfFXKjAP7X--
