Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47977 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbYLLWhy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:37:54 -0500
Subject: Re: [RFC 0/3] cfg80211, mac80211: Introduce radiotap flags for
	finer userspace control of injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <69e28c910812121432k1e8732bcma77e489d247ecdf4@mail.gmail.com> (sfid-20081212_233239_864570_76D3B7E9)
References: <69e28c910812121432k1e8732bcma77e489d247ecdf4@mail.gmail.com>
	 (sfid-20081212_233239_864570_76D3B7E9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ny+vrxRdGg5SnGYvEPOv"
Date: Fri, 12 Dec 2008 23:37:46 +0100
Message-Id: <1229121467.3565.2.camel@johannes.berg> (sfid-20081212_233757_413993_469C6010)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ny+vrxRdGg5SnGYvEPOv
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 23:32 +0100, Stefanik G=C3=A1bor wrote:
> Userspace packet injector applications might want to transmit packets
> that are, by design, not supposed to be acked. In other cases, an
> injector application may need to control the sequence number of the
> packets it transmits. Introduce 2 new flags in the "TX flags" Radiotap
> fields, controlling these 2 behaviors.
>=20
> The new fields are as follows:
>=20
>  * IEEE80211_RADIOTAP_TX_FLAGS
>=20
>    IEEE80211_RADIOTAP_F_TX_NO_ACK: Transmit the packet once with no waiti=
ng for
> 				   an ACK and no retrying if no ACK received
>    IEEE80211_RADIOTAP_F_TX_NO_SEQ: Use the sequence number already presen=
t in
> 				   the 802.11 header, do not generate a new one
> 				   in the driver/stack. Useful when injecting
> 				   fragments with the same sequence number.

Umm, these aren't really defined by radiotap yet. Does all of this have
to be NOW?

johannes

--=-ny+vrxRdGg5SnGYvEPOv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQue3AAoJEKVg1VMiehFYYf4P/R1nA9eHLSlHp+DW/PXz/L2N
8NBLPJkNd8exLhIz2I73bT6Fxxj5aFQ67W0ATgfnk4hQbbAc6ZU9tjpIDp+y84XD
CO51F8RhwCnizbbe/KssIgs7hM/RyTR9wv2o8ZeaYQw28YLYVPAcHsO87J3hzcOf
HE8cbEJwllaLrdCUqTw4db9PSbr7WLK0cjLUIS0eaXKxuJ6TbTzd62N8EtdDP00r
Ms9Al0kznh8sFRt5Py4ykWJIH32oyXujF5AB+fda5VhSM7fZNhGakzahNHpH2c3X
EkV6bRseobe3U8R06c/3r/ph3Ou09LTGY936G3LXMclV7FZSm8hCHw/1lnGyWPsc
23x8BDmnls7tLGL4/fD/GQjpQJSJZKWlaa+taTnRTKvf5CLX2jety1MkRusxLRtB
ywXyG4EKp+/jDIMALclmO5Y+YpGCdz0D6tMSz9rqkPZkqDSpxJpSmqdK/NRjz/iP
EDH0N7wRghl0PhgTjq96r8b2fdLm+uCGPEAalQGONZUNCzHgnFtV6hz8uqohxN9T
GwNVYr7oRE7Nz4hLL+5zK//3DtzUhkcgffCSA+H56Q9I4B2bcoOUM+eT/egmDozd
bRfmfzMH3KVqnbCJQdV5UJr5ZSuDXyXvvBG/f6qDUwQn05yrmCplZefqYG6AIm3Z
0HUKtE7r3fl2PTuRC7+i
=Ej4k
-----END PGP SIGNATURE-----

--=-ny+vrxRdGg5SnGYvEPOv--

