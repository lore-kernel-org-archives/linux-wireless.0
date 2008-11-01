Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42753 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYKAPvl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 11:51:41 -0400
Subject: Re: Michael MIC failures in AP mode?
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: Kalle Valo <kalle.valo@nokia.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20081101151938.GA4857@jm.kir.nu> (sfid-20081101_162043_951195_6B30AF69)
References: <87wsfnldq9.fsf@nokia.com>  <20081101151938.GA4857@jm.kir.nu>
	 (sfid-20081101_162043_951195_6B30AF69)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DWaFvn3cRpde3YxS2UC8"
Date: Sat, 01 Nov 2008 16:51:37 +0100
Message-Id: <1225554697.3619.13.camel@johannes.berg> (sfid-20081101_165151_774110_5E8F7CB6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DWaFvn3cRpde3YxS2UC8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-01 at 17:19 +0200, Jouni Malinen wrote:

> Anyway, if you just want to test Michael MIC error processing on a
> client, force mac80211 to do software encryption

On that matter, should we put a debugfs control knob in place to
completely disable HW encryption in mac80211, so we don't need this
override in all drivers?

johannes

--=-DWaFvn3cRpde3YxS2UC8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJDHsGAAoJEKVg1VMiehFYdSsP+wWQiNPsLBVE6oKCBv2j8J4x
swMktyvAFpojR0ZBmX1FRQXKlUIhM1R7xK9XqTTiXGE9M4e8MfQr1KMz1ii5sB6U
kBtImpKZIErxQTPUmC3oMOYSklUDReHz+PZO+CP6QeMrywzg0Tp/MJBaX2k02+gW
7+7GWrFKUu5/JQCExcUOsUve1IcWR/DmQCZ6Q16mrZimlWBwDhw5SmSVS7WKnNW4
3jWlZwR47oeCnAV3CIFuS/sy/5s3dP4BjpUcRG5HGpO3UyQhufSertaY7pttimEn
VZROh1fzbLYUxgEvSDWopQnNDHqkx9ERxsHZH1Q5kzY1YQnm30cFbeZ1m6013CUd
f0ZWVjQfDlzj/WMDUr0cTx+TESPjPANWwhDK66rqJq7//PQ99fhftZiHUH5A0I6M
y6//BxstI6aR404QBVUp3vsBqKMe/GJ1jiaJSNsBWhuARHyh9KK3pEKQpiLy32YS
IPgYM5oSR5vIK6iDeXnQUaDlQmnr2BWvays0BEeN1t9rwBS5Q4SXXWdG/hqs3aHL
ctQM85zQFIytFcW5u0sWEp3LB1DWK1f70yjIaA5K5q46Q85i8RfTzuOt+RbLFSZn
Fjly07ZQjpIfGdunL5gmEIpsGXiJe0jxTBA9H+OmF5/at+BZMSBbS8hztWnVuDPO
TbF1x+Tf5hDjtqlG5t0X
=rben
-----END PGP SIGNATURE-----

--=-DWaFvn3cRpde3YxS2UC8--

