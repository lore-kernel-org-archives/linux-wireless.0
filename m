Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57449 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760825AbZDSQ0Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 12:26:24 -0400
Subject: Re: [RFC/RFT v2] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090419161316.158790@gmx.net> (sfid-20090419_181324_681308_BAEAE072)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240097845.25826.1.camel@johannes.local>
	 <20090419125212.158800@gmx.net>
	 (sfid-20090419_145246_566920_BF082D12) <1240147050.25826.5.camel@johannes.local>
	 <20090419133544.158820@gmx.net>
	 (sfid-20090419_153615_967882_D1A9F951) <1240148519.898.3.camel@johannes.local>
	 <20090419140523.158830@gmx.net>
	 (sfid-20090419_160555_446977_A429511B) <1240150277.898.7.camel@johannes.local>
	 <20090419151629.158790@gmx.net>
	 (sfid-20090419_171702_263242_9A8C16F9) <1240154704.898.18.camel@johannes.local>
	 <20090419155319.158810@gmx.net>
	 (sfid-20090419_175352_161479_A88396A3) <1240156631.917.1.camel@johannes.local>
	 <20090419161316.158790@gmx.net> (sfid-20090419_181324_681308_BAEAE072)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-6bTDc9/sFgG0PKh+CIjJ"
Date: Sun, 19 Apr 2009 18:26:21 +0200
Message-Id: <1240158381.917.21.camel@johannes.local> (sfid-20090419_182627_951206_729611A1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6bTDc9/sFgG0PKh+CIjJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-04-19 at 18:13 +0200, Alina Friedrichsen wrote:
> > You don't need wpa_supplicant, you just need an SME for that. Eventuall=
y
> > we'll implement one in iw.
>=20
> You need one simple SME for compatibility with wext in the
> kernel-space. Why not allow to access it with nl80211?

We might actually do that -- as part of the commands "connect" and
"disconnect" that do not exist yet and subsume auth and assoc into one
for hardware that doesn't support it.

johannes

--=-6bTDc9/sFgG0PKh+CIjJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ61CqAAoJEKVg1VMiehFYUnkP/RMY+oqPlaldb34wcESb97ke
LnOR+etcBcKRyk09UPTV01PnywephuweS7lsaYUWJApvXy7QZaFSYlz6SWKPRIV3
otsr7so323jegcYNVUzclLUKGxjknFX+6+RGpHcXvf3QCU4geQK+D6EEKVlqvPkZ
9D7hzDWX8Yl6HzDTGiTskb4kCr0QI4YUIR+OQZleWFF0tuNbGDJvT+8V/9t+sJkD
AVR0L+mbqlyB2mO2NLkUnNRul4mEru3kW0nkfXAORBOJ70wPyxRv//cQVIsLtvmE
v/mQMgSz0UAqpL1AjU1AtNtN9ESHe3Ns4KK2hoCypsKPmuKNOTMoIiYywAz0N1+O
J7jfiYkxAacvdsmaCZ3c8l13d2+1OS4+hoW7PEUjy6HcuKcFipKeZ/4p8Bv6vvj2
/Ad1y1bUAMRVBeWJhllmaTg8tKJeoawTZlK+3kG8SZhIg4dobOebOhLi41ZGcbFs
RxgiThiX3A8abcVkaLlexxX/CaNVUNs17WS34l1miYuaHKMWtJnoIp7SG1lBvVMQ
Khy+Tk5wo0LzH008Az7gpM14aEOPVLqWwaBIlLux4cOfQjhiQBRPyuo2fIzwXa0M
8D0FO4AbkFtMr7s9cIWxw88hdm088Gt1iklNkB09EsSIFu0NPob6W9SxaaU/dJJP
Rg1lFxPpuHSLZ2wAjdQx
=hUpn
-----END PGP SIGNATURE-----

--=-6bTDc9/sFgG0PKh+CIjJ--

