Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46456 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbYECOCP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 10:02:15 -0400
Subject: Re: [PATCH] mac80211: use 4-byte mesh sequence number
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <480f9318.0b35640a.0a3f.ffffc3eb@mx.google.com> (sfid-20080423_215126_615548_B37D1180)
References: <480f9318.0b35640a.0a3f.ffffc3eb@mx.google.com>
	 (sfid-20080423_215126_615548_B37D1180)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zok7zd8CWNU73+8FEDh+"
Date: Sat, 03 May 2008 16:02:06 +0200
Message-Id: <1209823326.3987.32.camel@johannes.berg> (sfid-20080503_160150_265232_3CC71283)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zok7zd8CWNU73+8FEDh+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-04-23 at 12:15 -0700, Luis Carlos Cobo wrote:
> This follows the new 802.11s/D2.0 draft.

Umm, I just realised that

>  include/linux/ieee80211.h  |    2 +-
>  net/mac80211/ieee80211_i.h |    2 +-
>  net/mac80211/mesh.c        |   17 +++++------------
>  net/mac80211/mesh.h        |    2 +-
>  4 files changed, 8 insertions(+), 15 deletions(-)

This doesn't change ieee80211_get_mesh_hdrlen. Isn't that missing? Can
you send an add-on patch (since this one has been merged)?

johannes

--=-zok7zd8CWNU73+8FEDh+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBxwXaVg1VMiehFYAQJFBw//aOwvlgayu8X5W1U70N0A3HYyKEHFbwx2
Ldvo1aYr35ykSucdcQnSWMsmotXTqxbIEibiiD8Iy7Za9lXqwruJSkhpQ1tC71D2
iqppYPkhYGTmHHh4ZADHEMjhnYSJgoyAAOmaO3PMkjLry+x2B4QzjU9LMfqF40d9
iRnGZwu/MjxBv6VootIo6QZLCSAts5nHWIYZhZnV3OgC41OYf7noS+x21RJ+3Klq
J8/rF7ahP6oOPWU9w8yKZSRSup/y/EqfkjsqeMgYnOPlhgnWIDwRvL8QapMymw/F
C1KZZsVPa/IJCdjEvZgUulwlQt/9HiOa67lGUdzkDG3ri8kwB28fP/TvdWLCBPzU
4CZn3eF4TmuNMnFx8jYArk6PLcd7PESWRjAfdQUidKujD1pe9yxH9GLfxguerjeV
iDsCJhIM1ID+ZlwRnGKQxFkQU8DOEVE4xdN/twSasbkqiw5TpbQ/0jd5+h0RSyNF
WzKg4hczrJO3iAdI0FebWjf7a92AnFF5i08z4oALmyTtEYB305XvtAo/FepjwhYr
5vX3rL6nB80orZzeH96VQ4zqbRnIbvvERwIprUbzvemmGnrRSSls1znKRHNrm1Nx
IiMQ77kFWL2D/1h3CZujUUylsGHu7FWc9xjCgd9v2T/B2mUfJcT2JcoqgnW9h19m
zLb+ippJzmw=
=HSVt
-----END PGP SIGNATURE-----

--=-zok7zd8CWNU73+8FEDh+--

