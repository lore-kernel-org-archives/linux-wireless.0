Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:55065 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbZKRH6q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 02:58:46 -0500
Received: by bwz27 with SMTP id 27so797306bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 23:58:51 -0800 (PST)
Message-ID: <4B03A939.5000303@gmail.com>
Date: Wed, 18 Nov 2009 08:58:49 +0100
From: Piotr Findeisen <piotr.findeisen@gmail.com>
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: unsupported TL-WN422G (0cf3:1006)
References: <4B02CD95.2010805@gmail.com> <200911171758.53596.s.L-H@gmx.de>	 <ddb82bf60911171406r2c328f69ic3789f8e937e41f7@mail.gmail.com>	 <200911180044.45287.s.L-H@gmx.de>
In-Reply-To: <200911180044.45287.s.L-H@gmx.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig24510D02F31667BDC6D80B60"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig24510D02F31667BDC6D80B60
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi, Stefan!

Thank you for all the help!

Unless i will be able to exchange my card with one based on zydas
chipset and if i will have some free time, I'll contact ath9_htc
developers (or the wiki) for any further reference and/or testing.

Funny think about this USB card is that, when I plugged it into my
laptop, it made my broken broadcom PCI-E card work again immediately, so
money was not lost completely :)

Best regards,
Piotr


On Wed, Nov 18, 2009 at 00:44, Stefan Lippers-Hollmann <s.L-H@gmx.de
<mailto:s.L-H@gmx.de>> wrote:
> Hi
>
> On Wednesday 18 November 2009, Piotr Findeisen wrote:
> > Hi, Stefan!
> > Thanks for your explanation!
> >
> > On Tue, Nov 17, 2009 at 17:58, Stefan Lippers-Hollmann <s.L-H@gmx.de
> <mailto:s.L-H@gmx.de>> wrote:
> >
> > > If you take a look at the vendor's windows driver for TP-LINK
> WN422G *v2*,
> >
> > how can I know I have v2 of the device?
> >
> > >  it becomes obvious that the device does not use the ZyDAS zd1211/
> Atheros
> > > 5007UG cipset, but has switched to the new Atheros AR9271 chipset
> (which
> > > technically is a 150 MBit/s 802.11n "lite" chipset family) instead.=

> [...]
> > > %ATHER.DeviceDesc.1006% =3D ATHER_DEV_1006.ndi,   =20
> USB\VID_0CF3&PID_1006
>                                                              ^^^^     ^=
^^^
> Which means your device is TP-LINK WN422G v2 - and therefore AR9271.
>
> > OK, I found this section on the CD with the drivers but my product id=
 is
> > 1006. How do you know it's AR9271 chipset and not, say, AR1006?
> > I found /AR9271/i on the CD in driver files for Windows 2000, XP, XP6=
4.
> > Vista driver files don't have this substring anywhere (they have
> '9271' in
> > netathur.inf 6 times, and '1006' is 6 times in analogus lines as well=
).
> >
> > > At this moment a new driver called ath9k_htc is under (early)
> development:
> > >        http://wireless.kernel.org/en/users/Drivers/ath9k_htc
> >
> > What does 'early' mean in this context? Is it worth try or should i
> look for
> > replacement?
>
> Disclaimer, I neither have access to an AR9271 device, nor am familiar
> with
> its development state, therefore I base this on the afforementioned dri=
ver
> wiki page and the reference code.
>
> It's not merged in 2.6.32, wireless-next (~=3D 2.6.33) or wireless-test=
ing
> yet and http://wireless.kernel.org/en/users/Drivers/ath9k_htc#Status is=

> pretty explicit about its state, namely that it doesn't actually transm=
it
> any data yet. Even though development seems to be pretty active and
> showing
> quite some potential, it will likely take several months before it beco=
mes
> enduser compatible.
>
> Regards
>        Stefan Lippers-Hollmann




--------------enig24510D02F31667BDC6D80B60
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksDqTkACgkQhIjjAqQbQwNKqACgpsf0MuPKSPcOnKZIgCJrwZOa
FoIAoK50DZeLXe/6S97NI44u+eVwX6lk
=aHO3
-----END PGP SIGNATURE-----

--------------enig24510D02F31667BDC6D80B60--
