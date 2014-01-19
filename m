Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60630 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752172AbaASXbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jan 2014 18:31:10 -0500
Message-ID: <1390174259.3651.2.camel@deadeye.wl.decadent.org.uk> (sfid-20140120_003114_447957_4CDEADCD)
Subject: Re: pull request: firmware for Intel Wireless adapter - 7260 / 3160
From: Ben Hutchings <ben@decadent.org.uk>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>, hui.xiao@intel.com
Date: Sun, 19 Jan 2014 23:30:59 +0000
In-Reply-To: <52C2FE41.3080409@gmail.com>
References: <CANUX_P3EwRW=+1SwHQN81hKKGZiVBFDcmLZAqknXZE+UzL_fTA@mail.gmail.com>
	 <52C2FE41.3080409@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-wlmSgnT2bqv4YAWi7MMx"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-wlmSgnT2bqv4YAWi7MMx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-12-31 at 19:26 +0200, Emmanuel Grumbach wrote:
> Hi Ben,
>=20
> This is another pull request for another firmware. I am sorry not to
> have put this together in the same pull request, but I just didn't know
> when that new firmware would come out.
> It doesn't replace the older one:
> * iwlwifi-{7260,3160}-7.ucode is supported starting from 3.10
> * iwlwifi-{7260,3160}-8.ucode is supported starting from 3.13
>=20
> This is why I don't remove the -7.ucode.
> At some point (maybe around 3.15) we will stop supporting -7.ucode.

Even then, the -7 files should remain in linux-firmware.git as there is
not any minimum kernel version.

> Thanks!
>=20
> The following changes since commit 52d77db9f133afe4d2b26aeccfd603745f45fd=
a1:
>=20
>   Merge branch 'master' of
> git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware
> (2013-12-30 15:22:40 +0100)
>=20
> are available in the git repository at:
>=20
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware
> master
>=20
> for you to fetch changes up to 11fdbda75cebef71e878fd0dfa6bfca984be35f4:
>=20
>   iwlwifi: update firmware for 7260 / 3160 devices (2013-12-30 18:59:33
> +0200)

Pulled, thanks.

Ben.

> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       iwlwifi: update firmware for 7260 / 3160 devices
>=20
>  WHENCE               |    6 ++++++
>  iwlwifi-3160-8.ucode |  Bin 0 -> 662032 bytes
>  iwlwifi-7260-8.ucode |  Bin 0 -> 674628 bytes
>  3 files changed, 6 insertions(+)
>  create mode 100644 iwlwifi-3160-8.ucode
>  create mode 100644 iwlwifi-7260-8.ucode
>=20
>=20

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-wlmSgnT2bqv4YAWi7MMx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUtxgNOe/yOyVhhEJAQreIw/+MPTK9etT/pMn4zJAZAO3Fb/D44kUon9a
GzFMVQeHskgYolN9FlBR08SlMY1qZsmj9U2UVq4UDHXlic+YM5TwWBd1oPSuDjXD
+Yr7KoITQGn/hNkhoiPWMswnAEe80XE1R9UPM0ufID0Gzc9twlgbhZIqnnLTcLAl
OIrJmcuayjke+nK7/JyESJWnlIvjqATTLlAEA9IlkAumIJwiRRH0FQXSXyhYno6n
1CD75lQu+js8BWAgm/4/hmFix3LrDXuDnORgBY0Ztnmjpj9U4N92T/4aYVJFAOxy
sx51J3ANCJk83WgTP79YCDSvk738w5ogQh8EVtCE9sU3NUH4glMX4JWjQBQyXqPu
mxf0fSxtYLpNUyGhj8u11JzL/TkcdNeskSqP2CsHdxbfKhoTarg1DpSs0Ib5GCFc
PRcyrrkBAlOcU1OHj+drW+3b+d/VZPW9d+cesEjwo5MSYV3HRRw2VJ0cY2MCADt0
JfON2/SCos5yap2S9Rrbu7c1JSZ6pKx5pMOZBbXVaWCDLsbKA7xF0/NKGODjJJnW
gH+fR5XwflVwAh3h3GyIRNFLlr4e2/bGFEEpKqwg9DscRYP/fdo4yqU+dZ6R/+3D
/Manz3IiR/3WIKzP2kkYIm6yd69Vga3q3hHqHPrf4pcxvHze+zisimCqRLOqpD5F
Ed9oiX09nKA=
=X9Jw
-----END PGP SIGNATURE-----

--=-wlmSgnT2bqv4YAWi7MMx--
