Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33444 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbZEBVHA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 May 2009 17:07:00 -0400
Subject: Re: [PATCH] add version.h to .gitignore
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1241294826-27585-1-git-send-email-marcel@holtmann.org>
References: <1241294826-27585-1-git-send-email-marcel@holtmann.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CiLXMIc5xSFE+ixm2SYX"
Date: Sat, 02 May 2009 23:06:57 +0200
Message-Id: <1241298417.13562.26.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-CiLXMIc5xSFE+ixm2SYX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-02 at 13:07 -0700, Marcel Holtmann wrote:
> ---
>  .gitignore |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/.gitignore b/.gitignore
> index 16bb88b..edc6864 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -3,5 +3,6 @@ iw
>  *.o
>  .config
>  version.c
> +version.h

Nah, just rm version.h, it won't be rebuilt :)

johannes

--=-CiLXMIc5xSFE+ixm2SYX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/LXvAAoJEKVg1VMiehFYblYP/0Myc8GEJ8OPIRM29td0ckjI
HCP1MMZ1zO0UracybqA60FBSr0g0AqUBgtTVTaHQSqzS8rsRTVWmwv+EfwmXGw2B
+jpOB2QgSbQVNoVsPu1SjTi1uqdkqFHsazGNVjDqANdKK/lQv6zWKOPdHvBFPeBv
JomakrWNgB008AKM1MfiJBsbxEPNROgBf7RI+BIdmOrkWPREPRId4st9dg5t25b5
zNC6fuM/eQIuvEwosF98YC9vlK9vwvBKtdiO8GwoUPAmrUpDo6FESZM6ffkQeI2E
pEm3R/4CPNhmX+t54NkWEsay/62P1wnOn6nUjpdXSJBqDp4DWuPkrcpiw5cq8xtw
AwARgIH+ixZPCLV8kIgNH7hExi07101RdlllIeQhaak9Jr/UHFXGZTobFJiJrVg8
dq07mqaeGWjg6uWviKaxtUhHEgYeY9c6mwFaE9Fhr+qI8Pp3Nu6eDL7JQdRApI6S
4oRAdLFluhXuD9auIK7jbriRtyY4iFQ/InxFP+YwfGd13lPxiilIjFwl4CtGNcZ/
uCtJOFghfyJBwVdE0+PZhb9jIjgF/alj+MAz16hodiQfzAuQKSPPSqaHe0wirmZr
hocDnZd67HbwehmLcFs1F1qkK2wEQQJfRTkIYBt67yNxM0u8MNmM8tpq8RHYrLhn
GxcBILz24qt9xknc52FI
=WqLf
-----END PGP SIGNATURE-----

--=-CiLXMIc5xSFE+ixm2SYX--

