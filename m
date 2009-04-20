Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59700 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbZDTUbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 16:31:25 -0400
Subject: Re: [PATCH 0/4] mac80211 powersave work
From: Johannes Berg <johannes@sipsolutions.net>
To: Davide Pesavento <davidepesa@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <2da21fe50904201326m3d843b64u1c3b56d2593bb7cb@mail.gmail.com> (sfid-20090420_222651_059133_FB461D0F)
References: <20090416111723.904720021@sipsolutions.net>
	 <20090420194430.GG3369@tuxdriver.com>
	 <1240257188.4632.19.camel@johannes.local>
	 <2da21fe50904201326m3d843b64u1c3b56d2593bb7cb@mail.gmail.com>
	 (sfid-20090420_222651_059133_FB461D0F)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8SnfMT5ARVPq3uD1kzHx"
Date: Mon, 20 Apr 2009 22:30:50 +0200
Message-Id: <1240259450.4632.20.camel@johannes.local> (sfid-20090420_223127_996713_4471A3B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8SnfMT5ARVPq3uD1kzHx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-04-20 at 22:26 +0200, Davide Pesavento wrote:

> As I've already reported [1][2], ath9k is currently broken when power
> saving is enabled, at least on AR5418 hardware. So please don't turn
> it on by default yet.

But if that's just a hardware/driver bug shouldn't the driver disable PS
for that combination? It seems wrong to disable PS in the stack by
default just because one driver has a problem with it, when that driver
could just unset the PS support bit.

johannes

--=-8SnfMT5ARVPq3uD1kzHx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7Nt4AAoJEKVg1VMiehFYuxMP/2OXY9Ga6KAknNA9u+8iS+U2
H0tlj+wCBWAXRPl2c/1fBicHTAnni76T0bbIJffLHzC6NNmO8Bmg7iy+VKoKC58q
wNPrWh3POjUO5TF5lR+/uLk9n/n057qo7C4P08wzXEQnb3ccW5cqvTSg+/fvPlID
VuyJpUwr47IcIR6PBV3eDl9cRQguagC5nJm6e4poCgzpTrQow8ZZ09QGYreo+e/8
zvtAOBbRa5W8ML8cRBerV61ew+W/n+09cptgcwOAdsjMZ2Q8miAsEM4O7z+i8ce6
6jp9MJKjf2xu3P3dbZJJj3UkoNTnZ7e7G0lRlBVXS74wldlVw7IhML6NClLsxLaK
zBgCnPfs4SFVPbscqFQersYhl66DKuam8j6tZg0wOc9nEAC3scGg4R+1Ox0/ofd2
4eE9+6u2C9FyAwLlS7+IlQWI3+t/u/rpm7ZEZAmtLaellEue4Z2PMGAhvLa4jhq2
RfDQEn5OVtG2BmOQrRJAoYEW4IKg6pUWc46OBn0/ThQGZxsBIyu4h6w4mCa7LW+2
N/0+SrcqnXeLEEzo3oSbha9CspYkK680ejwalhcVJGTBZBxTVinqciCNp/Z8cHya
zRIhs+IA4poHsHx5uPLMO2+fvG7JiRRjgYK7acjJTu7gwNFzRkF/BeSP3potibUO
TA+YDu8tr+A6fJTYpf/C
=FRAY
-----END PGP SIGNATURE-----

--=-8SnfMT5ARVPq3uD1kzHx--

