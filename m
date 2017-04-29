Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60043 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1162241AbdD2GXt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Apr 2017 02:23:49 -0400
To: ath9k-devel@qca.qualcomm.com,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org
From: Oleksij Rempel <linux@rempel-privat.de>
Subject: Search for devices with Xtensa cores
Message-ID: <1fdab9d5-d8c6-88dc-38ac-2948e5fa74ec@rempel-privat.de> (sfid-20170429_082357_591548_93DFBE0F)
Date: Sat, 29 Apr 2017 08:23:09 +0200
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="5tWAEL9kXGPSbGEjDrUQKCIva33G2Ndwj"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--5tWAEL9kXGPSbGEjDrUQKCIva33G2Ndwj
Content-Type: multipart/mixed; boundary="dhnEQpu4lBBe4A3BA0tEVHE0Sfvb8KXJ5";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: ath9k-devel@qca.qualcomm.com,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 ath10k@lists.infradead.org
Message-ID: <1fdab9d5-d8c6-88dc-38ac-2948e5fa74ec@rempel-privat.de>
Subject: Search for devices with Xtensa cores

--dhnEQpu4lBBe4A3BA0tEVHE0Sfvb8KXJ5
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hallo all,

short version:
I'm looking for devices which use Xtensa and GCC/binutils patches used
to provide support for this devices.

long version:
this year started with inclusion of open-ath9k-htc-firmware to debian
*main* repository. As first we started to getting advantage of regular
compile tests. See results here:
https://tests.reproducible-builds.org/debian/rb-pkg/unstable/i386/open-at=
h9k-htc-firmware.html

Most of the problems which we currently get, are related to gcc xtensa
compiler.
In details: device specific patch set is used to provide our own
gcc/binutils version because Xtensa don't really have defined CPU cores.
As result, upstream compiler developers will never notice if some thing
will brake this patch set.

My hope is to provide upstream gcc support for commonly used by linux
community Xtensa cores.

So far i know about:
- Atheros ar9271 is identical with ar7010, LX2.1.0
- Atheros AR6002 Xtensa LX??
- Atheros AR6003 Xtensa LX??
- Atheros AR6103 Xtensa LX??
- Espressif ESP8266 Xtensa LX106

--=20
Regards,
Oleksij


--dhnEQpu4lBBe4A3BA0tEVHE0Sfvb8KXJ5--

--5tWAEL9kXGPSbGEjDrUQKCIva33G2Ndwj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iF4EAREIAAYFAlkEMU0ACgkQHwImuRkmbWmpCwD/aSpoi1Fzlo+KZjsuANn9TOEQ
dqCQJt2ova4mk2xzZrIA+QHzK8ubka9FGerQ9dz0j+BkeSAK2VdaaBYAt3lcB7d7
=dYLa
-----END PGP SIGNATURE-----

--5tWAEL9kXGPSbGEjDrUQKCIva33G2Ndwj--
