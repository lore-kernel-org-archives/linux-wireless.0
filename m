Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54932 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754796AbbK0R2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 12:28:37 -0500
Message-ID: <1448645306.27159.74.camel@decadent.org.uk> (sfid-20151127_182846_747633_BAC19BAA)
Subject: Re: [PATCH 0/2] brcm: firmware for new device and update
From: Ben Hutchings <ben@decadent.org.uk>
To: Arend van Spriel <arend@broadcom.com>, linux-firmware@kernel.org
Cc: linux-wireless@vger.kernel.org
Date: Fri, 27 Nov 2015 17:28:26 +0000
In-Reply-To: <1448619235-31323-1-git-send-email-arend@broadcom.com>
References: <1448619235-31323-1-git-send-email-arend@broadcom.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-P1zp38AnnKmo7SD3mBDt"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-P1zp38AnnKmo7SD3mBDt
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-11-27 at 11:13 +0100, Arend van Spriel wrote:
> This series add firmware for new BCM4371 device and an update
> for the BCM43602 which solves hibernate issue.
>=20
> The series applies to the master branch of the linux-firmware
> repository.

Applied, thanks.

Ben.

> Arend van Spriel (2):
> =C2=A0 brcm: update firmware for bcm43602 device
> =C2=A0 brcm: add initial firmware for bcm4371 11ac wifi device
>=20
> =C2=A0WHENCE=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0|=
=C2=A0=C2=A0=C2=A01 +
> =C2=A0brcm/brcmfmac43602-pcie.bin | Bin 634267 -> 635449 bytes
> =C2=A0brcm/brcmfmac4371-pcie.bin=C2=A0=C2=A0| Bin 0 -> 623448 bytes
> =C2=A03 files changed, 1 insertion(+)
> =C2=A0create mode 100755 brcm/brcmfmac4371-pcie.bin
>=20
--=20
Ben Hutchings
Power corrupts.  Absolute power is kind of neat.
                           - John Lehman, Secretary of the US Navy 1981-198=
7

--=-P1zp38AnnKmo7SD3mBDt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVliSuue/yOyVhhEJAQo0Ig//eMLgBFo3oFImpgSnqabCcA+6P9W7dNB/
+LHmZpQE3/G6kONwT6SOVkDSol5apaDQYH6RaGZwOjuiKSBKEM+wn4ibs+/peXoY
ApA72871SsN1E5ioTxuw+W2IlvCd+5Nx96d+eN7o+sMmSq1s7b1Uo0gXek6hUoAW
utPO3McPUiONIYAXRNNhIB1NNf9iyHh8QjhDgu9aTHmReQmzXg31eVhUr3IV2zKz
7fgLfMCMDoR/HLEo/JPmKyXivu/R5079+iJwVxB4u9fNtu52UwSbdrQ51WgMdNz4
n+fZR5OsEcKuX0r6fzQR04YGRK7pKRzqKyW5jPiGm8sO4tRRhDJjns+K/G1HFA4e
scNeFdGz8NnR27Sqfs1gGOhCiXniCIZFo3hecbxHxC5tV07UQjm6nxQ9XB/J6Dqf
ZcoCkjekSVzP4bWCp5NwGaSaDRi4GATuser/uFEryTexhfcYBddzc+8gwOcQtQa4
YbUbY4pIVftTERjqrcyvwH/yQOS91vk//kpAuVA0QnOk2x4PtM6+HcHwYYrcBnjh
zdLM+h8qXDyig//dSCJQBbFKDOg5k3SEJkZonDPdsM0iV6mK6PMvGz1Mzxx/aZYC
xbvF0lSIUM7C8JW2E11nzLa+92kdj6wGILoceFIHL8GoVz9Xxf7piBdp/UIHfMp3
qRrI70yfmW4=
=eINJ
-----END PGP SIGNATURE-----

--=-P1zp38AnnKmo7SD3mBDt--
