Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42782 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbYFJO66 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jun 2008 10:58:58 -0400
Subject: Re: QUESTIONS to ieee80211_beacon_get AND ieee80211_get_buffered_bc
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe <wirelesss@gmx.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <484E9436.605@gmx.de> (sfid-20080610_165400_911481_E6BDBEC3)
References: <4848289D.1080205@mandriva.org>
	 <1ba2fa240806051103q652accf5t1bd1d94630ebea5b@mail.gmail.com>
	 <48482BC3.4070402@mandriva.org> <4848482C.2080208@mandriva.org>
	 <48485F12.2050908@mandriva.org>  <484E9436.605@gmx.de>
	 (sfid-20080610_165400_911481_E6BDBEC3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mL/aVX8NQ9RHeLToDAX+"
Date: Tue, 10 Jun 2008 16:58:23 +0200
Message-Id: <1213109903.3668.20.camel@johannes.berg> (sfid-20080610_165902_089768_42E3B50E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mL/aVX8NQ9RHeLToDAX+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

=20
>  ieee80211_beacon_get
>  ieee80211_get_buffered_bc
>  in tx.c
>=20
> Both are called by the hardware to get the current beacon from the=20
> ieee80211 stack, right?

No. Please read the available documentation and code.

johannes

--=-mL/aVX8NQ9RHeLToDAX+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJITpaLAAoJEKVg1VMiehFYtRAP/2+RxBQe8uxFtZDBr5hsDVZo
QqzQzfRLrXQC35L24IFtudKYkREBM47k9tz2HTyvJwUInpJ7nVaNWxM/E7cbUuvo
8uIrioh4wwyV45B01Y0ajzwobNOcn9WrzOdln0h38eMcu3HMcneeqBRfttYbjXO1
tBrQGv/zCm2wU5Ph+dmpnFvjeyQfuswEVgKDGfChZwpxhVOCWATIiFM7/ArH2Y1E
mfj3I//6bMKIyV5ZREkA4SRA+6Bw7PX6ps4cm1lu/729ELwJbxCON3I4VvDhd6Lj
HVmLcbr2Bkx2oIC+FpPx43yzwkf8pTEOIxALU+M/xH6i7iKMUOAdveb3Lj+KmaJl
HiuXhrzg/f2rdCBTF3aAlzUOz7HpehOJ3wUsIRF7630gpk1Ty3k6Rv1MNAsgD3w5
sAKwBubo8+8V5fXbV56DchbEEMCNTtZ6YR4zlzIW8MO1cSFdSvmhLOhtODMS2ffC
n2RL392rNWL0FegDm5DsbZnz/SWy1np/YSrjcA7C09n29VqfTF9GTIBvfEhgnykw
hnnbZDDwLDGcn0Rog8sv8tk7C7iOpk3fIX26EcKl6anrdG754oQ/LBH5luLhstlY
snS0Kw97cmbJKpXMVvvn99lNIKxsigjZGNPBGNEu3ZImhRzzElOViBb2BjCk+Qvl
VXWFMDRtadGX8oKsTqbV
=Ny5K
-----END PGP SIGNATURE-----

--=-mL/aVX8NQ9RHeLToDAX+--

