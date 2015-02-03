Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:32049 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161101AbbBCVeR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 16:34:17 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "Zhao, Yingying" <yingying.zhao@intel.com>
Subject: [ANN] new firmware for Intel 3160 / 7260 / 7265 / 7265D devices -
 Core9
Date: Tue, 3 Feb 2015 21:34:12 +0000
Message-ID: <1422999252.29907.18.camel@egrumbacBox> (sfid-20150203_223420_470497_C55A5524)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-mf3cFsaJAsTcdE2Ztk7f"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--=-mf3cFsaJAsTcdE2Ztk7f
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all,

Intel released a new firmware for its WiFi devices listed in the
subject. This release includes lots of bug fixes along with new
features. The filename is iwlwifi-XXXX-12.ucode and will be usable on
kernel 3.19 and up.

We also release release a re-spin of iwlwifi-XXXX-10.ucode that includes
a bug fix that has a major impact on users.

Both firmware are available right now in our linux-firmware clone [1].
Note that I haven't yet updated the wiki [2] since I am still having
issues with permissions, but that will hopefully be fixed soon.

Pull request to the official linux-firmware will follow.

Enjoy, and as always, feedback is appreciated!

[1] https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/linux-firmware.git=
/
[2] https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi#firmware

--=-mf3cFsaJAsTcdE2Ztk7f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJU0T7UAAoJEC0Llv5uNjIBLZQP/j6eu6UUg/LPfFA4a+rUQnye
glitMUaEla3l6fR8P0jsltrl1vjUdv0Bj3v+9ZgL1ugKbht2yHQE1jiJKttsWJ4/
iRRyOanFoJUtKWCYbmMSRB4iytQoilaUCRdi96ftsNoziwsN4EV35YoAMCisArco
mrSeNLrMiYkHlGFRh9dxyUEIAsdNovY4W+nqYaNbD3qlt8Eh/cMieeeiH2GXXPay
xwc4UmjTsaP1ymy4/8bgyaTcW5saJi7mELKJ2ke0S4UITYgNGwKVG4zPV4g12Hrq
lGrgMKGLEKSHZ/gkp1wYsBWT+3s8Rjj6qnkBmvI0kSwNiYDSwfgO52+dU6Y5Lpjv
/IaQkmkP3o2+r1d2RrD0KtlVso+JGKwvaS7JGQDb8+8oR/KLm3GuhNQ5VaCvdCdS
Y8bvxxHrjvp4Twr7zfw8cYGiC0KPVTZFGTQSCNmEwCNGZPNJQrmsuYTR4HqI39S6
2lEL73wS+EZEn3F+Mpe+MtLhZL+hhsqVCMrlzcz6glDlte0oPvkdvrJz70s2hzx0
J0awfxpwQPD7oKokT+mBd6lyspgNqiAMe0akojco37OIOe8Dd6M9HxCRYmWM4lxh
nu10/t2lO6Gr8NgdWMjbFz365KYA8KdbBljDLVxMy/EovIj+kk2QQUxAFQ/IhOtP
Gy+l5zV2Q6SlGyKkQBew
=2djR
-----END PGP SIGNATURE-----

--=-mf3cFsaJAsTcdE2Ztk7f--
