Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37223 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751525AbdKWB4G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 20:56:06 -0500
Message-ID: <1511402153.14687.17.camel@decadent.org.uk> (sfid-20171123_025610_274085_882418DC)
Subject: Re: pull-request: iwlwifi firmwares update 2017-11-15
From: Ben Hutchings <ben@decadent.org.uk>
To: Luca Coelho <luca@coelho.fi>, Kyle McMartin <kyle@infradead.org>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>,
        linux-firmware@kernel.org,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Date: Thu, 23 Nov 2017 01:55:53 +0000
In-Reply-To: <1510767968.4011.124.camel@coelho.fi>
References: <1510767968.4011.124.camel@coelho.fi>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-fc/6oTeKkvyG8Y0dzvut"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fc/6oTeKkvyG8Y0dzvut
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2017-11-15 at 19:46 +0200, Luca Coelho wrote:
> Hi Kyle,
>=20
> This pull-request supersedes my previous one.
>=20
> I have updated the firmwares for the 3160, 3168, 7260, 7265D, 8000C and
> 8265 devices and added new FW versions for 8000C, 8265 and the new 9000
> series.
>=20
> Please pull or let me know if there are any issues.

Pulled, thanks.  However, I had to a fix up a typo in WHENCE afterward.
 In future, please remember to run 'make check' to validate it.

Ben.

> Cheers,
> Luca.
>=20
>=20
> The following changes since commit bf04291309d3169c0ad3b8db52564235bbd08e=
30:
>=20
>   WHENCE: Add new qed firmware (2017-10-09 18:03:26 +0100)
>=20
> are available in the Git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.gi=
t tags/iwlwifi-fw-2017-11-15
>=20
> for you to fetch changes up to 85313b4aa4ef0c2ce41bbd0ffdb9b03363256f28:
>=20
>   iwlwifi: add firmware version 34 for new 9000 series (2017-11-15 19:21:=
16 +0200)
>=20
> ----------------------------------------------------------------
> iwlwifi: add new FWs for 9000 series and update other ones
>=20
> * Add FW version 33 for 9000 series;
> * Add FW version 34 for 8000, 8265 and 9000 series;
> * Update FW version 17 for 3160, 7260 and 7265;
> * Update FW version 29 for 3168 and 7265D;
>=20
> ----------------------------------------------------------------
> Luca Coelho (5):
>       iwlwifi: update firmwares for 3160, 3168, 7265D, 8000C and 8265
>       iwlwifi: update firmwares for 3160, 3168, 7260, 7265 and 7265D
>       iwlwifi: add new firmware version 34 for 8000C and 8265
>       iwlwifi: add firmware version 33 for new 9000 series
>       iwlwifi: add firmware version 34 for new 9000 series
>=20
>  WHENCE                            |  32 +++++++++++++++++++++++++-------
>  iwlwifi-3160-17.ucode             | Bin 918268 -> 918268 bytes
>  iwlwifi-3168-29.ucode             | Bin 1036372 -> 1036372 bytes
>  iwlwifi-7260-17.ucode             | Bin 1049340 -> 1049340 bytes
>  iwlwifi-7265-17.ucode             | Bin 1180412 -> 1180412 bytes
>  iwlwifi-7265D-29.ucode            | Bin 1036528 -> 1036528 bytes
>  iwlwifi-8000C-31.ucode            | Bin 2309768 -> 2310116 bytes
>  iwlwifi-8000C-34.ucode            | Bin 0 -> 2448976 bytes
>  iwlwifi-8265-31.ucode             | Bin 2303024 -> 2307104 bytes
>  iwlwifi-8265-34.ucode             | Bin 0 -> 2440780 bytes
>  iwlwifi-9000-pu-b0-jf-b0-33.ucode | Bin 0 -> 2632620 bytes
>  iwlwifi-9000-pu-b0-jf-b0-34.ucode | Bin 0 -> 2677620 bytes
>  iwlwifi-9260-th-b0-jf-b0-33.ucode | Bin 0 -> 2637216 bytes
>  iwlwifi-9260-th-b0-jf-b0-34.ucode | Bin 0 -> 2677772 bytes
>  14 files changed, 25 insertions(+), 7 deletions(-)
>  create mode 100644 iwlwifi-8000C-34.ucode
>  create mode 100644 iwlwifi-8265-34.ucode
>  create mode 100644 iwlwifi-9000-pu-b0-jf-b0-33.ucode
>  create mode 100644 iwlwifi-9000-pu-b0-jf-b0-34.ucode
>  create mode 100644 iwlwifi-9260-th-b0-jf-b0-33.ucode
>  create mode 100644 iwlwifi-9260-th-b0-jf-b0-34.ucode
--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson


--=-fc/6oTeKkvyG8Y0dzvut
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAloWKqkACgkQ57/I7JWG
EQl5ow/+NcB6iuI2muMRRojqOw+IC22m0Exwi2shYOn+dyLTSz/YmwePFjIMIx0u
EX5pzaxqKtrFnwu8Pk7FwKs9itZxIekWxOw8k0sFpMFDCSX877jSKD2h1AwWlnRS
piMrt1GvtV4FxULiA1TVW5oehzCeceRAHrHDHGhDeJsma11vGs1XjWlyeWIqn1uZ
83Uv4pWSuQ8V0gPI7EEdyIAk1Yf8Va/I52pGkLyScqx2kfQGN7Cm/ginX0ioPF5/
pC3eQ6zCP4h6QkL3PLo2wkmQpTvgiiR5BX8Wu8FO6EocppTBe8TURcN25MYZv0Yb
KVxe9RgdhZR9wvvLhxsHgAYKh4eebU9MEa1+jck4SH5QSzgtVFBx835KgR6rJVb7
hfCv9qgjNHH680QRwg2MRkKMDYsKCa7920kkxQA8JQmjQ/Lc6WqgGyhQ+DQ7ne6Q
JaZtprMH2Y/Xtp2tpBStTy97DPzsrHpWBx6EjYkVIozycPumEHqdf7/QTY29RjCM
KAvW7IRX8/dgEYpQPpu0Knbsfbl9JndQ9B12ujHzkcJs28xGVfNB0VN174ovRnWW
kzcG0Gxp8w8q1Px1e8WUx0EyZy+xwNP4Mx8wviLn6bu4FOLl7BiKOilEhPJpTuRv
GUbs9Sumy2V8eID+cNtSoitu3BsV0K1b55U9PMy4gu/LRO7VN24=
=xpw5
-----END PGP SIGNATURE-----

--=-fc/6oTeKkvyG8Y0dzvut--
