Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbZDGIQw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2009 04:16:52 -0400
Subject: Re: What is needed to inplement a AP support in a driver?
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1239062777.4705.30.camel@maxim-laptop> (sfid-20090407_020641_627468_1583988E)
References: <1239062777.4705.30.camel@maxim-laptop>
	 (sfid-20090407_020641_627468_1583988E)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4ey0h42V0BavqnhUBLvr"
Date: Tue, 07 Apr 2009 10:16:45 +0200
Message-Id: <1239092205.22453.0.camel@johannes.local> (sfid-20090407_101656_791184_7BB5D4D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4ey0h42V0BavqnhUBLvr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-07 at 03:06 +0300, Maxim Levitsky wrote:
> I recently found that now ath5k supports AP mode.
> I also found that most of the work is now done in userspace.
>=20
> Since many drivers including my IWL3945 support sending beacons for IBSS
> (strictly speaking userspace can send them too, but this is  sub
> optimal), what else driver must support for AP?

http://wireless.kernel.org/en/developers/Documentation/mac80211/API

> If I patch it to support it (just add ap to list of allowed modes) will
> it work? (I soon anyway try out....)

no.

johannes

--=-4ey0h42V0BavqnhUBLvr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ2wvrAAoJEKVg1VMiehFYFDAP/0r0nU/k0maS13Q0ZbrRG6FK
JwtqUSKo67PXSOxHyfCKeLYMfYk/FfNqfEIbg/rNBkjK3J9Oj4iL6vztZzONhd/0
8zXjq6ocTzj0zbS/ZNTTgb1VLE34Zt3nxj5MDQyq3B/Qojqk99wp6JK8NFOcqERC
2AJNzl3HffU+T34YEZ0sTz2wzLwQGcsKcqvcD5smGbWReDdazU1i2KGotmxM2e+H
BnO2PVO8Mu+1NvEiIMEY0FQXEqecqEDBPlKfi4xBXPQaO4wYBTheCZjb7zoPaxA5
k7PDuNNnwLOmaeTC7Z81/jjXn1SKn9pNe/Dnyp8zcRsXcVeSYMnBDLRcyRjYD3HY
zbxfYzpbsCjbkNqONtLk3zn11Gv8SRrnAaEZCieR4FZKgcwKzbaWebergcMncMa3
ejvtUMY0Vj+hYDbdFj3hoNkFLuQskm28AhsS37mgUznaSiWVvI3xaFZmSZ+WymUD
p5/4g3jtm83aN6dU6iLAJl47uYL+0R4vtzTmfMygiV6HGTorTpm3SFWA3uhWDd5e
NeXjeo93W5Bpfg9A/69G8tkEaDrqk88SIEx2MZeT83kaXhIHT95SOp86bD8dDpp9
gnEy3ntSbrdb6TSIV2UWp+GhkEGYPBRoPNP+WIxcHZ86iufOuRBB4RSq63O23lQS
QpRe8vY4WBtCo83MXe/n
=P/6U
-----END PGP SIGNATURE-----

--=-4ey0h42V0BavqnhUBLvr--

