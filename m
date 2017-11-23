Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37091 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751525AbdKWBhg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Nov 2017 20:37:36 -0500
Message-ID: <1511401044.14687.6.camel@decadent.org.uk> (sfid-20171123_023739_608934_5CD7FB50)
Subject: Re: pull-request mwifiex-firmware 2017-10-31
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
Date: Thu, 23 Nov 2017 01:37:24 +0000
In-Reply-To: <99832be6bb804911a374c85d1865d0b2@SC-EXCH02.marvell.com>
References: <99832be6bb804911a374c85d1865d0b2@SC-EXCH02.marvell.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-8z9o70C7omSOB0ESpUsR"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8z9o70C7omSOB0ESpUsR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2017-10-31 at 15:34 +0000, Ganapathi Bhat wrote:
> The following changes since commit e0494e95192ac5329989f4d128cf95c417d618=
cc:
>=20
>   linux-firmware: update Marvell PCIe-USB8997 firmware image (2017-08-01 =
23:55:30 +0530)

But that commit is not in linux-firmware.git.

> are available in the git repository at:
>=20
>   git://git.marvell.com/mwifiex-firmware.git
>=20
> for you to fetch changes up to db3e1855ea46bc1a22b8bbecb400c2909c551cf5:
>=20
>   linux-firmware: update Marvell PCIe-USB8997 firmware image (2017-10-31 =
20:49:53 +0530)
>=20
> ----------------------------------------------------------------
> Ganapathi Bhat (1):
>       linux-firmware: update Marvell PCIe-USB8997 firmware image
>=20
>  WHENCE                        |   2 +-
>  mrvl/pcieusb8997_combo_v4.bin | Bin 620800 -> 622532 bytes
>  2 files changed, 1 insertion(+), 1 deletion(-)

There are three commits in this repository that aren't in linux-
firmware.git, not one.  Please either:

1. Send a pull request listing all the commits (the  <start> parameter
to git request-pull should be something like "origin/master"), or
2. Rebase this branch to include only the commit you want me to pull,
and send a pull request listing that.

Ben.

--=20
Ben Hutchings
When in doubt, use brute force. - Ken Thompson


--=-8z9o70C7omSOB0ESpUsR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAloWJlQACgkQ57/I7JWG
EQl1kQ/+OwXz8Dyi6Cx0UWpaoToIe6UMzWs27IpBNZ4IKOCrBqB90MuL+YNRV9pC
mzO0p8Xx8luXoI3ls4g1drOCuH883A7yQxVRrkDpxJNkGgtYJaZq4o+Q0wH+U18Y
sJQywIYcayXUT3SpTldDbWzcTXibC78Fu4qsMVca/5If6u4iRhTjoE2+YUJCHuk/
JdYJHmk3utCD1iAiIvUGFSXarP1mze6qQ9gFmnihau6oEeZMeA05AIkm32P6NxhL
0lRfV5LtzRx71x4354xrYm3tm69RLS5FdD/BLaQ+T0kN1rZsTbmHn6nMxBlRU1jo
UplpapTDtSTQ1mPgX72jSj4dUycKYNO9uPD9h4PyTtGSGjI3wpyVKvL1ivsrm+B0
yOihvGRx9Dt1kxjZHM6tToy9YiZEEAalKW39sSByztEhw1/ep7E0xTAZVDMgRx+1
O9L2H+Zt2IhhdMGxdMzmyDcnu4FVJb9+p7W6EOQeXUypNXeIJHXxntnztbgfyw69
iG346fH7K/QZAJw6qv7ZuogLA5tE9wD51rRDjPKevwOewGbyxl9R4meEzLk13mWO
3tbYzIiv+WtYh0//wTsTpZYzz7Gl7tn4J0NhnDAE+P+NN5xu3ODtWXNfhnZznnFJ
MjMKcp1DmaaNvEEhCEfLJAkjEJ9yp1lR+TlxTNtMIbkB32Q6m1Q=
=/zt3
-----END PGP SIGNATURE-----

--=-8z9o70C7omSOB0ESpUsR--
