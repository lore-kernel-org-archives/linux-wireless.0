Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33693 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbYFBRvc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 13:51:32 -0400
Subject: Re: Broadcom 4311 and Master Mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Ryan Loebs <obsidianx@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1deddf2e0806021049tff1b11fscd012f7794ec48b0@mail.gmail.com> (sfid-20080602_194910_679958_C7AC2BE4)
References: <1deddf2e0806021023j156ff226n98838622ad77ea9d@mail.gmail.com>
	 <1212428650.3599.6.camel@dv>
	 <1deddf2e0806021049tff1b11fscd012f7794ec48b0@mail.gmail.com>
	 (sfid-20080602_194910_679958_C7AC2BE4)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2w7bGZcrLA+MYSolPrD7"
Date: Mon, 02 Jun 2008 19:50:42 +0200
Message-Id: <1212429042.20021.6.camel@johannes.berg> (sfid-20080602_195134_696039_80125B04)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2w7bGZcrLA+MYSolPrD7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-02 at 10:49 -0700, Ryan Loebs wrote:
> Alright, I had it set to hw_mode=3Db changed it to hw_mode=3Dg and now it
> got through... somewhat...
>=20
> Now  I get this:
>=20
> Upon startup:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Configuration file: hostapd.conf
> Failed to update rate sets in kernel module
> Could not set passive scanning: Unknown error 4294967295
> Mode: IEEE 802.11g  Channel: 5  Frequency: 2432 MHz
> Failed to set CTS protect in kernel driver
> Failed to set Short Slot Time option in kernel driver
> Could not set preamble for kernel driver
> Using interface wlan0 with hwaddr 00:1a:73:a4:44:c8 and ssid 'test'
> Failed to set CTS protect in kernel driver
> Failed to set Short Slot Time option in kernel driver
> Could not set preamble for kernel driver
> unknown mgmt cb frame subtype 4
> unknown mgmt cb frame subtype 4
> unknown mgmt cb frame subtype 4
> unknown mgmt cb frame subtype 4
> unknown mgmt cb frame subtype 4
> unknown mgmt cb frame subtype 4
> unknown mgmt cb frame subtype 4
> unknown mgmt cb frame subtype 4
> unknown mgmt cb frame subtype 4
> unknown mgmt cb frame subtype 4
> unknown mgmt cb frame subtype 4
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>=20
>=20
> Nintendo DS attempts to connect and test:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> wlan0: STA 00:09:bf:63:d9:79 IEEE 802.11: authenticated
> Failed to set CTS protect in kernel driver
> Failed to set Short Slot Time option in kernel driver
> Could not set preamble for kernel driver
> Failed to set CTS protect in kernel driver
> Failed to set Short Slot Time option in kernel driver
> Could not set preamble for kernel driver
> Failed to set CTS protect in kernel driver
> Failed to set Short Slot Time option in kernel driver
> Could not set preamble for kernel driver
> wlan0: STA 00:09:bf:63:d9:79 IEEE 802.11: associated (aid 1,
> accounting session 484431D2-00000000)
> Failed to set CTS protect in kernel driver
> Failed to set Short Slot Time option in kernel driver
> Could not set preamble for kernel driver

So, what are you expecting to happen? It associated fine, so hostapd's
work is done.

johannes

--=-2w7bGZcrLA+MYSolPrD7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASEQy8aVg1VMiehFYAQIgEw//ayL55r90kGdVBRJmU0K93T8Adao2M9yP
rNGB5tHxGTfNYhT4ojxNKFeFYRY9UjZNa/By4UVK0hvzSXHEx2d84G+c8qrEZhT8
RRgSbZSLcUbb/2kuOTEgGNkhMSRILlmbcgovAdcHiBrv+4WVgIwA2/55bJbLiE0E
CSJL9IfSHxwdc0M4y+m5VqJBRp9ylHpozxhiv+vxHOM4DzeFzhh+yIMd0mpWEMUv
FsuTxQq/cxiEF6En0jcAF88M/CnAAkDV4t/9umnaadgH9NX6z44lCkRGEboDHTFR
A2YQy2IYFlJm7buPbWwFxjmg8izcpj3efPv+6qiHdPXwDsGWUIXReBI6Q/mjK59f
IsazBa7z/7gmwjnS9u3gq2BGTdWvkCYIDKi1jbaSOgZwnYjqWO+97hDCYP2a7tPN
GX+DQeTQ4CvmgIqN9cBkgl6Zg1X60JzQffi8alAqCId7glqrPjB7mWbZ5u8+Z3ad
6yMKDwjEqcqe1WIJosJB1pWYZv/jxIM25GINxQorYwGQWn/Y/H8V6Z+J0G70eVnC
eHrV709Nbg4h9IIDVB/RL5tQVY179sX+JTABMZq6OnReY1EFy98j53nc2pggKSck
OPT7Cpp9dEsAmnJftpsMpH1KmVSMhCZ/CT1owchMLmj+O7/rkq9KnriGl/EHuF98
xujpRnfBmgI=
=0Dfe
-----END PGP SIGNATURE-----

--=-2w7bGZcrLA+MYSolPrD7--

