Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45333 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755036AbZCNTzq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2009 15:55:46 -0400
Subject: Re: [RFC PATCH v2 2/4] mac80211: track beacons separately from the
	rx  path activity
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Kalle Valo <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <43e72e890903141245k46f4dd4co6a33b45b82e9098a@mail.gmail.com> (sfid-20090314_204515_016243_BB069A61)
References: <20090314171234.11126.21125.stgit@tikku>
	 <20090314171438.11126.30330.stgit@tikku>
	 <43e72e890903141245k46f4dd4co6a33b45b82e9098a@mail.gmail.com>
	 (sfid-20090314_204515_016243_BB069A61)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5SvAjwiuyuVKxA0jQ6Cg"
Date: Sat, 14 Mar 2009 20:55:42 +0100
Message-Id: <1237060542.5235.109.camel@johannes.local> (sfid-20090314_205549_397134_B8FDE6C8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5SvAjwiuyuVKxA0jQ6Cg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-03-14 at 12:45 -0700, Luis R. Rodriguez wrote:
> On Sat, Mar 14, 2009 at 10:14 AM, Kalle Valo <kalle.valo@nokia.com> wrote=
:
> > Separate beacon and rx path tracking in preparation for the beacon filt=
ering
> > support. At the same time change ieee80211_associated() to look a bit s=
impler.
> >
> > Probe requests are now sent only after IEEE80211_PROBE_IDLE_TIME, which
> > is now set to 60 seconds.
> >
> > Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
>=20
> Can this be split into 3 separate patches, to make the one with the
> actual functional changes easier to review. One is the making of
> ieee80211_associated() look easier, the other the rename, and lastly
> the actual functional changes. When reviewing the commit log it would
> then be easier to see what was done.

Disagree, the rename is part of the functional change, it's not just a
plain rename.

johannes

--=-5SvAjwiuyuVKxA0jQ6Cg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJvAu7AAoJEKVg1VMiehFYaRoP/1cGKsLlQKVVBeGypl8NvyFg
ht/r5AHdP1DPEoiUuhzNVnDqBOoOjHCm1VePTs2Gt+gk5sgWM40dOSfN4a8s+pAs
CRqfjonOEAxH+bUHwlikxBL/dKRbyBiucEU73QNwt+4QqJkMB3eltHyeH9enwQQo
c0QKghb8qRCzRiiVm10sKr3NkI/EqTXHBSFg6ciyk3z5HdeR4qNaD+uwRQoStfrK
Y6uz0PtHGtqF5kvEKSQDWdeLpPeXDA5rZwTo2DjK7kmJh4qhonLK+F5a1E83ytVy
U5DmZlPM7WqAiWEJy5q1U5B3AHc7wq9bVkiC9A0qRQB0ZVFUzrM3GpcdL6uc8r6g
7Soa219pPIYdR8+tofWJMj0CaWzluLB/LDFWntxh48RN3SkSOOm5tTkI6oANsDfq
+kUrYh5SN9nbj52dh6NQPZNjVD7ovDi3123KMaO25C+EIMEZl/GWrS0firKikwGu
W545/C4xJsZ7WIdmaMQl358w/lV3d6gz201Q9OQvp6EMPzmrxlRUEvva7bKsfzbq
F59FSimJPUrK2EBQmv+fQ1VKNQZClGQRbmbGj2TupFY48Sx7je/6iypxOCln0I/Z
B6x+SPnR8b+ZlWMRAh2d6Q7OKLYS+7Xlh2Nd1mtEjYnbfqVFvaak8jQZHuG6+2TP
gddUyQXyWe2LW43IPiOp
=KB4o
-----END PGP SIGNATURE-----

--=-5SvAjwiuyuVKxA0jQ6Cg--

