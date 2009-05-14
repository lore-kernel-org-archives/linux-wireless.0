Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54431 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZENUxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 16:53:54 -0400
Subject: Re: Scan while TX/RX'ing a lot of data
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com
In-Reply-To: <1242334231.4227.126.camel@localhost.localdomain>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	 <1242327298.4227.25.camel@localhost.localdomain>
	 <1242327995.5799.4.camel@johannes.local>
	 <1242334231.4227.126.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-l3EsS5D3dNSY2TEEugEm"
Date: Thu, 14 May 2009 22:53:22 +0200
Message-Id: <1242334402.5799.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-l3EsS5D3dNSY2TEEugEm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-05-14 at 16:50 -0400, Dan Williams wrote:

> If there was a reliable mechanism to figure out whether there was a
> certain QoS level of traffic flowing through the card, this would be
> easier to do automatically.  AFAIK all the APIs these days are
> socket-based, and that doesn't help us get from app -> interface without
> a lot of intermediate steps.  How does mac80211 figure out what to put
> into each of the 4 buckets for wifi QoS / WMM?

Well, it depends what you need to do. You can use
setsockopt(SO_PRIORITY) or like ping -Q use DSCP

johannes

--=-l3EsS5D3dNSY2TEEugEm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKDIS9AAoJEODzc/N7+Qma1RoQAMZuP2+9R0QkDp24h0pFrXZK
4Q2/feE1/p1k6NiZp8uWk+a54DTzFsku+KJj9nNNCzwpnvMbrPGWjH1sqA6fZDl3
yEEcJlJRZ22V6GxgBS9wXX7CW8/5lmgjM3dKYKl2twu9DtCLYpF5OPjhQlgjKumh
M6hCn+JSgM2Wm3/OW/5fbOTWF3mkDaBvSHYiI0FXfxRpfHneZ5Y40fk2IALsmriK
AGW0SikmeZ4A4pKW/112K7Dn99Xj9LIxmGKoRIiD9lR3wV3DzmjS7yDmHVNERv03
rQN3+jCl+MLoaPQ7k3BXr7i2WwBR7+uBRKcaWIU/MVkcPh+hGkjK3Fow0ZbEOgmz
/mfFkgzc2wg4y/URdiyh3LfNOkaUCJXyTiyQosvA9TL5oOZ5CRnibG6BEOOWEXzX
tujwNKqEzroseQ41wYeGUMepqQZdRgDQN2Xh6onNiHdanuw/vNAdgWLra95KX1iY
MKq4g9xeB9oiwIHBMD56ZYrkFstgcgQ789ErgnWueBpNND+q0+T//XPPAbWJsleE
DIT1A3TpnYQhcmb8owDNVM5BKZcBVF3VH1U+zx94VE72igXkJAnedFWE0du0ijpe
16hZtW9E9NXLPW4zMXW4OGGuvJ+yq5f4iIxu9yTwco9Y4P70x13euA5RUZl7VFjR
IeuMGqFQ8MEM0sXpyY1K
=7cL/
-----END PGP SIGNATURE-----

--=-l3EsS5D3dNSY2TEEugEm--

