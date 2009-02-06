Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbZBFUrX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2009 15:47:23 -0500
Subject: Re: AP mode support requirements for iwlagn driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Milan Plzik <milan.plzik@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1233933392.6476.2372.camel@localhost> (sfid-20090206_164648_314946_F5B48388)
References: <1233933392.6476.2372.camel@localhost>
	 (sfid-20090206_164648_314946_F5B48388)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1STrVOSNKvtsJwj0DpPG"
Date: Fri, 06 Feb 2009 21:47:20 +0100
Message-Id: <1233953240.4175.29.camel@johannes.local> (sfid-20090206_214726_898832_E57BDA3D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1STrVOSNKvtsJwj0DpPG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-06 at 16:16 +0100, Milan Plzik wrote:
> Hello,
>=20
>   what are the exact requirements for AP mode support in iwlagn driver?
> Is there any change neccessary in card's firmware, or the only missing
> code is in mac80211/iwlagn itself? Also, there was sort-of support for
> AP, but it was disabled in later versions -- what were the exact
> problems with this implementation?

One major issue was getting multicast frames out at the right time, but
also look at
http://wireless.kernel.org/en/developers/Documentation/mac80211/API

johannes

--=-1STrVOSNKvtsJwj0DpPG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJjKHQAAoJEKVg1VMiehFYHmIQALoc2PSTYcZq02I8qdEkoEiQ
2FOTiMY/Bkiejc2ck78lLgZ6A85e19dYRVUDWHZy4MFlHLAJtg5/Fuyrt8vuMvcA
oY5ajpYXTQF2BKE10NdZCbNWyMCFA1wyXRnNFO8O3k+frhZS7PenUgevfiaysRoL
IZJneYruMrgbAyvDVKpGBs0BLVJFlEMgIuWka5IN9IiqweijRSAc1njA2Kajlu2K
Va5Q3L83MFqUXK4g662eYZSEpTW+Bg5xDvvBfDhR6s1Bjn+JUwAjdwIOxqDKuqOJ
QoJedFWWPjng0Z+BAo8xqg2pKZDx//i2td0lSREmWPx78uFHZYN7voLg9+K7wtqV
g0SLfXAqxu5ADOt5TFqYiMGCEzofxrUmZVBploQsElmTTY9ASzb2KI6a6kkY/re2
GG9ftIovdoWX7EGkHjenFyczDicR/qBK3FED3ao0+DSdP7Tqyk7GH21cx04FfkLL
NMXLnFVtmXLt+Wp6Nm5u7Nrj3sFZUaFjMTDGzsdKZj+C7wUUDzhJfgpkf8KavwRZ
CKivz06Y91nk5IUOqAKkLGutBLjmljvMaqqutEq9yDKep/9/mP1uqIFLnmDUlKX3
a0Px2RxTR13FXUS4Nsa7/Jt/fh+wzbBJg71NXjeKhobMPSDbptdYNKAVVVsU2uME
Cd0f3xPhNOKjl47GlhlP
=W5gM
-----END PGP SIGNATURE-----

--=-1STrVOSNKvtsJwj0DpPG--

