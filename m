Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52207 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbaFCTR5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 15:17:57 -0400
Message-ID: <1401823338.2412.2.camel@deadeye.wl.decadent.org.uk> (sfid-20140603_211800_709793_E870D1C7)
Subject: Re: [PATCH 0/3] brcm: add brcmfmac firmware files
From: Ben Hutchings <ben@decadent.org.uk>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, linux-firmware@kernel.org
Date: Tue, 03 Jun 2014 20:22:18 +0100
In-Reply-To: <1397469068-19083-1-git-send-email-arend@broadcom.com>
References: <1397469068-19083-1-git-send-email-arend@broadcom.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-o+5jiJIZ3eOD8ecIu8Nt"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o+5jiJIZ3eOD8ecIu8Nt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-04-14 at 11:51 +0200, Arend van Spriel wrote:
> The brcmfmac driver added support for new devices. This patch
> contains firmware files to be used for those devices.
>=20
> These apply to the master branch of the linux-firmware
> repository.
>=20
> Arend van Spriel (3):
>   brcm: add firmware for BCM43143 2.4G 11n USB device
>   brcm: add firmware for BCM43143 2.4G 11n SDIO device
>   brcm: add firmware for BCM4354 2x2 11ac SDIO device
>=20
>  WHENCE                      |   3 +++
>  brcm/brcmfmac43143-sdio.bin | Bin 0 -> 385067 bytes
>  brcm/brcmfmac43143.bin      | Bin 0 -> 397312 bytes
>  brcm/brcmfmac4354-sdio.bin  | Bin 0 -> 507752 bytes
>  4 files changed, 3 insertions(+)
>  create mode 100755 brcm/brcmfmac43143-sdio.bin
>  create mode 100644 brcm/brcmfmac43143.bin
>  create mode 100644 brcm/brcmfmac4354-sdio.bin
>=20

Applied, thanks.  Sorry for the delay.

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-o+5jiJIZ3eOD8ecIu8Nt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU44gaue/yOyVhhEJAQp1shAAr1HWB5RWg7T+iRtYS+3E09NW+8+EHOTD
2VmF+gqsYrX5uQX7LXsBqlfgwknZVFTwVKJY43rzsoYs3wxLPS+oIqIM8RZcXze9
PRqX4RUvSQTdy91xlwD7Rg7ggVr/W53legvJ2tDiekn9GO/IsGo0qTP62mbHd6X2
erVT6J7uJFarlksLZwKojUI8UHgYQer7NkM+r6eNdHZBK403fSaoMIrzBFxZ5sq+
J2nEMZ1Hzmug+W5+kqR82A46ev2jDEqwbL3A0lIkTcMlko+pbOYPpBSUhlnvp//1
fyqwhsz193/dkbaLm73l1PJSPeE+waCLxhxPv5rPb8uGChwPHrmhY8LWCmGIYLGa
8bZFRYFURqWTJKq3x5fxFz7r40Ioav1UJZPzG7+BWNIFrnVqRGv2fp7b3qfctThR
w96xaHVVV28FLfap5K8+AcDrb/OFddSHCB3LONsUeBRBIeFlTBU2MPwim6rkV9S3
Ydq+Xs5mtvkHr8i2k8V23yiEJntTbHQIAiZiJ8U6ihM/ubQ6hD76hgfwSiNCQlVq
2hQc13wJj8FZRTkBehtiWIV3RIHMmfHGvs1+opGIHRKPL6bhnZSZNYIlsvVZOi7A
4nFfy2r2mXUpCOSvAfXmyDpTHLXno6HpEZiRp7yP7B6bWYSz+asYXEzlwJGsd9n5
Cueuok+AufU=
=MooV
-----END PGP SIGNATURE-----

--=-o+5jiJIZ3eOD8ecIu8Nt--
