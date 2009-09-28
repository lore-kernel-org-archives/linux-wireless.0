Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58090 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZI1Sz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 14:55:28 -0400
Subject: Re: Problems with "cfg80211: fix SME connect" commit
From: Johannes Berg <johannes@sipsolutions.net>
To: Albert Herranz <albert_herranz@yahoo.es>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <29413.68229.qm@web28307.mail.ukl.yahoo.com>
References: <505407.87957.qm@web28315.mail.ukl.yahoo.com>
	 <200909210845.51247.hs4233@mail.mn-solutions.de>
	 <4AB7A5BB.1050300@yahoo.es> <1253779538.3868.14.camel@johannes.local>
	 <29413.68229.qm@web28307.mail.ukl.yahoo.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-2X9DihrOgQtV+fRPchyi"
Date: Mon, 28 Sep 2009 20:55:23 +0200
Message-Id: <1254164123.3151.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-2X9DihrOgQtV+fRPchyi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-28 at 11:04 -0700, Albert Herranz wrote:

> [   15.624121] wlan1: starting authentication with 00:12:17:15:e7:79
> [   15.630717] wlan1: deauthenticating from 00:12:17:15:e7:79 by local ch=
oice (reason=3D3)
> [   15.645151] wlan1: starting authentication with 00:12:17:15:e7:79

> I'm using wpa_supplicant _without_ NM.

Yeah, I since figured out why that's happening, and it's not so strange
after all. Shouldn't be a big deal. At least I see you're getting
connected too now.

johannes

--=-2X9DihrOgQtV+fRPchyi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKwQaYAAoJEODzc/N7+QmaPzEQAM36jB+X+V9urnEnf6ewMWRG
Q3YPi35jXJGujL1oWKNh4m+bF2dOGRYSKkgyrakgDphrw7m1ke2pw5Bd5TagGSSq
Wax52G4XfUyNy89FSgn3b6FaPtfOLerPLmwVJA0LMaF7CNolQ68Ca7WXMopqO8H6
tDnEuU2coTyeYZy2gRHaK+JzT2qUsvusNE6vrBaROt52zxciepfAXAQ+KPozw+7L
O9p3A3H1VMzgGyHgZdtipAB2M7xAqvFZ5lE5f8+RbFT+2tgdATh7hj8/rMu3alsy
5Wsz/2Q+WVxh28shwtl8l2LMX0WlcIjodRbCUb539meO/UTnjCEulxJMubmO/dyE
orU+HHxUW1QXHmJ9mURnCJGWKc8MOGSpGnp9SgPhOlxS1wUdiyp+G03kLPO8CqlM
5p1CpLsVxzpvBurRTorZ87XB5Kt+sMEo7yfk722BD0hl81W/cCvWs1UQ72g912qp
t/r3hvl0KzbCfJKPWfV5WXp+Qa12yT/43uQuLM76Dk+F0un4IH25pXXAETtV2n/h
HA4si/xfl3pE1VvYmdQZs1F1Nt6JxOkr4h2k8dNX+NSAe47MMfjN8mb4cwqf9scG
/jJ03Wmfjr3D4ZsOCS0+mH/LDBnkOcLNmZE3trBgUqojRs0Ln08siJ7b4E4kZySn
7M0SD6aRsr/vZcrGop5v
=F6mw
-----END PGP SIGNATURE-----

--=-2X9DihrOgQtV+fRPchyi--

