Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60581 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603AbYKAOx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 10:53:26 -0400
Subject: Re: Michael MIC failures in AP mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <87wsfnldq9.fsf@nokia.com> (sfid-20081101_153138_893209_47C4FC8F)
References: <87wsfnldq9.fsf@nokia.com>
	 (sfid-20081101_153138_893209_47C4FC8F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-deM09LJd5S7IIiv8s7Mk"
Date: Sat, 01 Nov 2008 15:53:25 +0100
Message-Id: <1225551205.3619.7.camel@johannes.berg> (sfid-20081101_155330_130972_5945C3FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-deM09LJd5S7IIiv8s7Mk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-01 at 16:31 +0200, Kalle Valo wrote:

> Now that AP mode works in mac80211 I want to use it to test Michael
> MIC failures in a wlan driver. Any recommendations, or tips, how to
> easily create them with mac80211 and hostapd?

Inject frames maybe? Easiest is probably to disable hw crypto, then
you'll see the fully encrypted frames on a new monitor interface and can
inject them again.

johannes

--=-deM09LJd5S7IIiv8s7Mk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDG1hAAoJEKVg1VMiehFY2NMP/Awc7oZUJpcLsks6KOB4t4x8
izywGp3CU4X72WmoMaXpE3x9LPLWQObVwMbuFXK1RALutsSXfNBkFwxSk+EIcS+j
xyVRrjLzAyFcc9q1zqDOSP3nRDigVAEfAiq2vVYtzsZ2iJiW0N9UVYuSLSdvPhIz
6IBO6g+3y8swl1BYui8f8229ClRZi3dtxoqrOyt8iqc/AgqOUV2X0o3dCXJPOnt1
RfFgsmb4IyeqxTGka2v3sLmCY8hBKUYJZ8Wt3bamREcY0LBn546ILK8qGIsrOGQI
fUTHlZKkOrZ1bSYLbU373415xqF2+qVaOdt7E8fYVAjeQ/v4wtqBFAnycbxjIR3Z
KXuMRM5yv6xbFewab9Bf+BZ0ipaZlAlwvJ5SAX5g3lvAUdRJ7JN9Teb4/OT5PFQP
ieOJb/AOson9IeCfpZQm+H4SBVb+wePbPEXDdUkHpTyaPF9joRqk5tTMZwzyNzcD
95Kcp9cgT1gr4Uo57tBDaCBCQ1JutUSKpo/jS5g1CED6wbSdo4Qa/5Wfu+qGawQX
sWxSFUs3LJV2WVlAlc84GPD/X36TPo9ZhNjd/gPxTPsMRdaRwV9FXlsaVnh1V/LW
IJ+Osk2G0TSAG+hRZmLoiGEFpE0gwxTC8WmB73V9+iiYcWOFOSjLrBw7VqptVWx9
g/I88O3UR0iRHuTxbmLO
=pBQ0
-----END PGP SIGNATURE-----

--=-deM09LJd5S7IIiv8s7Mk--

