Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58348 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758585AbZJPLiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 07:38:55 -0400
Subject: Re: [PATCH] wl1251: rename spi device to wl1251
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20091013174119.15796.81021.stgit@tikku>
References: <20091013174119.15796.81021.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-t6xpzvf2oaTFIrpOQQA4"
Date: Fri, 16 Oct 2009 18:51:37 +0900
Message-Id: <1255686697.4095.324.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-t6xpzvf2oaTFIrpOQQA4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-13 at 20:41 +0300, Kalle Valo wrote:

> -MODULE_ALIAS("spi:wl12xx");
> +MODULE_ALIAS("spi:wl1251");
> diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wirel=
ess/wl12xx/wl1251_spi.c
> index 14eff2b..2cf8a21 100644
> --- a/drivers/net/wireless/wl12xx/wl1251_spi.c
> +++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
> @@ -307,7 +307,7 @@ static int __devexit wl1251_spi_remove(struct spi_dev=
ice *spi)
> =20
>  static struct spi_driver wl1251_spi_driver =3D {
>  	.driver =3D {
> -		.name		=3D "wl12xx",
> +		.name		=3D "wl1251",
>  		.bus		=3D &spi_bus_type,
>  		.owner		=3D THIS_MODULE,

IIRC there's a preprocessor symbol for the module name (MODULE_NAME?)

johannes

--=-t6xpzvf2oaTFIrpOQQA4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2EIlAAoJEODzc/N7+QmaiZgQAMArhteSMbld2svoPpeS71A3
3+rcbsSRDFV6G4XQYsg0NZqAQSLLA/FQqIfu/VsiEy+nI+I3czNnd27aimACP4e9
hNOZHaaUWQcR+GB1ukeTrUwqPTaYfFFJFDuJlKQzwAEGu9wbBdm1feKLVq4ToBX7
fcnI6isII52Up2p7w9yvpKQA85+naW/3VbbF/js/KnK4MI6JiFywz6Xw6l3c7mNC
Qcr7Hdg68f8ZoDxQppZWSirX5MtZ1Vtu00onyKuy8w+JQF5K13jUvYne67bAP7yc
l2vY6oTKaoo/rTq2YnTA7FDw4XSWDB4z66gJgAm9vzbXabCbcOMN0YCTdvPyla7J
uQ3sffUIPmwKLWyvXO9M/vobi+ttMyy1TnUfEVXH+gpG1HvQyk0O5EBedOnOs5ez
hHgmjJ07GxP/nWQ1rEmTElaRKXnUkbckN1GQ04XuQNTv4PKU6UZNsFwDyOqC24yy
wFQfCep5UjzIEl158FSjr2Cu4rQkFMz2D0tbjeF2N3qjgpKUBSUJN4nLcTlOfk5C
PTTetNG2Ibluw/y0fB1jpKi6H7vr1QCzsSgXStuVagtEQ4yvjDvFr7q0JSORWOVl
How48AkYAIP2JHD5RSLA/qzFNqRUs6JvxZNDsQuvfF/xkQFVmJflf2qczN/1Enrp
/MvqDXeAGpYhNpltYsL8
=6OeD
-----END PGP SIGNATURE-----

--=-t6xpzvf2oaTFIrpOQQA4--

