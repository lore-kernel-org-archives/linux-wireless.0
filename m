Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41492 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbZG0TL0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 15:11:26 -0400
Subject: Re: [PATCH 3/3] ath9k: move workqueue cancels to stop callback
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
In-Reply-To: <1248720784-15671-4-git-send-email-lrodriguez@atheros.com>
References: <1248720784-15671-1-git-send-email-lrodriguez@atheros.com>
	 <1248720784-15671-4-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-fBBQU98btGgo1pW9/xY3"
Date: Mon, 27 Jul 2009 21:10:55 +0200
Message-Id: <1248721855.32365.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fBBQU98btGgo1pW9/xY3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-27 at 11:53 -0700, Luis R. Rodriguez wrote:
> We should be cancelling our work at the stop callback since
> we are borrowing the mac80211 workqueue for our work. As it
> stands mac80211 expects this for suspend purposes.
>=20
> The ath9k specific virtual wiphy stuff need only be
> cancelled only when the we have no secondary virtual wiphys.

inverted logic here?

johannes

--=-fBBQU98btGgo1pW9/xY3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKbfu8AAoJEODzc/N7+QmaS5YQAKsuUbV4KvJB7dcgK8meiwe6
mleI8PytU1VJtwRQ82pnPnIFQJFWz1u38Uz3ID0v3Nl0VXh5b0ys5d9Weuz8KN+h
ysbiyGhESTZAwBcU7xwIUsu2c2rpEJcofFPn0AbDoFnkTxso4tqtyDsa0Afpdyu1
l7B6uefId4wnpXmx7PCFs1vv8MsllfBsT5FJz9OMne4DEaXnlXnKcS5NYa7TJ8xg
TVnsNmOPx9uCw1PUt47JwsLk5WUVWpSlgWn4yjpWmSpdBycJM9rBB5FUm0juyh9m
OqgS4+6U4xpwuP+3nc2L9ySp4xsWG0+yQA54tkrMtRXlK8v66v36QDugi3BT0ZNu
taq5CUsUwRbS5gDUHVr2ZymNcAxOD3e8Wy4tNfdAQDcx3+yU2JvVvlpZLu6T4trW
jIWKuCubCnvvjjznsY5G/vPljBvWZWA3RxzZq8BEPBHQY4/f+qnTHGWIk6lHpV7x
3BoVgvvMYp5jCpDaws0tgVD2tr5yzaX/wQYk7VOL8PkIGsnDUHBS6A60WnzOmhp3
+TmhWG1I5K3szs4lt5YetdF8tNfzUnvXqjFOQNMBdNU29zUPnAX2HCGJbN26wF+D
6NsKb6FlfYxJ/ThE8nVnRb40H/zR4fXHKZTTl9y2vQsMEd9ShgrjRSrWFoEaHwW/
JckfWkN6a6nOV7zg+iot
=1VgR
-----END PGP SIGNATURE-----

--=-fBBQU98btGgo1pW9/xY3--

