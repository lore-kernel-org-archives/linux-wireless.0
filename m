Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55005 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367Ab2BKTXu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Feb 2012 14:23:50 -0500
Message-ID: <1328988230.325.24.camel@deadeye> (sfid-20120211_202421_200880_EC735E18)
Subject: Re: [PATCH 0/4] linux-firmware: brcm: new firmware files for
 brcmfmac and cleanup
From: Ben Hutchings <ben@decadent.org.uk>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>
Date: Sat, 11 Feb 2012 19:23:50 +0000
In-Reply-To: <1328302605-3382-1-git-send-email-arend@broadcom.com>
References: <1328302605-3382-1-git-send-email-arend@broadcom.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-n/5leGckS1+CBmFwrkd4"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-n/5leGckS1+CBmFwrkd4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-02-03 at 21:56 +0100, Arend van Spriel wrote:
> This patch series adds new firmware for bcm4329 and bcm4330 SDIO chipsets
> and removes the nvram file from the repository as it is not useful for Li=
nux
> users and only used for internal development.
>=20
> Also included is firmware for the bcm43236 USB chipset, which will be
> supported by the brcmfmac driver.
>=20
> This series applies to kernel/git/firmware/linux-firmware.git tree. These
> files will be used by brcmfmac as of kernel v3.3.

Applied, but:

[...]
>  create mode 100755 brcm/brcmfmac4329.bin
>  create mode 100755 brcm/brcmfmac4330.bin

I had to fix these permissions.  Please take care to fix executable
permissions when copying files from non-Unix systems.

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-n/5leGckS1+CBmFwrkd4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATzbARue/yOyVhhEJAQqJ/hAAkZOUmn0CjaTdsVMs21ej/2SV55V1NsoH
g9dngJIMkQaCPY/YJAKwFIWoTFhRX6ITP+aHdB0sFLqRCsaYzfZHp4lXRc516URY
J7T+As+MtiSoLha2WF1hZd+Qzc9OigHaGKTwmuVW5jcpR4VjWwbpyNZQm3cgbjQJ
gxPBjJE7ce8k9KZzCnaKrK5dApf8AO1+mCaTi3T3M8y9rB3FaA4k17gn2Wz2swv9
ORHwTbVvQ2vMZi0re6wiKvcFVaf+vmqJBygX1lz8A/8oFRtEe1QAAOwBWNkHiadI
e8QXK9ANKSKUsGeJ/8Um+UfTAGUwju4rGfZwKudVUPFs4suYI0/mUQKSiaYHRROk
r4hhWaelN6GMMxBudDOGLQo5WAzJNZ3w0HZg6oC0jxMjH4VV2H1nuW3AKoUKad4/
DQ0FBN9lJgEmATUmrC41ENZlXp8a/6sVNQNjzQTeI96aHirqhH2BJdB6eKEYAX5M
QxncMyyQZKSz6yeV94pyfFUx3UJN8ajKeaeDDePvuEeA1cVPhOyV12PokTottypQ
2fNo8+bKcvgVAI6ybU3eGKkcVgv/A5Il3BGOdpotmxuzHm1N2MDHHcnuzKkJGtoW
1GaJJAPbZ575dwb/RiOOMjh1r4txoCZfXmY2arLLtILJxkSJYXDVQvSiO/ldi3MS
byygdZ0pZuY=
=nitP
-----END PGP SIGNATURE-----

--=-n/5leGckS1+CBmFwrkd4--
