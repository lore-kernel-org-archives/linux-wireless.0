Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38029 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754441Ab1DJVDg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Apr 2011 17:03:36 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
In-Reply-To: <4DA2042A.3010301@gmail.com>
References: <4DA2042A.3010301@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-o3qyJqkE8SuX39fEJ35J"
Date: Sun, 10 Apr 2011 22:03:26 +0100
Message-ID: <1302469406.5282.341.camel@localhost>
Mime-Version: 1.0
Subject: Re: Firmware files for Ralink RT28x0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-o3qyJqkE8SuX39fEJ35J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2011-04-10 at 21:25 +0200, Xose Vazquez Perez wrote:
> Ben Hutchings wrote:
>=20
> > Ralink provides multiple drivers per bus type for RT28xx and later
> > chips.  For PCI devices they split between RT2860 and RT309x; for USB
> > devices they split between RT2870 and RT307x (I think - the chip model
> > numbers don't seem to be stated consistently).
> >=20
> > In addition, the USB drivers have two separate images packed together
> > and they can select different images based on the controller version:
> >=20
> > #ifdef RTMP_MAC_USB
> > 		if ((Version !=3D 0x2860) && (Version !=3D 0x2872) && (Version !=3D 0=
x3070))=20
> > 		{	// Use Firmware V2.
> > 			//printk("KH:Use New Version,part2\n");
> > 			pFirmwareImage =3D (PUCHAR)&FirmwareImage[FIRMWAREIMAGEV1_LENGTH];
> > 			FileLength =3D FIRMWAREIMAGEV2_LENGTH;
> > 		}
> > 		else
> > 		{
> > 			//printk("KH:Use New Version,part1\n");
> > 			pFirmwareImage =3D FirmwareImage;
> > 			FileLength =3D FIRMWAREIMAGEV1_LENGTH;
> > 		}
> > #endif // RTMP_MAC_USB //
> >=20
> > The firmware blobs in RT2870 version 2009-08-20 and RT3070 version
> > 2009-05-25 are all marked as version 17 (or 0.17), but *they all have
> > different contents*.
> >=20
> > I attempted to maintain the same version selection logic when convertin=
g
> > the staging drivers to use the firmware loader, since I assumed there
> > was a good reason for it.
> >=20
>=20
> As you can see in the ralink web[1] RT28XX/RT30XX USB devices (RT2870/RT2=
770/RT3572/RT3070)
> need _only_ the rt2870.bin fw-file.
>=20
> And RT28XX/RT30XX PCI/mPCI/PCIe/CardBus devices
> (RT2760/RT2790/RT2860/RT2890/RT3060/RT3062/RT3562/RT2860/RT2760/RT2890/RT=
2790/RT3090)
> need _only_ the rt2860.bin fw-file.

These files aren't used by the Ralink drivers.  So why should you
believe the labels on them?

> > linux-firmware is supposed to have all firmware files referenced by any
> > version of Linux
>=20
> That's a good joke!
> linux-firmware is *unmaintained* , a lot of firmwares are missing.

linux-firmware is not *actively* maintained; it requires people to send
submissions (repeatedly...).

> Even the intel ones(microcode.dat, ipw2{1,2}*), zd1211, etc...

I think there may be a problem with distribution of Intel Pro Wireless
firmware because Intel requires users to accept a EULA.

> Others are very old, really it's a mess.
> Fedora puts _forty_ patches on top of linux-firmware.

So help to make it better.

Ben.

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-o3qyJqkE8SuX39fEJ35J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATaIbGee/yOyVhhEJAQpvAxAAnRzrTr4WXSFbt8IFCrLb9EIk+6tG6ve/
ZDKxFAPs65ZTC3kIbbPdenLtIvdWLlrYVdYM9AeB7Vpd+JIn2nSQZatd4X46Z4/O
6bYmtNvQRhB/zJndY21UWvPmLpBc/3L0rTt25YsM7TGqU9M5/GW/5wRQeeyzn1+7
lQFSeIpL1b7FghbP63Yg4b2sy1lCIPskcW9oL3o0SkjIEpIHeck1sw2MVsMyfkl9
16sws1N/AYIuZ8+M3bM2VHHfnJAFJDASWorBCjlFkoD2F4VoQ6C9MvrqM4YNquWm
0V61iXwdvGWZuM+KikORMAS+sWEBcq8MmuxH6Tb4xarRVw3QKTcfHs1x1yRmbzIx
av9bq39c/2hTJMUysoh0/6F7CMP+VD5vu38Zl3av8b2SfmSTgw21cZM6OBk965FZ
EGdCH3TWhfNXm7c2dpAWNyDTV72J8LKsRovbprjQn6efzXA8g95WdVoHucFSYJEc
DTrY2jajc4s2FiHI1/mtY+NwR4HsTtsixZtu0f7WfCJbY+cEWLQ3YSVU6wJlpzRD
ncifqq6FY9dDQzSUbHuwquqc1C7iE9WlUbaUYgpxuFMP97d6e1A8zb91Zz5b1Fng
PlVXOV//EbXgjxWmsM4OD75fl5o/a6TRcbAy3sIbIj7je5YCKCcFW/GVENTp+pPh
MCBCA56m+vw=
=+VWz
-----END PGP SIGNATURE-----

--=-o3qyJqkE8SuX39fEJ35J--
