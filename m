Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56538 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272AbYLIVKx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 16:10:53 -0500
Subject: Re: [PATCH] mac80211: remove fragmentation offload functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Dan E <trg_info@mailhaven.com>
In-Reply-To: <200812092136.56768.IvDoorn@gmail.com> (sfid-20081209_213730_750098_CD905347)
References: <1228822203.22164.204.camel@johannes.berg>
	 <200812092136.56768.IvDoorn@gmail.com>
	 (sfid-20081209_213730_750098_CD905347)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AmeLBkBWWTycUNEmRS7q"
Date: Tue, 09 Dec 2008 22:10:09 +0100
Message-Id: <1228857009.1029.18.camel@johannes.berg> (sfid-20081209_221057_450944_261ED467)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AmeLBkBWWTycUNEmRS7q
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-12-09 at 21:36 +0100, Ivo van Doorn wrote:
> On Tuesday 09 December 2008, Johannes Berg wrote:
> > There's no driver that actually does fragmentation on the
> > device, and the callback is buggy (when it returns an error,
> > mac80211's fragmentation status is changed so reading the
> > frag threshold from userspace reads the new value despite
> > the error). Let's just remove it, if we really find some
> > hardware supporting it we can add it back later.
> >=20
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
> > Unless anybody knows a work-in-progress driver that needs this, in whic=
h
> > case we should fix it? Speak up now if you do.
>=20
> For rt2800{pci,usb} the set_frag_threshold is not implemented, so it won'=
t
> provide problems with those drivers.

That's why I asked, thanks :)

johannes

--=-AmeLBkBWWTycUNEmRS7q
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJPt6uAAoJEKVg1VMiehFY7oQP/RF59qSdcA8q/DJ/Iped7CtM
WlQZIEShH4VS0eNhBkAXieTvvD/PoyH7K3Zjp7REq5Y0QJqFIwEV1wqv7aC+DjEv
TgMla13sk6cwCCYVT+s16sgiKG7Sf1h1CZC5UkBN/LqnC+8NKnudQO7ypDLhYjo9
/sQYYG4FfncG/twYZ0xtDJw3TF4moWDxTrqp1cAxfBx51vwKya3+ReDF8t39uNKI
CUs0Wz89fGmsNCMo0dT2Fpr2UkBagfHe3l/xbJ+A5lduGfc3fD335T+EQrcUSM6n
lGitBo4b6rXY653rrjmojJ4pTPlc2D61BwEyQUM7kLqXkQVu2ahXZxsod+6xyhaf
PlvnzBvO3bsbggAcWvFDE1yUzXBY9kdkFCrMuUxfXfI4JAtfnhifjnFjwUygUqsD
VEo1AoSSciZEb+LXbZPptOVJVvnE8+5eSX6Nkeo8clUhPZx9koI4olO0su/HjFVG
ZI9uuaQIFk97HxWxEgym9FxXpexTk20vVP6cpHgK9bOM/jIe/rQzIMGanmoTm44s
UT3kzDhArFE9BM4LHMkxR9Eiqd/I5nTseoxtbJkCBdjfkSZhI0LZDZMGR/PrTaCt
x062lwrccg4ugWCk7oLQBGFFCqR2HcecHJiSiwmmvW+znWKy5f1NW7Biqy1EcEEm
XUcrvwzmiEtXJwIHnY92
=QeeE
-----END PGP SIGNATURE-----

--=-AmeLBkBWWTycUNEmRS7q--

