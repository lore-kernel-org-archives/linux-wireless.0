Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38796 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011AbXKBKO2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Nov 2007 06:14:28 -0400
Subject: Re: [PATCH 4/7] o80211s: (mac80211s) basic mesh interface support
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <472AF59A.4020302@openwrt.org>
References: <4727de06.0e578c0a.2568.ffffb079@mx.google.com>
	 <1193832985.12078.14.camel@johannes.berg>
	 <8e8340660710311736k555474f3ifd7490b5f0f7b623@mail.gmail.com>
	 (sfid-20071101_003628_984847_78170051) <1193997288.12078.39.camel@johannes.berg>
	 <472AF59A.4020302@openwrt.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dVYjx2H7EYiR2ZgzyugX"
Date: Fri, 02 Nov 2007 11:15:47 +0100
Message-Id: <1193998547.12078.43.camel@johannes.berg> (sfid-20071102_101432_979032_89ABB257)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dVYjx2H7EYiR2ZgzyugX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> Depends on how big it is. I think merging it without ifdefs is fine for
> now. If it gets too big, we can make some ifdef patches later.

Fine with me.

> If we're forced to use hostapd for starting the mesh networking, then tha=
t
> would probably be a bigger source of bloat than the mesh code itself :)

No no, but for a mesh AP I think we will have to use hostapd like for a
regular AP because a mesh AP is, afaik, like a mesh STA and a regular AP
in one station, so it offers mesh networking services to regular
clients.

johannes

--=-dVYjx2H7EYiR2ZgzyugX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARyr40qVg1VMiehFYAQLIphAAiA6YWkbsZesI5QNrnS+NhrQNe+ATWPHt
Bl2lZD96N4XevprY+DnVcT9DWBZ7qOlqxwoNCe+VSvjc7ZY+3v9Wz37BWiK74Rxj
mHoh9DeZzUvPlDbmiMMPBRfalZQQYdJMEIdJA1c1u1cMG0SbZX/lEoccovPMXNzO
Givm6RG4GWEHdIFs80jM350ul7makf3/ZF8TBlQG9DLhyXQt/CORmoQ6EPZvku4A
7MGJ8hIodBx4bOQiTqTQYmNvrw3WKyPx7Sgn5XY5ffkpLhSKmZdyCkeNjhrwz03j
2Z/QImFXTue3svm20tuaJ1cQ++WRilxTnaB1olwFwh+QYFScw5aQHddLOWzymxYA
01HD6H8TEomffm4x3mqA5xrppwQXpiVMrvZyOT20pDY31P7T0q1ZQdvKrvxOGhi3
ULMpdFpprp9P2/HQHnrp+H/C+wF72C4YWS/w2fiSWZY3F5xMk/BUemJs04z7phQ5
zyDh6MC+FUFBSdwZmy9U7lSeXVj6K0fjaq8F9iejPDaIiMHhBcVn4TmnpsN0kX02
WzangjRATWnP0T6TPAMdLeiQr6Y8/KD9sZALMCp9EmtcTgdprhHeQGDuzv5WXypM
RaaKycjazNdLL0EEWq238urbdA0EcR6Ivtgw7IOp6Sff6HE87G5LNL2PvmutCgrL
E82q9Il7t4Y=
=glg/
-----END PGP SIGNATURE-----

--=-dVYjx2H7EYiR2ZgzyugX--

