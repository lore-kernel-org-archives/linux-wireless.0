Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52231 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757493AbZCQV1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 17:27:34 -0400
Subject: Re: Possible circular locking problem
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, Jouni Malinen <j@w1.fi>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20090317170530.GE6737@tuxdriver.com>
References: <49BFCCC5.9080500@lwfinger.net>
	 <20090317170530.GE6737@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-yaDBkv9ZGcGdxEYko2TZ"
Date: Tue, 17 Mar 2009 22:25:14 +0100
Message-Id: <1237325114.10264.1.camel@johannes.local> (sfid-20090317_222758_787537_0663211E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-yaDBkv9ZGcGdxEYko2TZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-03-17 at 13:05 -0400, John W. Linville wrote:
> On Tue, Mar 17, 2009 at 11:16:05AM -0500, Larry Finger wrote:
> > While testing usage of b43legacy as an AP, I got the following in my lo=
gs. My
> > kernel is the latest wireless-testing that was pulled about 2 hours ago=
 -
> > hostapd is 0.6.8.
>=20
> I think Johannes may have already posted a patch that addresses the
> cfg80211 vs. rtnl locking (or I could be wrong).  I'll try to get
> another round of patches merged sometime today.

Yes, the patch should be up-to-date too.

johannes

--=-yaDBkv9ZGcGdxEYko2TZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJwBU4AAoJEKVg1VMiehFYVAwP/1gBLP8ddoiFKtZBB+nGJ8Dh
cBmlOETLrVVDRvDkRapUwYqkHzdXzg8uWJRQU6Soh7F8U66BCIQnAhwaWGOI3Jru
bbt2s2/Q4UOp8Ibebuc2gewIN9x+tnuH/sL6kafbtkA7+HxIh2yj6uCk9WgtZVrT
UVgwqUSCuGzquXCVF9nZ9wAb3B4s36FeeXKH2pqDMEoc42mA4r6DK6DwsJcqKQJc
pk9z6+yaJwAY0fZi0bDn0ZmYW4XbfX0sA4i8exgLcFi7R1bKLBlA48t5MZr7QSQt
UggIUYqvH4a3IMHBqSfoGyTh6/8KuYQsXLQJHu+9TF7VMXq5yAtV0ihBPFAlX8A8
Gv6Dp1QqaPNub9y+XhZnkb3LCc1+iyGGyBbrpELto1Jbqnh4gbu9CZ2AizAFSlAD
UANoFgQCEYIx+PEgsK/2Ke4NDlSVOr1gX4Pv6ukZB5mIHsJfmgtWnAVpXLo6vhU8
27zSzNZhg5xYs4lZaYn7mdiC2uCCZrcIF7mi1Ygp3JzBitP2EchdksF0X0+Emd8w
PJsUGKN/9yWH+5q6Wlph/Bm9g9xbOawKib+9Y1SnhnsKb6cjBtIqeWdGbhIaL3Ik
kQINbP9f9Ezb6UD5/U54un8qcMw4/XMUdjG2eC1r77eMo4kZk5B2Sih4w1v4PcKU
oeqjbkyF1AkSfisYMAYJ
=UZiq
-----END PGP SIGNATURE-----

--=-yaDBkv9ZGcGdxEYko2TZ--

