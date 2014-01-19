Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60653 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbaASXkB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jan 2014 18:40:01 -0500
Message-ID: <1390174797.3651.7.camel@deadeye.wl.decadent.org.uk> (sfid-20140120_004022_935964_3233632D)
Subject: Re: linux-firmware: pull-request Marvell mwifiex-firmware 2014-01-09
From: Ben Hutchings <ben@decadent.org.uk>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Frank Huang <frankh@marvell.com>
Date: Sun, 19 Jan 2014 23:39:57 +0000
In-Reply-To: <1389325691-21371-1-git-send-email-bzhao@marvell.com>
References: <1389325691-21371-1-git-send-email-bzhao@marvell.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-NzcuPV+5m5yPWWALH6Df"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NzcuPV+5m5yPWWALH6Df
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-01-09 at 19:48 -0800, Bing Zhao wrote:
> The following changes since commit 52d77db9f133afe4d2b26aeccfd603745f45fd=
a1:
>=20
>   Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/=
egrumbach/linux-firmware (2013-12-30 15:22:40 +0100)
>=20
> are available in the git repository at:
>=20
>=20
>   git://git.marvell.com/mwifiex-firmware.git master
>=20
> for you to fetch changes up to 2d4aa2037a7015c4d78cde40006f80b8012537a6:
>=20
>   linux-firmware: add Marvell USB8897-B0 firmware combo image (2014-01-09=
 19:17:35 -0800)
>=20
> ----------------------------------------------------------------
> Bing Zhao (3):
>       linux-firmware: update Marvell USB8797-B0 firmware image
>       linux-firmware: update Marvell SD8897-B0 firmware combo image
>       linux-firmware: add Marvell USB8897-B0 firmware combo image
>=20
>  WHENCE                  |   7 +++++--
>  mrvl/sd8897_uapsta.bin  | Bin 639012 -> 668028 bytes
>  mrvl/usb8797_uapsta.bin | Bin 508372 -> 541048 bytes
>  mrvl/usb8897_uapsta.bin | Bin 0 -> 705364 bytes
>  4 files changed, 5 insertions(+), 2 deletions(-)
>  create mode 100644 mrvl/usb8897_uapsta.bin
>=20
> diff --git a/WHENCE b/WHENCE
> index 4f87d8a..23faafa 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -730,10 +730,13 @@ File: mrvl/sd8797_uapsta.bin
>  Version: 14.66.11.p151
> =20
>  File: mrvl/sd8897_uapsta.bin
> -Version: 15.69.2.p11
> +Version: 15.68.201.p113
> =20
>  File: mrvl/usb8797_uapsta.bin
> -Version: 14.69.11.p179
> +Version: 14.68.29.p26
[...]

Why are these updates rolling the version number backward?  Did the
later versions cause regressions?

Ben.

--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-NzcuPV+5m5yPWWALH6Df
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUtxiTee/yOyVhhEJAQpldhAAyz6+50GTS5jnRqzVL4DGWu7pWFusSQhi
N6z1E6MPI4HtRPROMpzNkBAI+ych4amYUJA2vjNorMPPOPqe6ZoHkz23IVhP652x
jyVfWLqqsIs/Lj9VE2V4AVxrE3CnGlfV1Cy4zGYdcQIoJ/AKKYMhVtgQkFDiDvnK
eHoR7kY6FLhZzPUJvBH1+mNEPACh4ujF+dSmp2zEMehrYHLUgjMN6/6dROmUqNdi
XPFSXCeIDI9w20HqXrxskPG8PLYtLj+BAP6ljQFeVmAGGNEDdK1ebfKxj/aiJqSw
pN/reefcFNuaTR00128suVuCQymvPcxXBdA+adci4hKy3na91dZF22wyZta4SN9t
Prr4OExqE516dSq+SWfd74db1F5U10cpk1LOiLQPR+h/Wlsuxmg1Mbl9CAifaiyf
u32vmqevOITNzrAjW9RvA6GAqIB+fLlWoHQQflAfhhlaHvIl8Lx0KZHoKBuObo3R
1nl8Oho3WM9Fxcgh3Dy/Yx6dCZvSetZNKVXrWjTCExhRxW5Pk5Kh+KjgXKEklPXT
DwHmKgfONPs1hAcVsCZ7MNXjqrWgrH3euixC9FIzsXVs3UBRHGRcQS71sm8BiJ/d
yd2e4eKw0/1eRw69qpX0XuFqFpxH/HLN6ARBz2E9nbz2Tcg9uRq0o0sZDYDp5HCs
totZkMccAKk=
=oex4
-----END PGP SIGNATURE-----

--=-NzcuPV+5m5yPWWALH6Df--
