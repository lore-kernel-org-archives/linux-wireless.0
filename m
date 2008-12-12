Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572AbYLLWub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:50:31 -0500
Subject: Re: [RFC 0/3] cfg80211, mac80211: Introduce radiotap flags for
	finer userspace control of injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910812121440j6e010ac0j6e08cd6a53f58bcb@mail.gmail.com> (sfid-20081212_234036_335109_607659A0)
References: <69e28c910812121432k1e8732bcma77e489d247ecdf4@mail.gmail.com>
	 <1229121467.3565.2.camel@johannes.berg>
	 <69e28c910812121440j6e010ac0j6e08cd6a53f58bcb@mail.gmail.com>
	 (sfid-20081212_234036_335109_607659A0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/pCzRBFv2DFm4cCn8Aqe"
Date: Fri, 12 Dec 2008 23:50:25 +0100
Message-Id: <1229122225.3565.16.camel@johannes.berg> (sfid-20081212_235034_121177_CCD47E98)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/pCzRBFv2DFm4cCn8Aqe
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 23:40 +0100, Stefanik G=C3=A1bor wrote:

> [...]

Incidentally, as for the radiotap changes, I'm wondering whether the
flag really should be "no seqno" or should be "assign seqno" instead. It
seems injection should be "as raw as possible" by default. But things
like that really need to be worked out with people from other systems.

johannes

--=-/pCzRBFv2DFm4cCn8Aqe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQuquAAoJEKVg1VMiehFYNYsP/isp8+8NGJ+ZTH0IQMyKmlFQ
bPgGuc7AlFpHo49TB6n6x+8yeRFcMlPj/VYD6WRu//VKaiOLjtSxJkPaiHFuPjEw
Ord0zSB3tUtARCI8nqmmg8MGieQmYKxPBRBSJO66RCu8wxrX9FrxCDwfIeVkY3uz
yTcKIlnCQ48zQTSQ0lfe6fQlI/d4MBMw6v0vn2MkvH6tqotP+TmL5tq3MhGSX7lK
zssbJ57jlxie/QKu9TxusoVOJkYgAYDPafD1fY4nR0Lac7UMqtcVBBEYwPIOwkr8
wS52iiB7SPsxZecQFCGUsl6myPEVGqVQ7XGsdo6soOKL6TGFF2IKfYNc+GgrQ79B
eU9acA+3xOcgOsJPhv/GqhSr7naV0nFgM5TxAJwGzLsKx9fYWAtnTRsanVEC28kh
IpQuALUM3t7cslebsVwN101NWIQhgqR4JZu0H2l0WHBfEMFsQYqVD+HZ52lpWRvU
nEVTfyIuK8FTeltIHO658Flg712Jw4z9UUgEM3iPO2YvV4GVTfe9g0VOMrFGBJOJ
uL2IMn2heIyzLh/bhkH4n2y4vDv4arjIEo365PgU6DS8sUfRCT/b0/1oV6J/WMez
Xy/a7Xkn+ZYiEIJHbmIMM794uF2MIRT3dAI+2hFTkj4p9txHHLG+/ly7ahk0Zevc
NInoNvBhvZHjN0FuZnvS
=8Twg
-----END PGP SIGNATURE-----

--=-/pCzRBFv2DFm4cCn8Aqe--

