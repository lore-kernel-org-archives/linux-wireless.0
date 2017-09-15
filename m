Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50063 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750879AbdIOK2M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 06:28:12 -0400
Subject: Re: What makes USB WiFi so difficult in Linux and may I help out?
To: Ernst Wegner <ernstwegner95@gmail.com>,
        linux-wireless@vger.kernel.org
References: <CAF11ideB1ButOi1r8dmkbQZzSjmVrO247+pMOuxy60pO+BkuiA@mail.gmail.com>
From: Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <6487ac8f-446c-41fa-3fb1-29225569be45@rempel-privat.de> (sfid-20170915_122815_563750_E49C141B)
Date: Fri, 15 Sep 2017 12:28:04 +0200
MIME-Version: 1.0
In-Reply-To: <CAF11ideB1ButOi1r8dmkbQZzSjmVrO247+pMOuxy60pO+BkuiA@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MqFcW1BbcX1RGtwOKMe0JrXjR6RU2DmT6"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MqFcW1BbcX1RGtwOKMe0JrXjR6RU2DmT6
Content-Type: multipart/mixed; boundary="frdfKH3NrdJfMG4NXS86o5kcHS34Axqlu";
 protected-headers="v1"
From: Oleksij Rempel <linux@rempel-privat.de>
To: Ernst Wegner <ernstwegner95@gmail.com>, linux-wireless@vger.kernel.org
Message-ID: <6487ac8f-446c-41fa-3fb1-29225569be45@rempel-privat.de>
Subject: Re: What makes USB WiFi so difficult in Linux and may I help out?
References: <CAF11ideB1ButOi1r8dmkbQZzSjmVrO247+pMOuxy60pO+BkuiA@mail.gmail.com>
In-Reply-To: <CAF11ideB1ButOi1r8dmkbQZzSjmVrO247+pMOuxy60pO+BkuiA@mail.gmail.com>

--frdfKH3NrdJfMG4NXS86o5kcHS34Axqlu
Content-Type: text/plain; charset=utf-8
Content-Language: ru
Content-Transfer-Encoding: quoted-printable

Hi,

it is not related to your HW, but may help:
https://github.com/qca/open-ath9k-htc-firmware/wiki/Troubleshooting-and-b=
ug-reporting
https://github.com/qca/open-ath9k-htc-firmware/wiki/usb-related-issues

Am 15.09.2017 um 10:48 schrieb Ernst Wegner:
> Dear list!
>=20
> I recently suffer from attempts to use some USB WiFi sticks to connect
> to a wireless network using Linux. I tried that with a number of
> distros, but found that there seem to be kind of the same problems all
> the way from Linux 2.6.x to 4.x. Most USB WiFi sticks don't work
> reliably.
>=20
> As I am a developer also (and very interested in these things) I would
> be willing to help debugging drivers and possibly fix them. But I
> don't really know where to start searching. So some hints would be
> very welcome.
>=20
> Currently I try to get this one here to work:
>=20
> Bus 001 Device 006: ID 148f:5370 Ralink Technology, Corp. RT5370
> Wireless Adapter
>=20
> I am on Debian 9 with a pretty recent kernel:
>=20
> Linux debian 4.9.0-3-amd64 #1 SMP Debian 4.9.30-2+deb9u3 (2017-08-06)
> x86_64 GNU/Linux
>=20
> I was able to get this stick to work kind of. Actually, it drops the
> connection every couple of minutes, without any error messages in
> dmesg or syslog, actually. But I was able to reach that state only
> after applying some tweaks like disabling hardware encrypt, i.e.
>=20
> options rt2800usb nohwcrypt=3Dy
>=20
> and
>=20
> [device]
> wifi.scan-rand-mac-address=3Dno
>=20
> So any pointers would be welcome.
>=20
> I am not afraid to dig into the code of the driver and recompile.
>=20
> I could also possibly add or enable some debugging code so I will get
> some more debugging output to see what actually happens when I loose
> the connection, i.e. if this is an external event, a special kind of
> package, overload, ...
>=20
> And finally: This isn't the only USB Wifi stick which has serious
> problems with Linux. The Internet is full of this including drivers
> for some sticks which don't work at all and don't go anywhere for
> month. Obviously it's not the sticks to blame, as they all work fine
> on Windows. So what's the underlying story here which I am missing?
>=20
> Regards,
> Torsten
>=20


--=20
Regards,
Oleksij


--frdfKH3NrdJfMG4NXS86o5kcHS34Axqlu--

--MqFcW1BbcX1RGtwOKMe0JrXjR6RU2DmT6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF4EAREIAAYFAlm7qzQACgkQHwImuRkmbWknMwEAj9MTM97K2LZG6ylFuiPpfxyb
a80+K8lDCdKpK+MZqnkA/j/lDz0PXe7VKvBFkD4ykb/+ZeB12lKhfQ36/+L/Mnua
=vYvZ
-----END PGP SIGNATURE-----

--MqFcW1BbcX1RGtwOKMe0JrXjR6RU2DmT6--
