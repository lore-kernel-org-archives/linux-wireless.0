Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:53564 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbZFFR02 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jun 2009 13:26:28 -0400
Message-ID: <4A2AA6BC.5040004@web.de>
Date: Sat, 06 Jun 2009 19:26:20 +0200
From: Jan Kiszka <jan.kiszka@web.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	otus-devel@lists.madwifi-project.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 0/2] ar9170-fw: Roll-your-own toolchain
References: <4A2AA395.3060406@web.de> <1244308808.15640.4.camel@johannes.local>
In-Reply-To: <1244308808.15640.4.camel@johannes.local>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2DD70F40389FEDC4A9014611"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2DD70F40389FEDC4A9014611
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Johannes Berg wrote:
> On Sat, 2009-06-06 at 19:12 +0200, Jan Kiszka wrote:
>=20
>> On the other hand, the AP firmware doesn't work on my DWA-160a anyway
>> ("device is in a bad state"),=20
>=20
> This is normal. Not sure what's wrong with that, but I don't really car=
e
> either.

But does you device enter an endless reset loop?

[ 5337.468082] usb 2-2: new high speed USB device using ehci_hcd and addr=
ess 30
[ 5337.648024] usb 2-2: New USB device found, idVendor=3D07d1, idProduct=3D=
3c10
[ 5337.648032] usb 2-2: New USB device strings: Mfr=3D16, Product=3D32, S=
erialNumber=3D48
[ 5337.648038] usb 2-2: Product: USB2.0 WLAN
[ 5337.648042] usb 2-2: Manufacturer: ATHER
[ 5337.648046] usb 2-2: SerialNumber: 12345
[ 5337.648235] usb 2-2: configuration #1 chosen from 1 choice
[ 5337.764060] usb 2-2: reset high speed USB device using ehci_hcd and ad=
dress 30
[ 5338.940054] usb 2-2: firmware: requesting ar9170.fw
[ 5340.552081] usb 2-2: device is in a bad state. please reconnect it!
[ 5341.552118] ar9170usb: probe of 2-2:1.0 failed with error -110
[ 5341.556838] usb 2-2: USB disconnect, address 30
[ 5341.800076] usb 2-2: new high speed USB device using ehci_hcd and addr=
ess 31
=2E..

Obviously not usable that way for me.

Maybe a toolchain issue - could you throw some AP firewire over that
works for you?

Thanks,
Jan


--------------enig2DD70F40389FEDC4A9014611
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkoqpsQACgkQniDOoMHTA+nw5wCdELwHJ+wZILcJG0iMIwv9/+mo
F9MAn1yor4iolyGMQwL0V/rMzmEzDf4R
=fNPV
-----END PGP SIGNATURE-----

--------------enig2DD70F40389FEDC4A9014611--
