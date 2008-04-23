Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48033 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbYDWQkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 12:40:42 -0400
Subject: RE: Roaming problems
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Lars Ericsson <Lars_Ericsson@telia.com>,
	linux-wireless@vger.kernel.org, hostap@lists.shmoo.com
In-Reply-To: <1208967713.24395.4.camel@localhost.localdomain>
References: <001101c8a51d$8e5997d0$0b3ca8c0@gotws1589>
	 (sfid-20080423_114948_059414_17607EB2)  <1208949162.31429.74.camel@johannes.berg>
	 <1208958783.5656.3.camel@localhost.localdomain>
	 <1208962748.31429.84.camel@johannes.berg>
	 <1208967713.24395.4.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gjZ6dyBYMmjYG+kPb8xS"
Date: Wed, 23 Apr 2008 18:39:50 +0200
Message-Id: <1208968790.31429.86.camel@johannes.berg> (sfid-20080423_184119_861582_BA02E32C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gjZ6dyBYMmjYG+kPb8xS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Maybe, but why should the driver care?  It should be re-attempting
> association when either of SSID or BSSID gets set, interrupting any
> current ongoing association to a different AP.

Apparently the "interrupting any current ongoing association" bit isn't
right.

johannes

--=-gjZ6dyBYMmjYG+kPb8xS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASA9mVaVg1VMiehFYAQKOvg/8CWouGcDt9K1+sTSbMyyYnm48mXbLNbIN
jV6Q6Z9nag5o2+gJr3kLcTKhrlIYqvxKzgzLaoDcIgJR6awumfUSCGGuscN91Uuy
mMjvP/KP1cBcb03fMzaNRqjYH5RdLa241JeifuYtTjam8ArO+laRZ121i7l5EL3D
YynrwZpLW0Y6rWKXT1cBRyK+27KYuiPn5e8jZziWrz6S8Gcir8xb8qZk9vdx3E/F
h4yoQuQKcnryudgE40RgAH1lp4FyhrMkPBKZgUmLPVo3202pHfFRuxQLuU2jVMjL
yLH5/6G8ZnGxbQ/Ft0PiNaNsKAj2/O6ARw4H/Aw9RQOdE3yRwNFFeiQi+aMSCvsI
suzJA4nBL5sUxcehJzmtMrTLl19O3huwUcRXLS2ZSafTHD7ajifLe/k7A2ijz2xS
GhoJbyQKbhInlqnDFZwxOr+88Tr/NU7U5R0/6PAxNBVsSl7UxixGDcvYgHXnpX7/
PXhdgSUIZM3JdV/BbI63thuxBSR1dO3dw29ANOFDQiPzYLik2AyP4AeRZqmqb/Sx
kky7MA+zQdt5V9hlajAXYeEWk7PZ62sKExtX96rBqIk3E7LNqG6C16MYtxq6D8HS
WPK1DYbzqzAqIKqpM7Zd5l8fFHMw0scnP1DymTxuJ9z80Jy6bJUpUTY6hKPVYcXl
WWLkRfWYwNE=
=Ingy
-----END PGP SIGNATURE-----

--=-gjZ6dyBYMmjYG+kPb8xS--

