Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59541 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbZCXI2S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 04:28:18 -0400
Subject: Re: [PATCH 0/8] mac80211 aggregation improvements
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090323162834.154525349@sipsolutions.net> (sfid-20090323_173225_411533_528EB86B)
References: <20090323162834.154525349@sipsolutions.net>
	 (sfid-20090323_173225_411533_528EB86B)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-71myUTzeQj7SDzJYJHTH"
Date: Tue, 24 Mar 2009 09:28:13 +0100
Message-Id: <1237883293.6278.9.camel@johannes.local> (sfid-20090324_092822_038866_C439D2FE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-71myUTzeQj7SDzJYJHTH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-03-23 at 17:28 +0100, Johannes Berg wrote:
  =20
> Here's my patch set for improving aggregation

John, can I convince you to put this on track for .30 despite being
posted just hours before the merge window officially opened? The reason
I'm asking is that otherwise I'll have to support two code bases with
rather different ways to have aggregation working for iwlwifi again,
with different sets of bugs and different ways to fix it. This patch set
has also been tested fairly extensively already [1] inside Intel for
iwlwifi hardware and by Sujith for ath9k (and myself for both).

The decision isn't mine to make, obviously, and I'll put up with
whatever you decide is best, even if that means supporting both code
bases.

johannes

[1] unlike that patch to remove the superfluous code, sorry about that

--=-71myUTzeQj7SDzJYJHTH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJyJmbAAoJEKVg1VMiehFYqTMP/1fnjr07yY6+b61Cvobk9doc
g1x2f0X+gfJpur2NsVkAJb+kfycE2bNw1GWZH9ZlqzcHNIeaAzmnU93rz+F/MrDF
d6H6y0dzsdNfiDNF+KqAC3ob9hwAQDCv8vs3Vmjas7M3ceqWxm6vvQ6D2Ispb4bh
2qb8LIBL5mvU2ZD1X4ikUsS92bCn1do9gSwz0odTOsFbUpOjSlUrqS7kaxy3Y0eV
Zxx08hxNwWbUltOcne+VGzTZeXRpXz2EjV0T+ilUJTXVVN+WYFuDYhALjVkKKrh9
C6Ymk17wuVbyBdnQSz+kHzckjPXAS3rUEMT+Z2Xy06Jdr0FiS86aBgACljPeTk4+
3NRzUc6lBBkDsnZCm8JbEY0IOtd9m55DyGuV1ND4yoKTM5gaiyA4Spz2pXMDMmDZ
hp1AfqFccaX8Ws5QhIiej2rsOrbSRCO3w1q3YBSuuJOgvb8y9im0rbEXKmedvDKo
3+rSALHCU7lUKbOG30WnTaYyRGHVNQTdF54wSdlZTOWDCiaSrGWjkaL3+XSNr/6d
bYjJDrWNse2tAm92wGwfrJzOyqlZTZUAdh+4qIDSaXL1wUm3Foq12bEpEs2o6Fg+
Y5GaBynZqc9sNkXpkdtNzdhOIz3yPZSwFCZsNNG1Gzahq/E18pNV/Ylus9W5lYgG
e06d6JOdxwDaZRS/s6D/
=YihW
-----END PGP SIGNATURE-----

--=-71myUTzeQj7SDzJYJHTH--

