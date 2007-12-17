Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59482 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbXLQRnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2007 12:43:01 -0500
Subject: Re: [patch 2/9] iwlwifi: Resync rate control code with mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071217012550.045470580@gmx.de>> (sfid-20071217_012730_052104_5B10C305)
References: <20071217012517.882216322@gmx.de> >
	  <20071217012550.045470580@gmx.de>> (sfid-20071217_012730_052104_5B10C305)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mpT2XLahZzcMilJtvv0z"
Date: Mon, 17 Dec 2007 12:48:00 +0100
Message-Id: <1197892081.4885.18.camel@johannes.berg> (sfid-20071217_174307_184386_6CA0F3AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mpT2XLahZzcMilJtvv0z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-12-17 at 02:25 +0100, Mattias Nissler wrote:
> This brings iwlwifi rate control code back in sync with mac80211.

This, and a patch to fix the "simple" algorithm should be part of the
first patch to avoid breaking bisection.

johannes

--=-mpT2XLahZzcMilJtvv0z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2Zh76Vg1VMiehFYAQLYLA//cTU4bOelDNQ2PlFCUzFbtGdqDTu1eU1V
JrAAURDRQ/ifsOdO2j10dwumPHzb5KiJNZseWm1zLnuz6t81GwxUD3kUIZBBgVCO
ncJ0lZzeDbs63XXLmSCQEOlpETDNAloVUdVF1X8luAPajog9Zug+6KZltWI18Dv0
NUytJOCqhF0dpGA+wUJI/SwUizjt5eO5t09ccWFHcxsoFVICV9hTvuZcxyQ86hj4
gHcDiergkpjtgZhL/uQloPL0ASyk/Dt61f5heRL41pBHhmDAoYNUsghbSkweg2Co
8mqKm/XnYnL2EC2oJ60YJLxIio7EcDC1VFCa1krtNRvN+ZbCPSE8wzugvBwb5Jv+
XKYmfRvjvLw+tXiak/cyOgDvi8IJr3Olap4BuymevkFUYefWHC4dMxtvepZMrZXC
vS0UWtFzdeP8VoC3LmTSSxZ7RlsqRWEuK5NX/M0ujHl5F41venBgWf0y67y9kBFc
rapMgwQQnjWEE0l5aDdn/W09nBEJJ4jHZ7nFZFrBLVqAL4UF0YOghoN6wPuZLsEk
tyONGRD6+XSieftL/cgg28/of2JMHS2HMgCZOVRNNb6cgqIQNnTtBnotw/bduAtF
E1ngVpKU386qMw1RUrpCGXH8PFHl4a15qgFya+0ZMPAgg9cHDPAL2+5XkBRdWmCw
HBP1Dek4KCw=
=6f5p
-----END PGP SIGNATURE-----

--=-mpT2XLahZzcMilJtvv0z--

