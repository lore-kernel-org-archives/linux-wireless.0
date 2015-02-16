Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:49356 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621AbbBPMQp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 07:16:45 -0500
Message-ID: <54E1DF9F.7080708@rempel-privat.de> (sfid-20150216_131648_513572_4B1F391C)
Date: Mon, 16 Feb 2015 13:16:31 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Waldek <sp2ong@wp.pl>, linux-wireless@vger.kernel.org
Subject: Re: 10/5 Mhz channel width is possible ?
References: <54e1bd9b748a00.69475037@wp.pl>
In-Reply-To: <54e1bd9b748a00.69475037@wp.pl>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3WqR0wUmqDGEGcS1o77D6mCRwNJGfd7l7"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3WqR0wUmqDGEGcS1o77D6mCRwNJGfd7l7
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 16.02.2015 um 10:51 schrieb Waldek:
>=20
> Hi,
>=20
> I have linux kernel version 3.19 and iw tool v3.17. I have use USB WIFI=
 WN722N which use ATH9k_htc driver from kernel
> I would like setup channel width 5 MHZ form my ad-hoc Mesh network base=
 on olsrd
>=20
> I have try setup in following
>=20
> iw wlan0 set type ibss
> ip link set wlan0 up
> iw wlan0 ibss join MYNet 2447 5MHZ
>=20
> but I have message:
>=20
> command failed: Invalid argument (-22)
>=20
> when I use=20
> iw wlan0 ibss join MYNet 2447
>=20
> no error message but channel width is 20 Mhz
>=20
> I have see syntax iw tools:
>=20
>  iw   dev <devname> ibss join <SSID> <freq in MHz> [HT20|HT40+|HT40-|NO=
HT|5MHZ|10MHZ] [fixed-freq] [<fixed bssid>] [beacon-interval <TU>] [basic=
-rates <rate in Mbps,rate2,...>] [mcast-rate <rate in Mbps>] [key d:0:abc=
de]
>=20
> it is look that in ibss mode I can set 10 or 5 Mhz width channel but do=
n't work
>=20
> I have local network which working on OpenWRT with UBNT devices with ch=
annel width 5 Mhz
> I would like get access to my local network from my laptop with Linux a=
nd use USB WIFI WN722N
>=20
> What is wrong ??
>=20
> Thank you for help and any suggestion
>=20
> Waldek

Theoretically it should be possible, but i we need some changes in the
firmware.

--=20
Regards,
Oleksij


--3WqR0wUmqDGEGcS1o77D6mCRwNJGfd7l7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iF4EAREIAAYFAlTh36kACgkQHwImuRkmbWkL+gD+IPvRWWFM32QbTD8eQCFG3s+v
sMjqP5X5vtIlZSeygiwA/i9XjEVwEgHTBXP7ur14o4UFeUnNc3PpB7BZzmPG8G8C
=qptB
-----END PGP SIGNATURE-----

--3WqR0wUmqDGEGcS1o77D6mCRwNJGfd7l7--
