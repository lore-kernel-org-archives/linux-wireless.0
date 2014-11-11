Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:50478 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbaKKLzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 06:55:45 -0500
Message-ID: <5461F937.9060004@rempel-privat.de> (sfid-20141111_125555_279766_6C7E2160)
Date: Tue, 11 Nov 2014 12:55:35 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Etna <etna@openmailbox.org>, linux-wireless@vger.kernel.org
Subject: Re: MediaTek WiFi hardware support in upstream kernel
References: <544DB5A8.7090405@openmailbox.org> <20141027152026.GB19976@tuxdriver.com> <544E8CB4.3000607@rempel-privat.de> <20141028134608.GA26283@tuxdriver.com> <544FA303.5060303@broadcom.com> <544FA627.3000004@rempel-privat.de> <5450BEB2.60208@openwrt.org>
In-Reply-To: <5450BEB2.60208@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="G20kD17AR8Ts9tu5vtA7F1JXHNbhc5VgW"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G20kD17AR8Ts9tu5vtA7F1JXHNbhc5VgW
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 29.10.2014 um 11:17 schrieb Felix Fietkau:
> Hi Hackers,
>=20
> Just a quick heads up:
> I'm working on a new driver for MT7662E/MT7612E, written from scratch.
> It is already able to bring up the firmware, init the MAC and do basic
> TX/RX DMA communication with the firmware.
> I've decided to not integrate it with rt2x00, because I want to avoid
> dealing with the the unnecessarily convoluted abstractions and legacy
> code in there. I believe the result will be simpler and easier to
> maintain as a new driver.
> As soon as the basic structure is in place, I will put it on a public
> git tree and post a link here.
>=20
> - Felix

Which chip would you suggest for starting?

--=20
Regards,
Oleksij


--G20kD17AR8Ts9tu5vtA7F1JXHNbhc5VgW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlRh+TcACgkQHwImuRkmbWk3FwEAmdWDJcOw3AkxrX8UeQCC3kR3
EmJhRUW9kLackzI2eKUBAIx/Bu0yd8XFiOCxhvn/FUF/AjzIb8twJDvbmn4i7cK6
=wBMc
-----END PGP SIGNATURE-----

--G20kD17AR8Ts9tu5vtA7F1JXHNbhc5VgW--
