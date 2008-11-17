Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53421 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbYKQR11 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2008 12:27:27 -0500
Subject: Re: [RFC] mac80211: remove ieee80211_notify_mac
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: John Linville <linville@tuxdriver.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <b6c5339f0811170908u2f5eb552jbc23cd50871186df@mail.gmail.com> (sfid-20081117_180817_823011_14322F6B)
References: <1226915999.3599.33.camel@johannes.berg>
	 <b6c5339f0811170908u2f5eb552jbc23cd50871186df@mail.gmail.com>
	 (sfid-20081117_180817_823011_14322F6B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Uy5gsv+LlYJ202CJgaJ8"
Date: Mon, 17 Nov 2008 18:26:44 +0100
Message-Id: <1226942805.3902.27.camel@johannes.berg> (sfid-20081117_182730_979603_5435A52E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Uy5gsv+LlYJ202CJgaJ8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-11-17 at 12:08 -0500, Bob Copeland wrote:

> Deferring stuff in resume until later sounds like a good plan, there can
> be lots of surprising stuff there (e.g. I didn't see this yet in any
> drivers, but if someone happens to request_firmware in ->start() and
> there is no userspace yet, uh oh...)

That happens for sure.

johannes

--=-Uy5gsv+LlYJ202CJgaJ8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJIalRAAoJEKVg1VMiehFYgfoQAICiFfvJa4l1xalr2tJkSONs
iZrJg3/bm1aXiGr2bFCZeth+MuBppTbDour2NYzYvL8BSEh5reYLqc8DC6mKrW69
kUAnZkDhjp7yYw8eG0DhAyfADPuYQkA5MzmSsujBTd230XYVQDrnfevleC+hCDbJ
H3uY3XiwYk5MgEsp83uGId8MojebS/yuim6a1sHEIqe5o+6zdqXjYdoR4Bcp5/Aq
ykYb4fA9bG/MCNO611ulySGgUZHwJeZm3R1XA9DtDTzr81446/bYsJfVsvB+54Mx
gG9CdUHGBKcgf+eZnhVeVfE3ztRfP0sLTpakiz4rPgvq7te/epSV4GdOV02JARkq
y9YOf3nHZx3GvGv5+/msr1DwQBn2AKoGV7XFlujYgg4l/Njb8NWRa5SDaWxB+xV2
OIeWC5K9Sq8uaghJq6j04kHEc0sYbBF4QTRrm0kvMQt2lNHwMv7jRSOS4No5iuCE
jpkfZxE2862U8bC6vlPQXsHy24o4QANVNgVEqfLXqvffyuyZuUAynr2iIgiMknoA
xzggMuFLznY9pk+WnzAnhbJmeR6NK1WEBW5KLOa4nf5opr5Ax0U+MtnTSh+GAxmt
gsl9ErUkD6GbWu52mPCtyoAGPjim8RT9AzX1WnfDi9DPgtXbBrBf1WeP1G/xTb8e
Haz5PsmWouK5bZYv20LA
=bC+g
-----END PGP SIGNATURE-----

--=-Uy5gsv+LlYJ202CJgaJ8--

