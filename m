Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0AQUAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Jan 2010 15:00:25 -0500
Subject: Re: [PATCH 1/2] cfg80211: add a callback for querying the
 operating frequency and export it through nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1263758236.28067.11.camel@johannes.local>
References: <4B536B05.6070301@openwrt.org>
	 <1263758236.28067.11.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/xxdCXtBDvicWlScxjHe"
Date: Sun, 17 Jan 2010 21:00:23 +0100
Message-ID: <1263758423.28067.12.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/xxdCXtBDvicWlScxjHe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-01-17 at 20:57 +0100, Johannes Berg wrote:
> On Sun, 2010-01-17 at 20:54 +0100, Felix Fietkau wrote:
>=20
> > +	int	(*get_channel)(struct wiphy *wiphy,
> > +			       struct ieee80211_channel **chan,
> > +			       enum nl80211_channel_type *channel_type);
>=20
> Can you do that per netdev, please? We'll eventually get into having
> to support different channels on different netdevs.

OTOH, where is this really needed?

If you have an IBSS or managed mode then you know from the BSS info what
channel you should be on... APs are completely userspace controlled
anyway, so are monitors.

johannes

--=-/xxdCXtBDvicWlScxjHe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLU2xTAAoJEODzc/N7+QmaUOAQALhU4/sLtx0IVTM7xXfAtyB8
Lz5g9/Vq8CDK3fi0z96HPmh9GqCds4PenSjHlnNi/8XMD/WB53UO9xhwYB6avyAc
iWoa0TMQBRqZn3/9M6QX8lXp/sXMQfnBqJlCl4B6FetWVsNaOKgJV8fKkYWktkBc
c2dSmW9VIczIcGfiONHN+1QvXyqY5iz3i/+J3yZrHQ2CVJWF6a1cdE9SHD5PLq6D
SsSNGkb5Lc/mPfF2yHPoefQqIopSx2Rv0L/MpuKUy/4XNoifnWjTjcOJKkYJVolr
8u7KZkW7AfG6qGdYpIUo8TENNbhoRqb0vnDtHyvChI+DJOb5DreE0BQcmUdqQeOo
gVOQ3pydNpUpr4PTgFZfUdIyHvYsvkjct68J116h+Dp1QXYxQQCdoygQfHr9gnrE
ngdksmoYHp8tS4T5J1+AdnTunKq6tseHXPCBH6HW09a+l0WaufCljgauc6AmO2ya
SaC3U4iZxtjGTkK5JJI9XYbPSPzA6ZIhnj8s8gAuhw+2CiQ+bAVB6cyJA12eGlyy
YIUkebd5RblN74J7ntozvBtUmgmIUvwSrt9KCahoZtH7pA4wYT1YcP+tXtE/RUTQ
je1E7hfFOD6oZcM9WtbaC0mf9Bb02SKNM9y1XiqpunDQot9TzfjLYpM+EzTZtuxv
kHXPqUEB+mwcn4UhT7EW
=KWZ6
-----END PGP SIGNATURE-----

--=-/xxdCXtBDvicWlScxjHe--

