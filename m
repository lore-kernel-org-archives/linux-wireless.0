Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44411 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755356Ab2GSBrD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 21:47:03 -0400
Message-ID: <1342662412.11373.81.camel@deadeye.wl.decadent.org.uk> (sfid-20120719_034721_646473_BFCF4C50)
Subject: Re: [PATCH] linux-firmware: add zd1211rw firmware
From: Ben Hutchings <ben@decadent.org.uk>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>,
	linux-wireless@vger.kernel.org,
	David Woodhouse <dwmw2@infradead.org>
Date: Thu, 19 Jul 2012 02:46:52 +0100
In-Reply-To: <1342543168-6666-1-git-send-email-xose.vazquez@gmail.com>
References: <1342543168-6666-1-git-send-email-xose.vazquez@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-qNAiGO3/2rOKqzpa/PQL"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qNAiGO3/2rOKqzpa/PQL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-07-17 at 18:39 +0200, Xose Vazquez Perez wrote:
> firmware for zd1211rw, ZyDAS/Atheros ZD1211/ZD1211B/AR5007UG wireless dri=
ver.
>=20
> Cc: Daniel Drake <dsd@gentoo.org>
> Cc: Ulrich Kunitz <kune@deine-taler.de>
> Cc: linux-wireless@vger.kernel.org
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
> ---
> README
>=20
> This distribution contains the firmware files for the
> ZD1211 chip, which is used in WLAN USB sticks. Copy the zd1211_* files to
> /lib/firmware/zd1211, where they can be loaded by the rewritten
> zd1211 driver.
>=20
> The files are generated from C header files distributed in the
> original ZyDAS ZD1211 driver under the GNU Public License.
>=20
> The full source of the original ZYDAS driver is available from
> http://zd1211.wiki.sourceforge.net/VendorDriver
>=20
> The GPL-licensed header files used to produce the firmware blobs are also
> present in this distribution.
[...]

Not in this patch, though.

And if you're referring to C sources with arrays of bytes - this is not
really the preferred form for modification, so the blobs cannot be
distributed under the GNU GPL.  This is surely a mistake by the
copyright holder, but they need to clarify the licence that was really
intended for the firmware.

(There were some in-tree drivers where this same mistake was made, for
which you will see in WHENCE: 'Allegedly GPLv2+, but no source visible'.
These are kept in linux-firmware to avoid regression of those drivers.
The unclear licence does pose some legal risk, but hopefully no more
than previously existed with the blobs embedded in the kernel source.
However, I don't see any reason to accept bogus licence information for
blobs that were not previously included in the kernel source.)

Ben.

--=20
Ben Hutchings
DNRC Motto:  I can please only one person per day.
Today is not your day.  Tomorrow isn't looking good either.

--=-qNAiGO3/2rOKqzpa/PQL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUAdnDee/yOyVhhEJAQrIBxAAhcsrPIjzd9CbmjPnPwdakjws13AmQwMQ
7fq09ppjYpLBAmuXgo+cNGdJVW1SLP1sFAqUcPDJ5Lth3xMU3oUvI+Z7d6++dCBU
+XNVJlWKmEAIwxZRJfgmFshmmEVLrclZmQ7z2gJLZ30Y4p2zKvMhktx9+9tMgVU1
Wk3d9/FVaGFdw+EZiKKFXoVDCT6L7uyWGH87QIai1M9BxMGOXI6aRij5pXMYeGSb
n790MGnlwA1LG6WwbMPzg2P6+N2qzLSoN9uEDPyyvRFbm3joBacXdjCnqSZ8gjBr
mkPE18ARXjD9YkPuS86uIwHF5nstGMW2/tl/yV+B9qDIsPGfIHpgroY0vWdTrVn5
/L/nYz3H/1wUr7EBevO49Qnpx5bkFb1vpSTUfgCE9koefaxHJ04BKHDGTIDhJRu6
jIa57b4uJeRZRNRODWA7/2Ko6CMlMo1XTNXjbQeKc5NhpYWm6tGh1nljnADV8rUK
eatANO207auR0Haq8LQ66DL52pvZb1s4UKYZjcga/StTzaIuqSQ65ERp6gy4S3S2
X/pdaPZfmuZ4ORi2choCrIr0UNYzWqgYFuEtjqDKmxhqlhQcaq/kE9sDXhEHXHHW
BLFxrAHDSgU/qzNjqhsVUCcM2IW0erQvlNUwdyic1gMnDEG+txIlw0bJLAyvjjcp
e7AgjBbNL6s=
=W3VK
-----END PGP SIGNATURE-----

--=-qNAiGO3/2rOKqzpa/PQL--
