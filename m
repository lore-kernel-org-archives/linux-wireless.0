Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39740 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879Ab2BSBaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Feb 2012 20:30:08 -0500
Message-ID: <1329615009.3258.57.camel@deadeye> (sfid-20120219_023128_732887_CBA33AF1)
Subject: Re: linux-firmware: pull-request wl12xx 2012-02-17
From: Ben Hutchings <ben@decadent.org.uk>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>
Date: Sun, 19 Feb 2012 01:30:09 +0000
In-Reply-To: <1329493309.21883.10.camel@cumari>
References: <1329493309.21883.10.camel@cumari>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-4TnmcVmLDT77sAudNX09"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4TnmcVmLDT77sAudNX09
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-02-17 at 17:41 +0200, Luciano Coelho wrote:
> Hi Ben,
>=20
> Please pull the latest firmwares for the wl12xx driver.  These are new
> firmwares that are necessary to use the latest driver version, in which
> the host/fw API has changed.  We also updated our licence file.
>=20
> Please let me know if there are any problems.=20

There are.

[...]
> diff --git a/LICENCE.ti-connectivity b/LICENCE.ti-connectivity
> index 085f6c7..da80b62 100644
> --- a/LICENCE.ti-connectivity
> +++ b/LICENCE.ti-connectivity
> @@ -1,151 +1,46 @@
[...]
> +   1 TECHNOLOGY AND SOFTWARE PUBLICLY AVAILABLE
> +   2 SOFTWARE LICENSE
> +   3

What's with the line numbers here?

[...]
> diff --git a/WHENCE b/WHENCE
> index 804c91f..0596204 100644
> --- a/WHENCE
> +++ b/WHENCE
[...]
> +       Single-role:            wl127x-fw-4-sr.bin      6.3.5.0.98
> +       Multi-role:             wl127x-fw-4-mr.bin      6.5.2.0.15
> +       PLT:                    wl127x-fw-4-plt.bin     6.3.5.0.98
> +       Single-role:            wl128x-fw-4-sr.bin      7.3.5.0.98
> +       Multi-role:             wl128x-fw-4-mr.bin      7.5.2.0.15
> +       PLT:                    wl128x-fw-4-plt.bin     7.3.5.0.98
[...]

This is not the correct format for version information.  I'm going to
insist that for the new files you put a 'Version' field under each
'File' field.  Please also convert the existing version information in a
separate commit.

Ben.

--=20
Ben Hutchings
Every program is either trivial or else contains at least one bug

--=-4TnmcVmLDT77sAudNX09
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUAT0BQoee/yOyVhhEJAQpzpg//fvdlE3GZMCbXu8wLd+f1JiGIo/QBkTg2
/wWtJtJY+oFKq+ktXfOnlORKl7KURnvhKwfKy7HFsGMVg8xWXs9hL+zopXM+yngh
GF0cJI30bxSvijWzOoI108XSKMWC+6/U0yl6b+yR05nPmBS+MSZvte3svtpQBYdS
Z/yJD0+3Mxu52Rrbpd4zo8m4dNa55ynkMXXYFoKvXRgW5pHFa1V75Zkx/7kxNHeQ
8Gz8PO8ieLovk4AzLgor+AISTS4pNt0+bmlTILG9+USNboHQQlKpa6j3L4BsCjLx
3F6GQBVBJEUlt1zXFAYK3zDB1MFHcX9oV/DQHVC4DIyvnDebdrCDEbcgpQTJIxAQ
0vDYH3ViBtJQzSo0keYG+Fk9I1zZlE6q87uzSnXLCyoFcga30WEfkVx5nbfdayKb
pIe6WwuZXmwjCFcjYHlyTYFiqaLXAewwf8kD0yAorZv+BLs4XhUXIoKL3QwTQ+yN
uAAq+WwXMgDCnFHfFGF8aN7eDrs62boG3GHist7v+G6MXfQvcufnoBbPrBdz+Pkx
D8WWVKOhq5mEK/RQulIEMQH6dtNDrorQo7ZXA9ZZ4xQW1Ii9MorFUapMoKvJ7rJP
C6hGSv1MfbC4egoCsZdRS87RkQtZsZ205Cw6QACpSFrcajai99pGpmnaweB+detR
QU/x8JJHx8E=
=sagP
-----END PGP SIGNATURE-----

--=-4TnmcVmLDT77sAudNX09--
