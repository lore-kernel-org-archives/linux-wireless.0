Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbYIIJzx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2008 05:55:53 -0400
Subject: Re: HT action frame code
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Jouni Malinen <j@w1.fi>, Ron Rindjunsky <rindjon@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240809090252u44c5a016m98845379ac213df9@mail.gmail.com> (sfid-20080909_115204_233180_2C2D2255)
References: <1220883730.31304.60.camel@johannes.berg>
	 <48C5868B.8060103@w1.fi> <1220942004.31304.101.camel@johannes.berg>
	 <1ba2fa240809090114u67086f2duc5cc9addd384e30d@mail.gmail.com>
	 <1220948427.31304.107.camel@johannes.berg>
	 <1ba2fa240809090146p612083aclf3a2a924a81e75e9@mail.gmail.com>
	 <1220950358.31304.112.camel@johannes.berg>
	 <1ba2fa240809090241g2604e3ddhfd39359fd8eb0f8b@mail.gmail.com>
	 <1220953379.31304.124.camel@johannes.berg>
	 <1ba2fa240809090252u44c5a016m98845379ac213df9@mail.gmail.com>
	 (sfid-20080909_115204_233180_2C2D2255)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HYSIoukj14MB+Yx9+z1I"
Date: Tue, 09 Sep 2008 11:55:45 +0200
Message-Id: <1220954146.31304.127.camel@johannes.berg> (sfid-20080909_115556_231835_347D4BD8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HYSIoukj14MB+Yx9+z1I
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-09 at 12:52 +0300, Tomas Winkler wrote:

> > Well yes, but that just triggers when aggregation on our end, what I'd
> > been thinking about was when the remote side wants to start aggregation=
.
>=20
> There is some misunderstanding. I hope I'm explaining the problematic
> part.  Aggregation is always initialized by TX side it's one direction
> only. So if there AP and STA wants to start aggregation. Both will
> open a stream. The streams are independent.

Right. And if mac80211 is the AP, then I don't see how the STA can start
aggregation since I couldn't find where the relevant action frames are
handled. But you said it's not part of the code now, so I couldn't find
it anyway.

johannes

--=-HYSIoukj14MB+Yx9+z1I
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxkgeAAoJEKVg1VMiehFYTSAP/22Z9jNg61gDs5b4pKdMR6IT
vb6n9NKsC6NkfBWKIGRZFcQ+ZRPxxuufTeby7uKeZG5P/ElCvbxP3Egfyq6hHRxX
0cYDIJAK3Ot/oAnQQIW6aq6eQ42vh6tx6HwkFgAD9d3aGZJfri8/l5uBA//rQmoK
susxm7lSSqflIMGn66TWC0RI55WIlng8fE9Tk3vqpuDet0NabSRVIOU0Ovd/SBAY
fDVWFsTX7hrarGISU0y5syqsvmrZOrHLS78vmzsAZTKUDYLYedNu3B5kmQd9Q/m6
FqiEBTQT4631q55vCmVfQAmSk+c/UqScnlTvzNjmfjnzxeIhTlsT5vYMUcWnzqgP
2Ia+PTlF1yNLk4odkWmsq9469wHUze6jq7upPyCdna7RV3LOk3qEQGElDUlbrFCK
FGHi3sh5l3ufimqdWXSzeGtJaE9ORzfBzGSlzHrednMPa0ca3uP3EBe64nEMVduC
xN+Yuy2Zc4VJcuz3sQuuzkYJBm3cQI77i7YTOQvvUm+e+qOqxM2va79bO70Pa7Hi
G+fkKbo17NorjSYy9LakUF7xskYvnpTtDMDkjbqPSDRoK0XKAhziBQeya7VFATih
6H5vjYrrQtGhDxPfJynImE3TFoohdZJJeFsN7QKBXGYLp1iSAFoMeXUKnAT+Zisa
/Y0/dmic7VwmDoij/Rk/
=Zflk
-----END PGP SIGNATURE-----

--=-HYSIoukj14MB+Yx9+z1I--

