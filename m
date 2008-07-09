Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYGISIb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2008 14:08:31 -0400
Subject: Re: [PATCH 1/3] mac80211: Include sequence number in IBSS and Mesh
	beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <200807092012.11234.IvDoorn@gmail.com> (sfid-20080709_200323_001848_98D14EB3)
References: <200807091511.14288.IvDoorn@gmail.com>
	 <200807091812.55271.IvDoorn@gmail.com>
	 <1215625355.3246.41.camel@johannes.berg>
	 <200807092012.11234.IvDoorn@gmail.com>
	 (sfid-20080709_200323_001848_98D14EB3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bWP13N5ud9oKDaaiAEde"
Date: Wed, 09 Jul 2008 20:07:44 +0200
Message-Id: <1215626864.3246.43.camel@johannes.berg> (sfid-20080709_200834_802465_7E0224F3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bWP13N5ud9oKDaaiAEde
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 20:12 +0200, Ivo van Doorn wrote:

> > http://johannes.sipsolutions.net/patches/kernel/all/2008-07-09-17%3a38/=
022-mac80211-fix-hwseq.patch
>=20
> Personally I have my doubts about the meaningfullness of the flag
> 	IEEE80211_TX_CTL_QOS_FRAME
> since drivers will probably use ieee80211_is_data_qos() instead.
> Perhaps it is better to have the flag named something like:
> 	IEEE80211_TX_CTS_SW_SEQUENCE
> or
> 	IEEE80211_TX_CTS_HAS_SEQUENCE
>=20
> That way it is a bit clearer what the intention of the flag is.

Yeah, that's probably true, though I'd like people to be aware of the
TID sequence stuff... Guess we need to write more docs.

johannes

--=-bWP13N5ud9oKDaaiAEde
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdP5tAAoJEKVg1VMiehFY8PQP/0lwu1FnlS6oTsu9bY/PQJOQ
ckwhjT8ODrZpIBwd7itYnRo9LayzYksC5OxH9f5osrg24R5RxL0BBByV953qklgR
dZAuYs9FxxDYoM1WptfRKV5P9KEzsbpLBgc/uhZhiykBUsie1oObKg2+edE6AaSf
QfXkBbFpJ1jVNEfDtRGrwTs76oOBqUJ3ZYJ7fvUtWxYX9iynkEpJNejr/sjKtNVI
88CGrcJbSsKKHTuLsKq0aPThAY2dXm+ZmIwlJ1yskDCOkAA2yywAGMAkrR3RZX6m
33b98DODSMjWBGNOPgo/XPhYQ8gmj+BJ6u4Ul/BtXYXpfLnV4jwVM8free4cjqyj
/0UIFqPHLdc2pRDEhSiliXkV/FnT+MYPzfpjomucC6JBUvCSRJOuT6U8eNnSYax7
5+pz5EVLowJ+dCe8vVddxtn8penjL38XC7TlRXU4F2Eb/E3dnUl5jDfLKmVocJ/I
9lYvgRui/UDDdwZZBYioLGwOPovqXOxxBIoQdFeUkhjtBL+amnYn+/+RJOzapRBf
NzBdRGWJzJ5DHbJmtsFpOnC9fTiYLhcAZ9+q4D1JFjOOWj6RlD0GTvpKaI2kEWRO
AQvClM8gUY51KF45BmrRSeHQcECLWRcheloWvFhAe3cMwQr3C4l4fWXYqHVYkRWg
EaqhVEazMIcXDsnIYDX9
=lLCI
-----END PGP SIGNATURE-----

--=-bWP13N5ud9oKDaaiAEde--

