Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53686 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbZCLWI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 18:08:26 -0400
Subject: ath9k fragmentation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4f1jRpRsLBeD3pOV49B/"
Date: Thu, 12 Mar 2009 19:10:34 +0100
Message-Id: <1236881434.25931.1.camel@johannes.local> (sfid-20090312_230828_196984_740A5A97)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-4f1jRpRsLBeD3pOV49B/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Just a quick note -- was testing fragmentation and happened to use ath9k
as the test station, this failed utterly, it sent increasing sequence
numbers and no fragment number.

johannes

--=-4f1jRpRsLBeD3pOV49B/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJuVAXAAoJEKVg1VMiehFY0C0QAJXt++YKZ3kzmansVUEN27fk
TnTO3gxFNxLyU8kUl6vS5+31B6KBObiZcH6BSZIFD4dbxfutsdJShoaHqp8HYluu
QiTPT0u2OFar61lXFOQfc1NQcEQM/UqghIK6B89U884FxiwVAPu1kWB6R0l2+Q8h
5upDyz5Okv5O/v9yXyGfcZr/crCXF2IZS2lgk6j/oajZYfUNgKysRTO8zCjohrmh
Fdz1rdg1Iwe5BOvbka3EmBTbrfltwXRo92ReJpXuAkCgYMC2l0qyTwg1gh09OFP6
lIw40Us1aiOGT/Od1za+20ZS3yyE56LYc4It6xZvBSRdTjPuiY05fICTrHZIZb5q
Fk7gDQPGvOVe319MQmebAR7lppX+b+V1wUXz8RNlh8SE7wycW4bwLz/TeAT9V9Q6
e/d0cMKefV03ShGEP/gnqvHpBdN5nWhwcPWlwPPDaIMoRu7L+wDx9JmBcIXLKF/+
PSyXgN+e8pGueYEPJ73DZDIRy5k4xH01t4j/19LzksUiS+pG38+eDFGIvjoEKC3E
s4ZXGzo9PWorWhWcJYbjdXsOqhPxqUXGEMz12Pcuk9b/tOLIf/YLCRm5WkzoWepo
/U/veNNc3xWnbhFQIkxwaMhFYp4eVcGfw8FhGbBrVJp+3JLxquXtYQnc1h0nQwgn
ANSsHbpVKjqiP5eRDIcy
=rM5v
-----END PGP SIGNATURE-----

--=-4f1jRpRsLBeD3pOV49B/--

