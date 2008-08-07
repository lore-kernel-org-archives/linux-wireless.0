Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122AbYHGGg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 02:36:29 -0400
Subject: Re: [PATCH] p54: Fix regression due to commit b19fa1f
From: Johannes Berg <johannes@sipsolutions.net>
To: Chr <chunkeey@web.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, davem@davemloft.net,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200808070057.01952.chunkeey@web.de>
References: <4897714b.z7H23Rca9Z4lOo4Q%Larry.Finger@lwfinger.net>
	 <200808070057.01952.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XWKi3SWPkZSvs0SPb8kd"
Date: Thu, 07 Aug 2008 08:35:50 +0200
Message-Id: <1218090950.23048.88.camel@johannes.berg> (sfid-20080807_083632_845829_AC63C54E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XWKi3SWPkZSvs0SPb8kd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 00:57 +0200, Chr wrote:

> The real problem seems to be that skb_get_queue_mapping doesn't
> work the way it should when we process the firmwares callback. It's
> always "0" and unfortunately also when it should be something else like
> queue 1, 2 or 3..... problem solved?=20

Oh, eh, sorry about that, of course it cannot return the right thing on
a _received_ frame. Thanks for finding.

johannes

--=-XWKi3SWPkZSvs0SPb8kd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImpfCAAoJEKVg1VMiehFYhXgP/iHlNtEfcKPaXh28/xROFqjt
XvCdy0uHGqItlt/WkVldQ3tpfVuYh1s3I48MGjtPccMis3vTEFqQ909fBosY6+bL
MGMzmkrnRvnEJ2R0i18M3lf0G2FKdjsrWyE88ytoOfLESgfVTmOtPqbEyYx18k3U
++IvuJGVgFcK94aFxV4N1ph6rjDHw0p5yDVFQZP1UeJo95N2QcuSedTZ+tIVyx//
GHjWFysjtDX6jXKXYF53dYNeMnlCN3NP1dJAa9EIUQtwgyYGs1YrS7bsYo9seaKc
hZijr5KyW4XHM+v952+kQ8xFliG2V8J0HBc44wBvUvASTdJah+GnJkMA2Xm/Cj4m
Izj+fxVsCyiEnnaWoe3yCW/I2R1JbqAHiNIpaS8JZ9GVjvCB/HTM79nUJHyJNLEc
r9wY5owWDU8DUTI8eH1bbEJW3bUgp2t5iHVeKdL6eSALjH2p+M6ZZK8VbofXMKFv
d69DNFnL+TKDK/gb+HvcM2pEI/cUvP+dFjW9uri9wF91t9MUxyCsKFa79qsSWB7v
4PtovL+x3oxvCrKhHho+rwdj9U4kpZv3wUF4xtXkCi7t+4PnCeZAqxoHqah81PUp
pyZaknN/vOzzxYcoC2mbqG/IEoXqWm/a2vSBcrISha+DK1X015A+gvntZJ4YejmG
ZKxinUwYXFmsCCvHc927
=jMlt
-----END PGP SIGNATURE-----

--=-XWKi3SWPkZSvs0SPb8kd--

