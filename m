Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:59406 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932286Ab3LIUdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Dec 2013 15:33:12 -0500
Message-ID: <1386621181.3878.87.camel@porter.coelho.fi> (sfid-20131209_213316_052722_DCBDB4D6)
Subject: Re: [PATCH] MAINTAINERS: remove myself as maintainer of TI WiLink
 drivers
From: Luca Coelho <luca@coelho.fi>
To: linville@tuxdriver.com
Cc: balbi@ti.com, linux-wireless@vger.kernel.org
Date: Mon, 09 Dec 2013 22:33:01 +0200
In-Reply-To: <1386620912-9292-1-git-send-email-luca@coelho.fi>
References: <1386620912-9292-1-git-send-email-luca@coelho.fi>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-mWii1unmLws1XIq2wGDx"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mWii1unmLws1XIq2wGDx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi John,

Can you start taking wl12xx/wl1251 patches directly into your tree from
now on?

I'm not going to send any more pull requests for the WiLink drivers.

--
Cheers,
Luca.

On Mon, 2013-12-09 at 22:28 +0200, Luciano Coelho wrote:
> I don't have the time to maintain the TI WiLink WLAN drivers anymore.
> Remove my name and mark them as Orphan.
>=20
> Signed-off-by: Luciano Coelho <luca@coelho.fi>
> ---
>=20
> Unfortunately I don't have the time to maintain the WiLink drivers
> anymore.  Does anyone want to step forward to take it over?
>=20
>  MAINTAINERS | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e65a2c2..265bf79 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8560,12 +8560,11 @@ S:	Maintained
>  F:	sound/soc/codecs/twl4030*
> =20
>  TI WILINK WIRELESS DRIVERS
> -M:	Luciano Coelho <luca@coelho.fi>
>  L:	linux-wireless@vger.kernel.org
>  W:	http://wireless.kernel.org/en/users/Drivers/wl12xx
>  W:	http://wireless.kernel.org/en/users/Drivers/wl1251
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git
> -S:	Maintained
> +S:	Orphan
>  F:	drivers/net/wireless/ti/
>  F:	include/linux/wl12xx.h
> =20


--=-mWii1unmLws1XIq2wGDx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAABAgAGBQJSpij9AAoJEKFHnKIaPMX6rFsP/ixOzZ2qWWbixicpxIWf2doF
ppqrxizUnXz73dFN7Lk9wEFPa10p+SjXT9hHFXqueFTXGncwB7P3O4Wjvi4c/uIi
RmEAEnpRaGSsr/giKyVjqYrxuaVuBNg3txPtGXHm0HBwVzBccy460CwHJbCkx0Do
2e2tB+tHfdyO8QZYiUaIKcgBrWN17aLn7bvc4VYmeJPkk+mIO7vJUxhtwCuijPp8
LmYMcMjFri82aGIJ5msQMuT+NLk9c6qz3G6OfSADyK4xOqTGBlxz6h/dmS4gkaqL
/76E52j+GXHc5Y5OO23b58M7SxIrUx21p9entWc5MBK399Ymau5GRvlRDbvvJYCX
Iqu4VtFmngRhMCbzRpzHF1c7ZpR0Iva+ViXFdJ65XeuLbqzTzDZqvY/GjgVC8vDW
LAxXtzeQBo00WqXGUozVmXHd4IptB0PlyV9p2oW31+F0vbLWYSnZxC8vDAUxXP1W
5pVBEO0ab15OinY6StUZ9vEOfXf5jrh71tbOe51lCr2L7/GMm7toKLwt555rbMqf
xbsZqISJkMyE5jQ5RYn4O/UULWl9bPRdoLA8tF2kjPuMYJ0yWNlh50ieFkiv0x6F
11Nzi4xEig69gee/Dsv9Fd5b1/gY5ScA+JT/DTs7ZVTRCXuv1OkZVZJyHSq3vTim
Y8bToiCeFAIKc91tLY+g
=bF89
-----END PGP SIGNATURE-----

--=-mWii1unmLws1XIq2wGDx--

