Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:34396 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbZKQWMM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 17:12:12 -0500
Received: by bwz27 with SMTP id 27so461248bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 17 Nov 2009 14:12:17 -0800 (PST)
Message-ID: <4B031FBA.5070507@gmail.com>
Date: Tue, 17 Nov 2009 23:12:10 +0100
From: Piotr Findeisen <piotr.findeisen@gmail.com>
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: unsupported TL-WN422G (0cf3:1006)
References: <4B02CD95.2010805@gmail.com> <200911171758.53596.s.L-H@gmx.de>
In-Reply-To: <200911171758.53596.s.L-H@gmx.de>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEBA21B266C8F61D9E3A309E9"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEBA21B266C8F61D9E3A309E9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi, Stefan!
Thanks for your explanation!

On Tue, Nov 17, 2009 at 17:58, Stefan Lippers-Hollmann <s.L-H@gmx.de
<mailto:s.L-H@gmx.de>> wrote:

    If you take a look at the vendor's windows driver for TP-LINK WN422G
    *v2*,


how can I know I have v2 of the device?
=20

    it becomes obvious that the device does not use the ZyDAS zd1211/
    Atheros
    5007UG cipset, but has switched to the new Atheros AR9271 chipset (wh=
ich
    technically is a 150 MBit/s 802.11n "lite" chipset family) instead.

    %ATHER.DeviceDesc.9271% =3D ATHER_DEV_9271.ndi,     USB\VID_0CF3&PID_=
9271
    %ATHER.DeviceDesc.7010% =3D ATHER_DEV_7010.ndi,     USB\VID_0CF3&PID_=
7010
    %ATHER.DeviceDesc.1006% =3D ATHER_DEV_1006.ndi,     USB\VID_0CF3&PID_=
1006


OK, I found this section on the CD with the drivers but my product id is
1006. How do you know it's AR9271 chipset and not, say, AR1006?
I found /AR9271/i on the CD in driver files for Windows 2000, XP, XP64.
Vista driver files don't have this substring anywhere (they have '9271'
in netathur.inf 6 times, and '1006' is 6 times in analogus lines as well)=
=2E

=20

    At this moment a new driver called ath9k_htc is under (early)
    development:
           http://wireless.kernel.org/en/users/Drivers/ath9k_htc


If i understand correctly 'Status' section, this driver is wireless and
radioless at this moment, right?
Maybe I should check this driver to see if it recognizes my card correctl=
y?


best regards,
Piotr



--------------enigEBA21B266C8F61D9E3A309E9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAksDH7oACgkQhIjjAqQbQwP6uQCgkzD1HjjLqbqgcI1frgjKDWwi
MCQAn1D2Iiydy8V13UIBWXWgrCcEDjsj
=2w0Z
-----END PGP SIGNATURE-----

--------------enigEBA21B266C8F61D9E3A309E9--
