Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36712 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750828Ab2HPCoY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2012 22:44:24 -0400
Message-ID: <1345085046.824.240.camel@deadeye.wl.decadent.org.uk> (sfid-20120816_044503_698225_44E41E9C)
Subject: Re: [PATCH] iwlwifi: update firmware for 6205
From: Ben Hutchings <ben@decadent.org.uk>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Woodhouse <dwmw2@infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 16 Aug 2012 03:44:06 +0100
In-Reply-To: <1344011998.4482.13.camel@jlt3.sipsolutions.net>
References: <1344011998.4482.13.camel@jlt3.sipsolutions.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+zgPUPUo0WhDssC6XZho"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+zgPUPUo0WhDssC6XZho
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-08-03 at 18:39 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> version 18.168.6.1
>=20
> This adds support for WoWLAN and P2P, both of
> which are still experimental in the driver.
>=20
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  WHENCE                  |    4 ++--
>  iwlwifi-6000g2a-5.ucode |  Bin 444128 -> 0 bytes
>  iwlwifi-6000g2a-6.ucode |  Bin 0 -> 677296 bytes
>  3 files changed, 2 insertions(+), 2 deletions(-)
>  delete mode 100644 iwlwifi-6000g2a-5.ucode
>  create mode 100644 iwlwifi-6000g2a-6.ucode
[...]

linux-firmware.git is supposed to support all released kernel versions,
as the directory-per-version scheme doesn't work that well (you need a
new directory/package for every stable update and every different
flavour installed).  You may notice we don't even have tags indicating
addition of support for new kernel versions; we never really have the
complete set anyway.

So we must *not* remove old files unless there are no released kernel
versions that refer to them.  In this case I backed out the deletion
when applying this.  Please only add files in future, unless you're sure
the old files are unreferenced.

Ben.

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-+zgPUPUo0WhDssC6XZho
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUCxedue/yOyVhhEJAQo67w/+K08r/Xy1WAdDvB7PJTvRXcPuwU3TgH4D
GxH4MtceElqPYHGEe881XrV3gGunOc3SQqA3oXEPE443D2y9/vi44AMihBwGKCGX
JkSnnNt17LBWebuRVHlAUyZJ+hufww58B69Ya6kSlwycO0Jhz3TN8rQ7+H055OcN
huiqASubaRmrHv0ih3gHoB4NsXAGl2zz21iSXdiisghvSNP4A68pM/e5gkBDOME3
cJ3fJdzrgRa5S+faAO5UphTRaHZ+eAVKI0xb0caO6tS3KTFkmWCNdgMW7ZwwBKVZ
4hDHA9fIjkfH1UJnfBkhCfRjgb99Fxw4Lolr7t02Uke5alXVj3En98vESEshCaH4
BkicbXzuiasHvboCoFT5gva8Bev5v8xAcYh+lqaynougDFs5QryqdSwIEaXlG4UV
7Cd7/mrlbYNNSvSi3YZo3B3DSYqk3Np3JCQks4DwLtsYIIjHpiiNb2mFg40XIbYW
NSSfcfbdv6ENLBZblSlg9AScSnN9VD/jd3aF+Zt7MBuq7UWrjbZNHxn8By7MBiut
O8g2nS4Jr8GWbJj3FIXIxB4LUyDtA1gxOhmU1a/DyXvcjXwe4N7IUe0FIFDoTSS7
79vvqWRPlXS7vxwpqm90QcYSpS74IaQVQ5AehjgZ6tDmiLWJYzBNvRnYt8CbECIV
j2l8yehPkKM=
=O72v
-----END PGP SIGNATURE-----

--=-+zgPUPUo0WhDssC6XZho--
