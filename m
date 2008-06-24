Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732AbYFXJE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 05:04:59 -0400
Subject: Re: RFC: always enable MAC80211_RC_PID?
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
In-Reply-To: <43e72e890806220804i347b942claae7b725231afcce@mail.gmail.com> (sfid-20080622_170420_352659_95C30F7B)
References: <20080622125553.GB22539@cs181133002.pp.htv.fi>
	 <43e72e890806220804i347b942claae7b725231afcce@mail.gmail.com>
	 (sfid-20080622_170420_352659_95C30F7B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NSEEW9xpo9IHsiRwAP4R"
Date: Tue, 24 Jun 2008 11:04:19 +0200
Message-Id: <1214298259.8967.260.camel@johannes.berg> (sfid-20080624_110503_316397_272DD73D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NSEEW9xpo9IHsiRwAP4R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> You can currently only get away living without it if you are just
> using iwl3945 or iwl4965 as they provide their own rate control
> algorithms. In the future if other vendor drivers are added with their
> own rate control algorithm this list grows.

FWIW, I would like to see those algorithms be supported as part of
mac80211 and not be internal like iwlwifi hacked them on, and have some
sort of feature negotiation between the hardware and the RC algorithm
when choosing one.

johannes

--=-NSEEW9xpo9IHsiRwAP4R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYLiQAAoJEKVg1VMiehFYkvMP/0llLpuSHDGrlVszqa/25ocY
VlpXU8A0osHfGwhgdyYhM5VId6HHFKdeDyJK/aKrd6co1An7YACY4inT9bUv+Ml4
1QmYDDqjussn38UllqpGnt/0HjAYyNurmtZdww4055SVGEaXHF+Tx4DpjuYDAyD1
xpPC2nqDg7e9lMIhMQbPeRwQYYsfgQt5b4XEOu1521x22iKP8BPzG2NAQ7SmkADu
/j0Nwmm748SfyBpR2797jJttRKGFgkH5O+hKxiQYm3hqdmZKlBEWvqGZnxmnic0u
1v9mE/30uvzqgVAlj7vRKy3RslGN7UccWPyA55WzLmBk8PO3AJbOagLtPvTDRjGf
2ZjjAbBQFRW97FvDhM0yxrmPyLao1MsxTRl49wmHedl4H+LIdRlNVzLWeb6aRfL3
P8TAeCgnF32R+/pA/YCjsMt2rZaZ7lEAuUcfQdctQjkb+J8tLH7FvH8ukoBM5WFF
kpMIx2pjVixV/iDRWKRxlC72muWF16lU4U0HZJV1JHciNmG95xDXIABqWKm/xp6b
KWI7aebdpcvi1YHA+7gafNoLdrw0u8aFZ7MZMPWuN81yEER8PQZaZ8U6UXy3izig
2Cy6u5YjB+e5j1i5aRP/X/ukI0Atikq4lcELgaLLGgZ2x5/zShPwNKhOAoASZ1Vt
pXRzeG6933Hgr2Vj9A5C
=ocr8
-----END PGP SIGNATURE-----

--=-NSEEW9xpo9IHsiRwAP4R--

