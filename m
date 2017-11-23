Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40970 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752769AbdKWOBH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Nov 2017 09:01:07 -0500
Message-ID: <1511445655.14687.65.camel@decadent.org.uk> (sfid-20171123_150111_445783_41B32492)
Subject: Re: pull-request mwifiex-firmware 2017-11-23
From: Ben Hutchings <ben@decadent.org.uk>
To: Ganapathi Bhat <gbhat@marvell.com>,
        "linux-firmware@kernel.org" <linux-firmware@kernel.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        James Cao <jcao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Karthik Doddayennegere Ananthapadmanabha <karthida@marvell.com>,
        Brian Norris <briannorris@chromium.org>
Date: Thu, 23 Nov 2017 14:00:55 +0000
In-Reply-To: <178d86c104de49e589a6ac10930d1b27@SC-EXCH02.marvell.com>
References: <178d86c104de49e589a6ac10930d1b27@SC-EXCH02.marvell.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-vhO8gF5ntqJJjfWd9Fkb"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vhO8gF5ntqJJjfWd9Fkb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2017-11-23 at 13:23 +0000, Ganapathi Bhat wrote:
> The following changes since commit 47afd9950fbcadeb7cefc093b21d6123bdc76f=
79:
>=20
>   linux-firmware: add Marvell USB8997 firmware image (2017-05-02 12:28:34=
 +0530)
>=20
> are available in the git repository at:
>=20
>   git://git.marvell.com/mwifiex-firmware.git master
>=20
> for you to fetch changes up to db3e1855ea46bc1a22b8bbecb400c2909c551cf5:
>=20
>   linux-firmware: update Marvell PCIe-USB8997 firmware image (2017-10-31 =
20:49:53 +0530)
>=20
> ----------------------------------------------------------------
> Ganapathi Bhat (2):
>       linux-firmware: update Marvell PCIe-USB8997 firmware image
>       linux-firmware: update Marvell PCIe-USB8997 firmware image
>=20
> Xinming Hu (1):
>       linux-firmware: update Marvell PCIe-USB8897-A2 firmware image
>=20
>  WHENCE                        |   4 ++--
>  mrvl/pcie8897_uapsta.bin      | Bin 820212 -> 836540 bytes
>  mrvl/pcieusb8997_combo_v4.bin | Bin 597136 -> 622532 bytes
>  3 files changed, 2 insertions(+), 2 deletions(-)

Pulled, thanks.

Ben.

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson


--=-vhO8gF5ntqJJjfWd9Fkb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAloW1JcACgkQ57/I7JWG
EQmlKw//bbanCeyKuFrQwmv9rAgpUTX3t+inBpoC2KSrc4jgo8KglKzQXT8KYRQP
HxdnbIvWJISjfGDwgcIGxO0fYiT7uD+NFtVLQhxmDo5V3HQhsD+E4Sc14MqGXTFl
tXJiVX6Yxzbcmx4F6kr4lNrEyo4T5TDBkdQg2b8gPVt8+CDU/+PRZQkcsakXwcgx
m2jAvGI3kEr3tKbVxPhHjXV+NKGkOF30r4uFi8BSXEq5Q7+f68O06XKhXELSaI/C
rmSeeBKCsHGfdtbXkqf2ReZF5NvLJbwRhlaTixZmcEmlY6HKvlaq4LmBbm5BM+3T
RhD6w+Uu+mftUUZY0H9F/gCCNdNP+NWTm8tgIio0t6r8CC4qOPiemXG1xsSFXYi4
PhhfZTIiI4JSenclW5Tli2L1hqAS7/zKyPGsUmv0bZATjNoK+1j07aEdSrN2L4w7
7gGXUSSL0CvqqUckAys6bzX6LJZ+B8AO3PpNut7drWXjIhi5TJyHQii981HJ0XRq
fFrFvykiMXjDgWFpG1oRFw4ZBJqYhXvIy+xqklYsaJfjCEGHGpKOKR6dcu5wGNis
aiw8zQbwppeBa5OJBcscexU7SlyQhivmhv/5sc8HIm6zIQpKSU6BFuo8q1tZZmXA
K4EpoQRO57bQN8WTNbxDmZLsRM0aahYFov2Fmv7wJJrFgPK9p0s=
=OS1S
-----END PGP SIGNATURE-----

--=-vhO8gF5ntqJJjfWd9Fkb--
