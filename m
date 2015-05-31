Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:44944 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758373AbbEaSCu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 14:02:50 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [ANN] -14.ucode is available
Date: Sun, 31 May 2015 18:02:46 +0000
Message-ID: <1433095362.28501.9.camel@intel.com> (sfid-20150531_200254_864624_FDD0AAF0)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-uJMdeFsKta7XezAPIVUu"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-uJMdeFsKta7XezAPIVUu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The new -14.ucode is already available in [1].

Since you'll need iwlwifi-next tree [2] to use it, I still don't send
the pull request to mainline linux-firmware.git. -14.ucode just finished
its validation cycle, but experience shows that lots of fixes still get
merged after the validation cycle  based on feedback from the field. So
you are more than welcome to give it a try and let us know how it went.

For those who don't want to use iwlwifi-next, you can use iwlwifi's
backport tree that has been made available here [3]. You can take either
the master branch, or the Core11 branch which is the stabilization
branch that matches -14.ucode.

Thank you

[1]
https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware.git/

[2]
https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-next.git/

[3]
https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/backport-iwlwifi.git/

--=-uJMdeFsKta7XezAPIVUu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJVa0zCAAoJEC0Llv5uNjIBm/IP/2GZ4vp5Sjk3o2h9QpcUlOTy
VgtA8Y57tz78Hip5JEUHjySWKvgBra9sJhYCXC0JSqCBbYWGc/A8TwJES+q9RzpY
ZhPN1eu1YWZ5bCf9BAhe0sKSD4wsC7f5C3v2B+ep27DMsvdfayuM9k0EbnLfgO11
WgKk0T4WWlSnu2jd2d0XBI+0cwW5V7UcUse0VgiYaYk0CKkNfQPeAou7OPHpfEtW
IqcD+xb0iIwD1E2qZADqpi1TEZZ38EqVLpUNmRqSWVw19IwzrKtrYVHRlf4cn2eD
E8Hgg98oiGDnBPlVTGnDWcNAqmE2kQZXS/TBOOwzcUHVe7GRvE3LGGOFv9mwReEm
BpTc9UOubZIB2NDHfF43raF7RTyCkayj1LjDYNr6TY5P/X7sd/OqCe/wRS1+tof2
zbbRX4lmvdK4lRJJ+fngxb305D8uVOpGrzaAtpVQYMEDuhIQiHMkC4VsuLX4UUeU
CH62l42ECV7ei1h1hxFTvPPSt/WwYYo0R/6BhX2opynON+f+UmECgHiFFO3VVMY6
x0hp3UxJnD2WDu4Qh1+IsjFrgftMdRKSEV7hhARWajO3E62Qt1SBOD9AVqZduTX4
Yp47wl+ZUO2T94XrW52ysk7pS7lriVlrqFveJKyDwVYTYglKoLzYzY/23aW83Rfk
bfGnz8bHOxnSIkd4NgOm
=iUV2
-----END PGP SIGNATURE-----

--=-uJMdeFsKta7XezAPIVUu--
