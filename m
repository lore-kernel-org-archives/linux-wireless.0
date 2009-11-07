Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34540 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbZKGTWe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 14:22:34 -0500
Subject: Re: [PATCH] mac80211 : fix a race with update_tkip_key
From: Johannes Berg <johannes@sipsolutions.net>
To: gregor kowski <gregor.kowski@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <83a869cd0911071010g32c798c6pfecd875a1bf484e0@mail.gmail.com>
References: <83a869cd0908211513k2e14ba40k251aa8a1e7393a77@mail.gmail.com>
	 <1250927141.23605.3.camel@johannes.local>
	 <83a869cd0911071010g32c798c6pfecd875a1bf484e0@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4nfeXg7O4310CGQmDz0x"
Date: Sat, 07 Nov 2009 20:22:37 +0100
Message-ID: <1257621757.29454.48.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4nfeXg7O4310CGQmDz0x
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-11-07 at 19:10 +0100, gregor kowski wrote:

> >> +enum ieee80211_internal_tkip_initialized {
> >> +     TKIP_INITIALIZED_NONE,
> >> +     TKIP_INITIALIZED_PHASE1,
> >> +     TKIP_INITIALIZED_UPDATE_KEY,
> >> +};
> >
> > Those constants and the enum itself really need better names. This way,
> > there's no way to understand what it means without reading all the code=
.
> >
> Could you suggest better name ?
>=20
> ieee80211_internal_tkip_state and
> TKIP_STATE_NOT_INIT
> TKIP_STATE_PHASE1_DONE
> TKIP_STATE_PHASE1_HW_UPLOADED

I, eh, ... have no idea :)

johannes

--=-4nfeXg7O4310CGQmDz0x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK9cj6AAoJEODzc/N7+QmaKfQP/2v7TqVLptaHKxuoNdCvChFY
UerkBvr8FT2/5Vjr86ZXFEpIJLzx+RzbYQA3QRM3A8Bbt7ue4daEuRS2Admkm991
UB+XRs/Xp8Qfhqe8jnfW89FdZ8Zg3pK4FSpp2QiQZyTUGAwG2yBs0v5ItARyHHvu
mNKvW03PhD8tkyCbfKurVzm5SDF7uLEp0MHq0ObmF5mC4RwGOL3YyhcrUi4iVa5L
JS7TQTB5AZ226+wl4q1r2+yw0lQocgzkER+hlnZ+AkNM7O0FLynaFqu5nEbKjla4
pDn4Q6y2Jn1fxZ8eqU0HN0A1oHq5rNvuoh6lLy43wzvFlmWoBnPJAZWIKVJoDybu
drZ0QkuuQnNtcw9t0UXqtqZv2O4XMpekqP151FPQ3j1I9ZVUZMLejlu5/yeeVp5u
VnjMZtvOxmiMSKfnTZOjE5tZ447c6kJk5zAlWw2YT32Id4VYwvJUgaenuObQWgDE
J5x4hwKMepN1dosd2SlD16k7BTLeJf6MWGdUCrrUQKA3fwEuru75xtETBweUG+G8
iyiZByUtTyIWtx9h7a1xGAGtMQFLPb8gA2kmaWMkjKft6XuPSGjsCzxrzZpg5FqD
vi/sKikQKIvBFfoqvVwr0AzEmclHnDIpsIX5IgtiM1UuRY5onoaSbLmSBT/7f8yR
OdkgXj20YAK/tnHVaFD+
=59Cm
-----END PGP SIGNATURE-----

--=-4nfeXg7O4310CGQmDz0x--

