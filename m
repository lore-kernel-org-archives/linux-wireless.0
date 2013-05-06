Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46878 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752713Ab3EFDjr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 May 2013 23:39:47 -0400
Message-ID: <1367811576.4131.39.camel@deadeye.wl.decadent.org.uk> (sfid-20130506_053951_318896_2066C1C1)
Subject: Re: linux-firmware: pull-request TI wireless firmwares 2012-04-29
From: Ben Hutchings <ben@decadent.org.uk>
To: Luciano Coelho <coelho@ti.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless@vger.kernel.org
Date: Mon, 06 May 2013 04:39:36 +0100
In-Reply-To: <1367229856.30716.22.camel@cumari.coelho.fi>
References: <1367229856.30716.22.camel@cumari.coelho.fi>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-7F8M3+KUx5mD+mradcRm"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7F8M3+KUx5mD+mradcRm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-04-29 at 13:04 +0300, Luciano Coelho wrote:
> Hi Ben,
>=20
> Here are some updates to our wireless firmwares.  Updated the firmwares
> for WiLink 6 and 7 and added a new version of the firmware for WiLink 8
> and a binary configuration file.  Also updated the WHENCE file
> accordingly.
>=20
> Please let me know if there are any more problems.
[...]
> diff --git a/WHENCE b/WHENCE
> index 4726742..257f24e 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -1681,11 +1681,11 @@ Version: 6.5.2.0.15 (Multi-role)
>  File: ti-connectivity/wl127x-fw-4-plt.bin
>  Version: 6.3.5.0.98 (PLT-only)
>  File: ti-connectivity/wl127x-fw-5-sr.bin
> -Version: 6.3.10.2.115 (Single-role)
> +Version: 6.3.10.0.133 (Single-role)
>  File: ti-connectivity/wl127x-fw-5-mr.bin
> -Version: 6.5.7.0.27 (Multi-role)
> +Version: 6.5.7.0.42 (Multi-role)
>  File: ti-connectivity/wl127x-fw-5-plt.bin
> -Version: 6.3.10.2.115 (PLT-only)
> +Version: 6.3.10.0.133 (PLT-only)
> =20
>  File: ti-connectivity/wl128x-fw.bin
>  Version: 7.1.5.50.74 (STA-only)
> @@ -1702,11 +1702,11 @@ Version: 7.5.2.0.15 (Multi-role)
>  File: ti-connectivity/wl128x-fw-4-plt.bin
>  Version: 7.3.5.0.98 (PLT)
>  File: ti-connectivity/wl128x-fw-5-sr.bin
> -Version: 7.3.10.2.115 (Single-role)
> +Version: 7.3.10.0.133 (Single-role)
>  File: ti-connectivity/wl128x-fw-5-mr.bin
> -Version: 7.5.7.0.27 (Multi-role)
> +Version: 7.5.7.0.42 (Multi-role)
>  File: ti-connectivity/wl128x-fw-5-plt.bin
> -Version: 7.3.10.2.115 (PLT-only)
> +Version: 7.3.10.2.133 (PLT-only)
> =20
>  File: ti-connectivity/wl127x-nvs.bin
>  File: ti-connectivity/wl128x-nvs.bin
[...]

The commit message for this bit says:

    Update the wl127x and wl128x firmwares to *.3.10.0.133 for single-role
    and *.5.7.0.42 for multi-role.

But for ti-connectivity/wl127x-fw-5-sr.bin,
ti-connectivity/wl127x-fw-5-plt.bin and
ti-connectivity/wl128x-fw-5-sr.bin this means the version is now *lower*
than before.  For ti-connectivity/wl128x-fw-5-plt.bin the version is
incremented to end in 2.133, but this is contrary to the commit message.

Are some of these firmware images being downgraded?  Should the version
numbers really end in 2.133 or 0.133?

Ben.

--=20
Ben Hutchings
If God had intended Man to program,
we'd have been born with serial I/O ports.

--=-7F8M3+KUx5mD+mradcRm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUYcl+Oe/yOyVhhEJAQpD3Q/9GUzfWJYaIFHjGAscCa0gZt1HntHQA9Vg
YfJSHJGZ4vpBDJEuBVGm3wJy6HJ5f+9ukdWHCOvz/0UnhwFiGRd+lrVjwSCKOs/J
zPf78Jiylv597dBbQ43eqermRUJI3HDajmPbjRt1y5POxpokK1jhXVVzkeSbtoVT
rvtWlultoxMwU1UFiwsZqbbeV/6/IKehAW/ptdqwlBZ2NJQAwrD2LYO67l6mSTQv
p+aiG0u6HXBtrdCkZy5CUwvKbtsoN5PE90zE0I6MatQJ9a8kQAuZnteC1Omr+HQ6
ISISoDwzSWBgjqokDUpTc24kj7MRWrCkiABQUnuWROlSdTmDXWjC+viNDkggbCA3
oepIROhKuFkMabe1FRBIHUgE0Yu0BnxI+tU1TyZRLz3ajwtoNbiRlfz5HiNWJRJv
xEXYcYaY07S8xBpxvJQwmrSYGbI+uNPwnuDVKT4AjqJhI2cyNB8gEW9dhBh6mx03
nfSh/F+VfazYd6LfUB6ZMonVf3ddGHASLGrOxHojgMfq6i1wiTqEE57lcFgu7/wD
qnD7hznr4fSzHzeXSrpwsDgiVE16Yg9TD+L0srzHVgPP0CC5+3k5m3ug8G5PbceH
EtOuh61rzUVAQ6aXIyzJ1ZXrjE36zSXai0CU9hymmdtUCk8jv57A++wgfGHUSiQ+
ULEDhckDGzo=
=wwrh
-----END PGP SIGNATURE-----

--=-7F8M3+KUx5mD+mradcRm--
