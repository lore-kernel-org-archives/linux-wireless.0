Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:33307 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310Ab0BNVbS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 16:31:18 -0500
Message-ID: <4B786B9A.3050600@hauke-m.de>
Date: Sun, 14 Feb 2010 22:31:06 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: lrodriguez@atheros.com
CC: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Subject: Re: [PATCH 1/3] compat-wireless-stable-2.6.33.y: Activate ssb
References: <1265063133-29682-1-git-send-email-y>
In-Reply-To: <1265063133-29682-1-git-send-email-y>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE83F597B744A6C2F03FB1B23"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE83F597B744A6C2F03FB1B23
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

y@hauke-m.de wrote:
> From: Hauke Mehrtens <hauke@hauke-m.de>
>=20
> This is a backport of compat-wireless commit 67228098e77852a0cf50c7c6c4=
13fa601bd6f5b1
>=20
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  Makefile                          |    4 +---
>  patches/99-change-makefiles.patch |    6 +++---
>  scripts/admin-update.sh           |    2 +-
>  3 files changed, 5 insertions(+), 7 deletions(-)
>=20
Hi Luis,

why haven't you appaied these patches to compat-wireless-stable?

I did something wrong in "git send" so these mails are containing a
wrong From filed. Should I resend them?

Hauke


--------------enigE83F597B744A6C2F03FB1B23
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJLeGueAAoJEIZ0px9YPRMyYAwP/i7ZRcfnPHSCzwqFfX2O2sRW
auhVBNGEtUqL6senh3py1i/nqDmZjnUoVlxvIB+5zyC5RiTXZAncVBI2xpFmlfXF
gZX/njzgwemMN2jXxxZLJnhRrJfmWHqgff/tbtACoQPjZreTX62p8qVnfeLzHIBd
4caMRgkGHfw3vlmosa/J0iJi1RQAXQJlvDRaysTWbgim+HeiS2Gmo/VpeuVWhTDq
V7wWH6MO8Tapy94m/KrytN8B//0TvfLqzJi0d6VExX0bjYhDEf8McVnab+6f7YFn
oEd1lj6SGtVvbwdyIsS43+Zz6hWlkFa2vRKQD4+ozqgl+PDc985d90pqrdsHJVcm
WjUV4l4dCHf1siHdvGDfUbZxaaOn5KtQpvATXsNc1iX7ZY9ySIcnw6vWtej8t/Ox
nzS/ldpwdIzEJxzH2LXxiXqGcZ6bXRidMU3y9CSVzXPTTcxZF/y0+aan9Ppa2fCa
3dM+B0dcaokwDjNfxOoFuhIOmDVPSHgpo0gopuqGHyFJUqdq3Wwc+qGkFVe1yNu+
WJ77aEeXlotgotNQXQeWNSQbKPvVYwSO2ofbAXE+yolgv+30CmZwVMLE9UWE1zP1
TGPIcOu8KgPvnKY7W9b0kq6DZAdpbBR08YNYHfICcKBkzh3L0HFal0UgzwtDhCYd
6KZUSt/oyItShykkm+P3
=Sw0+
-----END PGP SIGNATURE-----

--------------enigE83F597B744A6C2F03FB1B23--
