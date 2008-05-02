Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46818 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933743AbYEBUm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 May 2008 16:42:28 -0400
Subject: Re: rt61pci/rt73usb: Hardware decryption IV/EIV
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200805022238.21066.IvDoorn@gmail.com> (sfid-20080502_223244_023697_5BADF730)
References: <200805022141.28351.IvDoorn@gmail.com>
	 <1209759116.3608.8.camel@johannes.berg>
	 <200805022238.21066.IvDoorn@gmail.com>
	 (sfid-20080502_223244_023697_5BADF730)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UCfRCjPqQ9yf9R9TPdSq"
Date: Fri, 02 May 2008 22:42:19 +0200
Message-Id: <1209760939.3608.20.camel@johannes.berg> (sfid-20080502_224206_399785_60FC27B4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UCfRCjPqQ9yf9R9TPdSq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Now there you mention something. Looking at the Legacy driver, they only =
mention
> ICV during the TX, but never during RX. I did find that the MMIC is appen=
ded at the
> end of the frame, which is good, but they never do anything that looks li=
ke the
> stripping of the ICV data...
> So I assume it is stripped in the hardware, but no descriptor definition =
indicates
> a ICV field like there is for IV and EIV. Unless.... they do have a 32bit=
s "reserved" field
> located directly after the IV/EIV fields.. makes one curious if that acci=
dently contains ICV data. ;)

Heh. Maybe the hardware actually does replay protection so it doesn't
matter?

johannes

--=-UCfRCjPqQ9yf9R9TPdSq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBt8qqVg1VMiehFYAQLOKg/9G4RzYp3DUjSu9ulEQb+bXyy3uwPunCpA
nHsXpUMfNB5c1Grw19oONUuURgHi4ycMDCAhSzxF09dzDcLjmBwUVnr0Nqr4RIoE
F+XJkj0c85t/tPaIJdR/T/H8YKuCQJMn1nCrkRgXH3q+EsMCkBISbhaoIRKFPOOl
kjQMp9Ot7qd52tdKyke5vzyn81bZvO/5/GmUfx+h2vDc4H7/8CNHg9/8pZ7K9wbd
phIN4nvByus2qjG/woQNax9IdRPgdxVp3U32swgP5JcJNZkUofc5EtoUJnwSeKry
NGdxq+pBwPYJXj6UOfJ6dfQd0nx/04lY16TLSWNgH2pUmv92GImKLT5THKMUepoW
mUecP2hQGYchMgMGhQj6tBif7GNYvpMrICt4KHK1Ztr8EL+c4ZO8uLnGKSWj3nI4
tpib9THsBdRbRcyt45pPX6aSi+duJA5KrfhMmj1pI7doPCZfIBMUCaWj21U3MTYd
BgSUPME0tWvC+YB9FZ4EKzR67H/80GZDi1ucr7QzJgXw4IREY6YRoIdiWK5rlVvU
HcYPAj484oi1F8Kt3gvPog44mWpCdh7QG+qw2Ph4rEncc/0XisKv5dIzit0e71yy
i+hjgApBoja0j+SMboPj5puUcHLebjC9VlVTZbQX10qwZmbXmP4cREmUjeRxykC3
duIpLYmFwPY=
=3C4i
-----END PGP SIGNATURE-----

--=-UCfRCjPqQ9yf9R9TPdSq--

