Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:50823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbYIPIMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 04:12:49 -0400
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Helmut Schaa <hschaa@suse.de>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <87r67kzf7c.fsf@nokia.com>
References: <200809151416.07552.hschaa@suse.de>
	 <200809151634.06448.hschaa@suse.de>
	 <1221492529.10177.76.camel@localhost.localdomain>
	 <200809151845.35841.hschaa@suse.de>
	 <43e72e890809151821h5d40e750q10c78f4d20d27c79@mail.gmail.com>
	 <87r67kzf7c.fsf@nokia.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-BnBk0pPX8+Gi/2URt+Om"
Date: Tue, 16 Sep 2008 10:12:07 +0200
Message-Id: <1221552727.8916.19.camel@johannes.berg> (sfid-20080916_101254_173682_8B09DD7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BnBk0pPX8+Gi/2URt+Om
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-16 at 11:07 +0300, Kalle Valo wrote:

> From my point of view WE is not on life support (yet) but instead very
> widely used. As an example, I still haven't seen any cfg80211/nl80211
> user space tools in debian unstable. (Please correct me if I'm wrong.)
> There has been a lot of talk about cfg80211/nl80211 but unfortunately
> the migration progress has been very slow.
>=20
> I definitely want to see this background scan support in Wireless
> Extensions as well, otherwise it might prevent the real use of the
> feature.

However, the more feature we keep stuffing into WEXT the less incentive
is there to actually do something about cfg80211. I'm with Luis here,
the fact that there are no tools anywhere is because those tools aren't
really very useful yet, not because it's not possible to get the tools
in.

johannes

--=-BnBk0pPX8+Gi/2URt+Om
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIz2pTAAoJEKVg1VMiehFYgrwP/AxjrOgKZgRVysgZuy7qEJKd
tvmHrzVkmwnoJBe8hxzVHcSGyZddFcLCIUCjNxbpfukDJ4adB9J98OJxfLw08XUj
U/qYrOlaKM6gx7p3e5PtK4exjZUiEgQ6HcJ+knXbrJRz1IgnCugUEnRzDE3re1nO
00Uw0z83U+ukGorknuQIJEPbsFbreR8kDh766soJ8V/7el92bJYxcq41yauORYiv
eb00naj18sYv4fmF9VtlsUbzHraNZKw0GR2whRi3e9FH8G+WXa/5K2Iihk58VpHe
8YkSgZLqCt4T2N4MBmLY2xXAzukR6WPFc+tzArfsewrhd+OL3pYx2BiNIiPUTN4Q
c5xZxhz+7EpuFzd/qq9qXuRVlj5sFZ76PZ6eOx1QHTsMgJZRbs4uHFpF/8zg0yPW
waXQMZsLrbigl5tJh+eG55QCvZ7XDdCRTTl3Pqghs+46cQ6xTxU+6qGmgDSf8RQG
FavUnaB4tlwKhrnw7NAKsmTj/Q7ZW5JKiT1M4JGxeF9Taepo5IsqmG7OxOcCxXvZ
AViVKSm6M55ziShYWq0H9Y09wO3ORDxwwGxzeXD3dXQKOK7aqDR2aMox4o2Z93aw
BqwStZIjgNfbymMEXrG5NsfO9D9jkS2sDc0bvdk6+KSfHpv5i9UGe7NvAYdUt6Go
7MCPzimtodgbQUonocbN
=+vnD
-----END PGP SIGNATURE-----

--=-BnBk0pPX8+Gi/2URt+Om--

