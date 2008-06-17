Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbYFQQpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jun 2008 12:45:15 -0400
Subject: Re: [RFC PATCH 0/7] IEEE 802.11w / management frame protection
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20080617154008.883383150@localhost>
References: <20080617154008.883383150@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9Esx+7bN3dr2iNRy2qmU"
Date: Tue, 17 Jun 2008 18:44:27 +0200
Message-Id: <1213721067.3803.73.camel@johannes.berg> (sfid-20080617_184519_778489_1E55763E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9Esx+7bN3dr2iNRy2qmU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The current version is relatively complete for mac80211, but there are
> still couple of known missing functions and I've done only very
> limited testing so far. I was able to send and receive both CCMP and
> BIP protected deauthentication frames and based on a sniffer log, the
> frames looked correct. All this is with mac80211_hwsim and software
> crypto. It is unclear whether this can be used as-is with devices that
> use hwaccel for crypto at least before the low-level drivers and/or
> firmware have been modified to cope with the possibility of CCMP being
> used with management frames.

b43 will be able to do this for sure, it doesn't care what sort of frame
is encrypted. The question is how drivers can indicate
support/non-support I guess.

johannes

--=-9Esx+7bN3dr2iNRy2qmU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIV+nnAAoJEKVg1VMiehFYLjsQAIUcRbw+7aEqcS1JDem1dh6v
GWQo1oxUWNYBbGtsZm1iPGPl9vqhgGjGjDBf5tdq4IwgpSdtxPZOyIVCjjBakP8Z
0YVpc4QwwKCjyxMnaU5GhZmYa+Wg8ceeYHvUVzSKz7Pt/aMO9tLudn0lapvM518v
AMWxcvQLD15K4350z3916ZE+N1jihXdMMg9dHV6mS7zNE4qkc4Pams1idUG1ioKW
SB9Tl3OD3Jms4mZR/0tgjL90fmNrFoDfadl1IXW0PfI1IrfTXQVdCAyjRix82Jo8
iK2HqGMd3vAsvBCiENKFmZI9bxhHYRzHq1Sh1uAKX7zpudGN3/wKN7vXKJCfsa0b
ytsyWhQpbmjyenjLCzZ15LS1KN8SiEa+Bc6/e18mSywB4leBY831as1P5CgJQJWp
6l8fsY3UG3kAW10RVX9+rt/OwwzL3nLFLRSJUithE4pKmDSClqvGeGqt85NqhFiY
qXxzMgvDmjwua0T27urKdl2rw8atuG/Jinfz/UD9tJoUI2bFiKq0BZH1a/h0kyf0
LrAai+xpY1pZqnsW9z29y0GJT+olz5RRg9C8+8i6vEW6GytXWVQHpdPsz3N0aHub
iUS0fg2HfHcH1+mzLloa4jEWFj+Hclc4PssvQMkNCDh5LP/mBHC4D9MU/PlSX2OC
NTZYSa9JR1LFGqmhw/Oc
=Eb0m
-----END PGP SIGNATURE-----

--=-9Esx+7bN3dr2iNRy2qmU--

