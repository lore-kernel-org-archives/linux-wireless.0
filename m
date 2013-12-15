Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44250 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679Ab3LORr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Dec 2013 12:47:57 -0500
Message-ID: <1387129650.12172.90.camel@deadeye.wl.decadent.org.uk> (sfid-20131215_184801_616573_B26E5E47)
Subject: Re: linux-firmware: pull-request Marvell mwifiex-firmware 2013-11-06
From: Ben Hutchings <ben@decadent.org.uk>
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	Frank Huang <frankh@marvell.com>
Date: Sun, 15 Dec 2013 17:47:30 +0000
In-Reply-To: <1383765913-19716-1-git-send-email-bzhao@marvell.com>
References: <1383765913-19716-1-git-send-email-bzhao@marvell.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-4YQP/PeUxXa9Huv2Pnlr"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4YQP/PeUxXa9Huv2Pnlr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-11-06 at 11:25 -0800, Bing Zhao wrote:
> The following changes since commit 7d0c7a8cfd78388d90cc784a185b19dcbdbce8=
24:
>=20
>   Merge branch 'wilink4' of git://git.kernel.org/pub/scm/linux/kernel/git=
/balbi/linux-firmware (2013-10-13 21:11:46 +0100)
>=20
> are available in the git repository at:
>=20
>=20
>   git://git.marvell.com/mwifiex-firmware.git master
>=20
> for you to fetch changes up to b7c848634538ff87317acd802fb4645cfd2f9fb5:
>=20
>   linux-firmware: add Marvell SD8897-B0 firmware combo image (2013-11-04 =
16:03:34 -0800)

Sorry for the delay.  Done.

Ben.

> ----------------------------------------------------------------
> Bing Zhao (2):
>       linux-firmware: update Marvell PCIe/USB 8897-B0 firmware combo imag=
e
>       linux-firmware: add Marvell SD8897-B0 firmware combo image
>=20
>  WHENCE                   |   5 ++++-
>  mrvl/pcie8897_uapsta.bin | Bin 350244 -> 656896 bytes
>  mrvl/sd8897_uapsta.bin   | Bin 0 -> 639012 bytes
>  3 files changed, 4 insertions(+), 1 deletion(-)
>  create mode 100644 mrvl/sd8897_uapsta.bin
>=20
> diff --git a/WHENCE b/WHENCE
> index 2d52804..3875e77 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -727,11 +727,14 @@ Version: 14.66.9.p96
>  File: mrvl/sd8797_uapsta.bin
>  Version: 14.66.11.p151
> =20
> +File: mrvl/sd8897_uapsta.bin
> +Version: 15.69.2.p11
> +
>  File: mrvl/usb8797_uapsta.bin
>  Version: 14.69.11.p179
> =20
>  File: mrvl/pcie8897_uapsta.bin
> -Version: 15.69.201.p52
> +Version: 15.69.2.p11
> =20
>  Licence: Redistributable. See LICENCE.Marvell for details.  Originates f=
rom
>  http://git.marvell.com/?p=3Dmwifiex-firmware.git
> diff --git a/mrvl/pcie8897_uapsta.bin b/mrvl/pcie8897_uapsta.bin
> index b067689..858c100 100644
> Binary files a/mrvl/pcie8897_uapsta.bin and b/mrvl/pcie8897_uapsta.bin di=
ffer
> diff --git a/mrvl/sd8897_uapsta.bin b/mrvl/sd8897_uapsta.bin
> new file mode 100644
> index 0000000..70732a6
> Binary files /dev/null and b/mrvl/sd8897_uapsta.bin differ

--=20
Ben Hutchings
Q.  Which is the greater problem in the world today, ignorance or apathy?
A.  I don't know and I couldn't care less.

--=-4YQP/PeUxXa9Huv2Pnlr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUq3rMue/yOyVhhEJAQpHDw/+KQ5wXMKH8UTDrDWYzw+hhTeQuIf/3R59
85ioLjsi38ocKHkBoGGz8CFViZe6AEz4x5697QyAdY1SQDeovScWqo08yuFJsLyA
MSikk43m7z+zmSJiRdYieyy4HibHtHTQBRMe/ArPxoKMXCI/Jzph5wNoDMoJarpr
rqCRxuahM9Q/hF7j7lnhCVvuHBY4tYO830c/pdvjVYX/75uuBPVdvkreuhEI9o8A
rGc6g0yg/uNZBOfrmIIOOXZrqsx/6MESaExj8mdNfF+BzxH5k8jcLC6XqmInX6Vy
TUa49WWMdOgJXlZj2AAN6w9OEBlFtrDba3Iv7wzjgoQM4J4zTxTmUu2k12ZRsyhz
/8oHujE6NXaV3VRBJ11tkbleyNtt6Uqpm591hrAHOQxTnJqRGsxuhh4ctjPIUl4s
vJoZvKsZlHZmbfjBk38zx4rZoMn927xephhoAxyDXbt0YA50FHMgP5bbL1PSqbLY
idz6pKOzKLx3HaWX5ysHYEpQL9AZi2jPNZUvpCWQfbBcv7t6UqMBwYNFr5pvUrGY
TjBgMoqLD0u/LFVdcd931T6tGZ4j81s2HnytTy8pwVvSj8bj5LCPpHtTAGbtoMYv
nYyNsXsYOByEW6AOT18cjKRXBamV+T+NkMwgbtp2bqn/GsavxRjViudOORJEFTtA
lTGcZOhh+eY=
=F7+i
-----END PGP SIGNATURE-----

--=-4YQP/PeUxXa9Huv2Pnlr--
