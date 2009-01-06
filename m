Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:54581 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbZAFM5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 07:57:25 -0500
Message-ID: <4963552D.40808@web.de> (sfid-20090106_135729_420615_EAB728D7)
Date: Tue, 06 Jan 2009 13:57:17 +0100
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Lennert Buytenhek <buytenh@wantstofly.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH,RFC] initial mwl8k driver for marvell topdog wireless
References: <20081216025542.GO18056@xi.wantstofly.org>
In-Reply-To: <20081216025542.GO18056@xi.wantstofly.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCF8CEF99ADDC709F51CA05F5"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCF8CEF99ADDC709F51CA05F5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Lennert Buytenhek wrote:
> Hi all,
>=20
> Attached is an initial version of the mwl8k driver for Marvell 88w8xxx
> PCI/PCIe wireless parts (against 2.6.27.1).  This version was written
> and tested against the 88w8687 (802.11b/g), but it shouldn't be hard to=

> extend the support to other parts in the 8xxx series, since the firmwar=
e
> interface is very similar between parts.

I guess 88w8xxx will not include 88w8618 on day, will it? That's an
ARM-based SoC with integrated b/g-WLAN. Are there chances to reuse parts
of this driver for that controller or are they totally different?

We are still stuck with a 2.6.16.16-based BSP kernel because
implementing proper Linux support based on mainline would mean loosing
WLAN support - the BSP is GPL'ed, but the WLAN driver is only a binary
blob for 2.6.16.16...

Jan


--------------enigCF8CEF99ADDC709F51CA05F5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkljVTEACgkQniDOoMHTA+m/QwCdEe5oe4erW+kims0PVHYNtyeI
TRsAn2AIwPJtW02z+8s1gOOvASrLArcq
=KvCO
-----END PGP SIGNATURE-----

--------------enigCF8CEF99ADDC709F51CA05F5--
