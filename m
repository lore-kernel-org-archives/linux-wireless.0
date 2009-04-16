Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52332 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbZDPBSP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 21:18:15 -0400
Subject: Re: Problem with IEEE80211_MONITORING_INTERVAL
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <Kalle.Valo@nokia.com>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1239844116.11795.47.camel@violet>
References: <1239837672.11795.46.camel@violet>
	 (sfid-20090416_012123_293746_81110E23)  <1239841291.25334.18.camel@johannes.local>
	 <1239844116.11795.47.camel@violet>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-J/B1sEh4gAHDcJZM5I31"
Date: Thu, 16 Apr 2009 03:16:58 +0200
Message-Id: <1239844618.6861.0.camel@johannes.local> (sfid-20090416_031819_457101_9FA0F1F7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-J/B1sEh4gAHDcJZM5I31
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-16 at 03:08 +0200, Marcel Holtmann wrote:

> > Hmm. Reason 2 is "Previous authentication no longer valid" which would
> > seem we get confused wrt. being authenticated or not (ie. we think we
> > are, but are not). Jouni might know? Can you try wpa_supplicant from gi=
t
> > with -Dnl80211?
>=20
> as I wrote, that is exactly what I am using. Trying to get away from
> this WEXT crap ;)

Oops, sorry. Could you try wext anyway? I think I have the same problem
with -Dnl80211 actually, but I continually rmmod anyway so didn't notice
it that much.

johannes

--=-J/B1sEh4gAHDcJZM5I31
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ5ocIAAoJEKVg1VMiehFYQAgQAIxq88e9cukwEz/SBf4gfGxg
YgYXFXliKt/XAVLhO+Vc4hQQL0pFKgT1S1U/ftZUdbc6L+hIFhKDuGd69QGe30mF
Wzs0PDm/ep94ddmzLhWxDIvOH1DoiQkYZpW3TB5tb/ZdTU0cGf/bE2m6fXODO2V8
2UCUqJK1Lm14q0scOgeYLG7xWiZ6dxXRptg21SZsKAD6qzl6xIlVszbgvcfOgJ0c
lwK/4jxmynR5ysO25MfSEiwy8d14o0gRMLUP6vmcJ7QYmfOUVQb1SCwLvSBxJQVf
a+5AwI+6JHhwC36xfluKZuAyng9+7t2+jRdNiupxWzjgO3ReIxr6KCzYz9L6yvFZ
L/lQ4QJRZdmrE6gICBg2m0/7toxFORfywk9guJx+8DY5JKE4PWYIn17rvmj7h5zw
cyAkiUSivrNiilpg8ovj1G7HEb7cyD+5kKIumufq4X33oPYC3lO5yQs7GcuTu9DI
dwslGXo4vp6dPw25tBkDApDidVugBE/UX5yNsuFT8nBQ3Rkw8T3pp/bAP9QCi2jc
SEnROMBP/1jAX+K85f5P2GZUPMd3zRWPVxT0obPiyErgce3qmG3KtfcFulb2C3HW
vrW/qSb4k+qeBepA8PCXQ5Qpupcyz2MvbmR/xcIJW4OQ8lQHfVYlX/NxoVAEcynR
HMrlKBY1EbJwrJ5JFuTd
=bFZ9
-----END PGP SIGNATURE-----

--=-J/B1sEh4gAHDcJZM5I31--

