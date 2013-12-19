Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46948 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751196Ab3LSKdy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Dec 2013 05:33:54 -0500
Message-ID: <1387449216.21926.40.camel@deadeye.wl.decadent.org.uk> (sfid-20131219_113358_465912_F8AAC8AF)
Subject: Re: pull request: firmware for Intel Wireless adapter - 7260 / 3160
From: Ben Hutchings <ben@decadent.org.uk>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	Matt Chen <machen@suse.com>,
	John Linville <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Date: Thu, 19 Dec 2013 10:33:36 +0000
In-Reply-To: <52AF37CE.4020906@gmail.com>
References: <CANUX_P3PxN3ENgizJ-V5D0Of45AFoGcJ2wuzW-8ZwzToxTkcdQ@mail.gmail.com>
	 <52AF37CE.4020906@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FfgxPjgM9X9fQA6ySGYK"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-FfgxPjgM9X9fQA6ySGYK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-12-16 at 19:26 +0200, Emmanuel Grumbach wrote:
> Hi Ben,
>=20
> I have a new firmware for 7260 / 3160 - new version is 22.1.7.0.
>=20
> Please pull - thanks!

You need to update the version number in WHENCE.

Ben.

> The following changes since commit 7d0c7a8cfd78388d90cc784a185b19dcbdbce8=
24:
>=20
>   Merge branch 'wilink4' of
> git://git.kernel.org/pub/scm/linux/kernel/git/balbi/linux-firmware
> (2013-10-13 21:11:46 +0100)
>=20
> are available in the git repository at:
>=20
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/egrumbach/linux-firmware
> master
>=20
> for you to fetch changes up to 478227556dfc3563892c3e1ec3abfa03c663e10d:
>=20
>   iwlwifi: update firmware for 7260 / 3160 devices (2013-12-15 21:40:38
> +0200)
>=20
> ----------------------------------------------------------------
> Emmanuel Grumbach (1):
>       iwlwifi: update firmware for 7260 / 3160 devices
>=20
>  iwlwifi-3160-7.ucode |  Bin 670172 -> 670484 bytes
>  iwlwifi-7260-7.ucode |  Bin 682892 -> 683236 bytes
>  2 files changed, 0 insertions(+), 0 deletions(-)
>=20

--=20
Ben Hutchings
It is easier to write an incorrect program than to understand a correct one=
.

--=-FfgxPjgM9X9fQA6ySGYK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUrLLgOe/yOyVhhEJAQoJig//ctJDQmlMNTGSeyIW7rJF7/mp57sw7oxc
fTgkTpFHNeZONWoxcspvPF0ljPAtNyFq+Z6Nl0Oj3CtNFiFe89raf3f2BTEkTjmb
e4umMTrLFJCFA+q3Q63EWN5Ll/BVE8hDKaz2b/QvtSyqN8NFtT9Sova29pXRYmr9
vikPEwVF67dFyswGV+rwrJaXovFi8uCocDRUQt8/+1IEkeipwzCnysgd0RxdfWkS
aHTJI5HfPU+4bvTxaOlYWJgv2uBnjdOphaP9EwGXzy+hxCKzQuweqSx/F6waN9IQ
H9kfG6cBW8JzhrR4riL8KmXbFiegyy0nGXJaYPnsdzIItnVPIy0wcUp8mDWVKe1Z
ktIsVS8uWrC9pVm1kqvyQJ4LNoRwS7BE/WM7mdm/iG9aima6CsLgPZVjkD0sCuE8
tIydrT9+kDmqLtH13ghUh9FlSXY5hDCCayBNLPV8DFj0PNZ/w+Mq94hXHD5vDeGJ
Nbgqa+EBgULkf3pF3JoBJ1u3dOlDD195tk7mIMuSlXNa3oRfYOAh3w1myvA6UpjF
sFM+eclOiWDxE5dBEY0Yc5Wtgxi6BqCpoZVdEDxU3uxc4bR1R3bjApPR5Ys8wiZ8
hJanwHvlxB3/JjEQ1DVNdS2+cFiOd3elPOAgNraptsGeef/xanB3gHFSREtlEjZd
WL4AI1C75YA=
=J+9f
-----END PGP SIGNATURE-----

--=-FfgxPjgM9X9fQA6ySGYK--
