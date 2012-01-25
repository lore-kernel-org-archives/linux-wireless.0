Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56077 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753448Ab2AYELx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 23:11:53 -0500
Message-ID: <1327464707.5400.74.camel@deadeye> (sfid-20120125_051157_153223_9337285F)
Subject: Re: linux-firmware pull request
From: Ben Hutchings <ben@decadent.org.uk>
To: Tim Gardner <timg@tpi.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 25 Jan 2012 04:11:47 +0000
In-Reply-To: <20120123170745.314D4207D2@salmon.rtg.net>
References: <20120123170745.314D4207D2@salmon.rtg.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-71tur5SrAuSOxvosrody"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-71tur5SrAuSOxvosrody
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-01-23 at 10:07 -0700, Tim Gardner wrote:
> The following changes since commit a2995d38c234e3d767df7223d84a0f33a1a249=
97:
>=20
>   firmware/isci: update to oem parameter format v1.3 (2012-01-05 13:21:40=
 +0000)
>=20
> are available in the git repository at:
>   git://kernel.ubuntu.com/rtg/linux-firmware.git iwlwifi

Pulled and pushed out, thanks.

I also updated the licence text for iwlwifi to match that in the
tarballs you pointed to.  It was just a change to the copyright dates,
but please do check for any such changes.

Ben.

> Tim Gardner (5):
>       iwlwifi: add new firmware for 105 devices
>       iwlwifi: add new firmware for 135 devcies
>       iwlwifi: add new firmware for 2000 devices
>       iwlwifi: add new firmware for 2030 devices
>       iwlwifi: add new firmware for 6000g2b devices
>=20
>  WHENCE                  |   15 +++++++++++++++
>  iwlwifi-105-6.ucode     |  Bin 0 -> 689680 bytes
>  iwlwifi-135-6.ucode     |  Bin 0 -> 701228 bytes
>  iwlwifi-2000-6.ucode    |  Bin 0 -> 695876 bytes
>  iwlwifi-2030-6.ucode    |  Bin 0 -> 707392 bytes
>  iwlwifi-6000g2b-6.ucode |  Bin 0 -> 679436 bytes
>  6 files changed, 15 insertions(+), 0 deletions(-)
>  create mode 100644 iwlwifi-105-6.ucode
>  create mode 100644 iwlwifi-135-6.ucode
>  create mode 100644 iwlwifi-2000-6.ucode
>  create mode 100644 iwlwifi-2030-6.ucode
>  create mode 100644 iwlwifi-6000g2b-6.ucode
>=20

--=20
Ben Hutchings
Horngren's Observation:
                   Among economists, the real world is often a special case=
.

--=-71tur5SrAuSOxvosrody
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATx+BA+e/yOyVhhEJAQpXyg//Y75zNGPTElAq7CgCyH8KnvedBA55Jww4
KbE8+MVcRMyY+XhLakbZX3yKySco+Ke0AgxwLeQd0aelWLM9G/oY4ef68pnjpMrN
m5V3sRzk4OwJPk/PcUpbMnCNuASIGWfjHcrLhwOPqQvyM9LNy75XSJLsJDj040SA
QwZipkGN2ARAUWF0pl2Nrg9QxlT87iK33Q2tIwD6/dhWtKr6UNyvt4UTi3S1RbCx
JxPK5GVF7pjSNWXUhtnqGEY9CLFCKD+Yy0Hj03Q1a4HpkWU9f6FpCSXUyTVEO+4+
Pghd9E/Kw8Y0YcA0rKazBpLARxiJnKqh6RprNEttItuqD99p/cgoQ+DjNpObYzRL
cOHGsBvDa/AT15Gl5R/GPAt5zsuH9aBW1Pdsvg+zy/FRVmD9rfmP0VfnKY24jGuF
Abs3CSisZHEo0z9qeDSB+N3qCZN1QGr7FEeItnHIjTMA6bIuRMXDDIdmoLUSHx32
PXPAa/bXb84iKwLEoO7blYyuUiXWe2Nxxj9mH+c/P9x5akjL2A9DLtMWb2/A+23u
V4jHvHuweRBop0fRDOGPYuB7DHJcEJF77rY1Bhop77ZAn4/LM6aASiASgcHKUoZG
treuSVBy1ThX9WO8nAsRFKbxsdssqkBow7b7uYLgRVrcP+XdJoxRpwXrU8zrYD3p
tdwB6/S55MI=
=JOan
-----END PGP SIGNATURE-----

--=-71tur5SrAuSOxvosrody--
