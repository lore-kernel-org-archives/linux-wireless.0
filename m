Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46057 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755056Ab3JMUGR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Oct 2013 16:06:17 -0400
Message-ID: <1381694770.1301.93.camel@deadeye.wl.decadent.org.uk> (sfid-20131013_220621_096662_8E781ED7)
Subject: Re: [PATCH 0/4] brcm: rename firmware files and add new files
From: Ben Hutchings <ben@decadent.org.uk>
To: Arend van Spriel <arend@broadcom.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Date: Sun, 13 Oct 2013 21:06:10 +0100
In-Reply-To: <1380617590-5120-1-git-send-email-arend@broadcom.com>
References: <1380617590-5120-1-git-send-email-arend@broadcom.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-WZKg30HhX5wBG90iWPjS"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WZKg30HhX5wBG90iWPjS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-10-01 at 10:53 +0200, Arend van Spriel wrote:
> This series renames the firmware files to match the required filenames in
> the brcmfmac driver. Previously, these files needed to be copied/linked t=
o
> a generic name that was used in the driver. So for older kernels this is =
still
> needed.
>=20
> Also included are new firmware files for BCM43241 and BCM4335. The brcmfm=
ac
> driver lists some more firmware files, but firmware is not yet released f=
or
> those chips.
>=20
> Arend van Spriel (4):
>   brcm: rename firmware names expressing host interface type
>   brcm: add firmware file for BCM43241 SDIO chipset
>   brcm: add firmware for newer version of BCM43241 SDIO chipset
>   brcm: add firmware file for the BCM4335 SDIO chipset
>=20
>  WHENCE                                           |    9 ++++++---
>  brcm/brcmfmac43241b0-sdio.bin                    |  Bin 0 -> 455745 byte=
s
>  brcm/brcmfmac43241b4-sdio.bin                    |  Bin 0 -> 403855 byte=
s
>  brcm/{brcmfmac4329.bin =3D> brcmfmac4329-sdio.bin} |  Bin 253748 -> 2537=
48 bytes
>  brcm/{brcmfmac4330.bin =3D> brcmfmac4330-sdio.bin} |  Bin 222126 -> 2221=
26 bytes
>  brcm/{brcmfmac4334.bin =3D> brcmfmac4334-sdio.bin} |  Bin 451566 -> 4515=
66 bytes
>  brcm/brcmfmac4335-sdio.bin                       |  Bin 0 -> 569291 byte=
s
>  7 files changed, 6 insertions(+), 3 deletions(-)
>  create mode 100644 brcm/brcmfmac43241b0-sdio.bin
>  create mode 100644 brcm/brcmfmac43241b4-sdio.bin
>  rename brcm/{brcmfmac4329.bin =3D> brcmfmac4329-sdio.bin} (100%)
>  rename brcm/{brcmfmac4330.bin =3D> brcmfmac4330-sdio.bin} (100%)
>  rename brcm/{brcmfmac4334.bin =3D> brcmfmac4334-sdio.bin} (100%)
>  create mode 100644 brcm/brcmfmac4335-sdio.bin

I've applied all of these, thanks.

Ben.

--=20
Ben Hutchings
Beware of bugs in the above code;
I have only proved it correct, not tried it. - Donald Knuth

--=-WZKg30HhX5wBG90iWPjS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIVAwUAUlr9Mue/yOyVhhEJAQoKYA/+IOcoYt5VZICR/Qh9t52EQlJJ66ULy1KC
t5SUUg/qpEFBXw9KTMctHypFlBw6g6An18kgRGGIS/rOUABjcEgAQtsiksHgD4Ak
Iwa8neS4gth1Z46vcCCY/YpHdCU0LIC/6QHIYd0cz/SPN2whgH9Ht/bIR6a2/nEM
faJSIr647sWB6dPMkoSNMvsGZit/EuisALQtvYUsFesNsZeWV8eFIEd47azorwp4
OzfLbZiHkD+zoVvG96I85VuWSXChwgAoRangolE7il9wRfZF4wn5Qwa3GRgzWBVq
rka6ECZYQNqZvkKNMC5O26n5Nf8oK9o7OkP6nE/ciHEio3r83XawfYcDk6OEH7K4
m7iXDe0fhUzSQ2qZvOli8goVThX445OXjFhvv8+s/KLMcfZvHX2HiMv4MWHPSl+/
ERtgfOjyt3F2axvcV9cPcMVlKgDLdbNeIfrDiWd5aJc7XxVgb0HRK1NTGp/MC0D6
DJfuvkeBRbvUVCqnJfWZWDgciRfXlWxRrjsMzK4dffCgO1+FDd/2JQkDDDCKLseJ
8GhQUJENKsNgcun2vnYX4fjEom7DM5GGL6QE6mvMBW81ww9Ta3Go7jnQnfKmrCqk
mBc09Vpt97d9vV6O31idlcfpogwPqOwlzQTWZNmIVIiq2uBZD3zXpBd8abRlQeB4
vq2K/QwS5rA=
=QoDc
-----END PGP SIGNATURE-----

--=-WZKg30HhX5wBG90iWPjS--
