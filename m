Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33204 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbZCJIqh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 04:46:37 -0400
Subject: Re: [PATCH 3/4] mac80211: disallow HT40 if max channel bandwidth
	is less than 40 MHz
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890903100143i76015377x31529b26b638275c@mail.gmail.com> (sfid-20090310_094347_614763_9DF90444)
References: <1236650699-30538-1-git-send-email-lrodriguez@atheros.com>
	 <1236650699-30538-4-git-send-email-lrodriguez@atheros.com>
	 <1236669329.9658.30.camel@johannes.local>
	 <43e72e890903100143i76015377x31529b26b638275c@mail.gmail.com>
	 (sfid-20090310_094347_614763_9DF90444)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZCAlq5QV9bN7Ab6GRZ/D"
Date: Tue, 10 Mar 2009 09:46:31 +0100
Message-Id: <1236674791.9658.36.camel@johannes.local> (sfid-20090310_094640_348269_A58A7480)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZCAlq5QV9bN7Ab6GRZ/D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-10 at 01:43 -0700, Luis R. Rodriguez wrote:

> >> +     if (conf_is_ht40(&local->hw.conf) && chan->max_bandwidth < 40)
> >> +             return ret;
> >> +
> >
> > You just made nl80211 check this, why bother adding it here too?
>=20
> Wext crap.

Wext can't set ht40, it'll always reset back to 20mhz when you set
channel with wext.

johannes

--=-ZCAlq5QV9bN7Ab6GRZ/D
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJtijkAAoJEKVg1VMiehFYAIEP/3g86qha2u7GbboHISG5Ev5m
piwSGA9bo4o/AKRemU5fJ298CsoFdvKU4FPl9RZmh8ogCsNbGw/vLRzjw1uZ6XjV
eFZHZxMdcdkaaMNjTuPxEqpyf3j+wwzK+g2tC/lKii7SkSOJnpEj6GhE4pJvL6sJ
79QADwBXcv+a25ZoQdi3zWhs5f2x5GlxtFzIJ1EqPtgYEvxsLM2H/FbE2vYKkSBV
dY1SIs4rjz4QYWm0OxaJGLSghoy4v/OtZLMmO+HGtDKzHT7WzN2nLFbKyhfpHi7J
GqKgJG8mL7SpgAy3tJh6E/HldaTILxSv7g1kREZ6A+JtAdGVb0riZrKPobCI+UBY
gtSfAUInnU3Q5Bpm6kBDQiCiWAi3Udfc/+Djsw1aJyZAlqR0cFDGnnZpGQe/Luo0
m72IlCbYyIymX6QL+OQQ7lpQjaaljOrjkSOxGSnRz7LfbXFspwYgWR/5lmRAMRR+
+3txzibqVkh1ITymBKFtTBio9LsRQDbPgYV7mHbcC+a6VI9WFnnzZG+p/7XfNoKy
BRPKe+hgKc9vJ162qooM3QrJ39ktK7Wn8Cm9f2fUvNqU8EYQ3HG84WWTq5XmsmYB
zuZCGtsytKsJJfwnazZcMXRAL9F4Nrwf5snKfeYlYDLJEnYuIHOIOqdU5na2bU8V
YMDgf/nhvWYsI5eJ31NP
=1g9G
-----END PGP SIGNATURE-----

--=-ZCAlq5QV9bN7Ab6GRZ/D--

