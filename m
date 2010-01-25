Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab0AYSiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:38:54 -0500
Subject: Re: [PATCH v3 1/1] mac80211: tell driver when dtim change detected
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, wey-yi.w.guy@intel.com,
	linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <1264444604.23766.55.camel@johannes.local>
References: <1264109996-15995-1-git-send-email-wey-yi.w.guy@intel.com>
	 <1264186981.2593.10.camel@johannes.local>
	 <43e72e891001221120i79c6525bo4852cb5a6c7a37@mail.gmail.com>
	 <1264189560.2593.14.camel@johannes.local>
	 <43e72e891001221544j1b1bd67ao8dfcf4d0dd12dd81@mail.gmail.com>
	 <20100125183224.GA19528@jm.kir.nu>
	 <1264444604.23766.55.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4oYvzBO4/nemihWCobBx"
Date: Mon, 25 Jan 2010 19:38:47 +0100
Message-ID: <1264444727.23766.56.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4oYvzBO4/nemihWCobBx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-01-25 at 19:36 +0100, Johannes Berg wrote:
> On Mon, 2010-01-25 at 10:32 -0800, Jouni Malinen wrote:
>=20
> > Anyway, that is just asking for
> > problems due to the way a specific timestamps are defined to be used fo=
r
> > the beacons that are followed by buffered multicast/broadcast frames.
>=20
> That's actually an interesting point -- does anyone implement that
> properly, or is that just a side note in the standard nobody even reads?
> We certainly don't in mac80211 since we don't have that level of
> synchronisation between the TSF and the beacon get function.

And, in fact, the DTIM count is kinda useless if one was to rely on that
timing requirement, so I have a feeling that the intention of the people
who wrote this bit of the standard wasn't to actually impose such a
requirement.

johannes

--=-4oYvzBO4/nemihWCobBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLXeU0AAoJEODzc/N7+QmaPg8P/3qC2vPP0/rWF2nomnwQhZMo
Wla/qvk17/9hydGfCbHx64ByM80b3vZ8xT6w9pn3ZlonHG42kJbudxdKiK3wU4Tq
0suCnXDGvxFDxg0saZ8kHPxwlr0P8beTe5VGLnNP24NTtQSPBVZfqxDgtcgmAXws
G3gGrvJBhptoNyzWuIz5RYGD2ihfNGNPT0bAQDRerQ5y7m7nD0ROMlw0lE6ypfGa
v5X4KSyWb99+7F64E4VJ0n4zmQTXrfXg+ZmCD64IR4dWrVM49jw+2kyJLx48suQA
ThbvjK4fP/1PPHTsmhGLft7hBaMo2qX3OAz0Ob8tGPc56KEGDeZsYzrsuHxZOu7x
0nR0frGCXRgF7z1dv/KPtOgMWlIIETPg+fHi4KyuHGxgRlu2xKHC+9OSGMaGN5V/
D9irRO9GlFjKKVa1KNk2Qsp45I2mmbVehSKnvQiBAE2/sr9kpRelr2aRwWrSqoO/
xYUtkcF71zIYyLx0WaVvPN97r9NRpFHLAHSNwQnGaL3rbBNqqKkYq+oBMX3JmoYG
Q7QzJ5iEVWFtgr/OEUqd2xXyNK9d/VlD7quUx913qUChmamyksBMmD/OgHnSVVBf
HUSl7IwVgQjYOl5nvy4vgd2ODkBsTEJwpyJWYCz0/om6IlELb0mZPQ+HxKH5eFHr
QP9dnPOuFanHa/flR906
=OpJj
-----END PGP SIGNATURE-----

--=-4oYvzBO4/nemihWCobBx--

