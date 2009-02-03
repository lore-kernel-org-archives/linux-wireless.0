Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbZBCJx0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 04:53:26 -0500
Subject: Re: Crashing on ping?
From: Johannes Berg <johannes@sipsolutions.net>
To: Mike Cui <cuicui@gmail.com>
Cc: Bob Copeland <bcopeland@gmail.com>, Keir <keirlawson@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <7c8826910902021513o5719927ej12c860d55b49101c@mail.gmail.com> (sfid-20090203_001409_488889_1CE4DB14)
References: <e27b78a40901230803t8eafb3cx6d70ceaec68daf09@mail.gmail.com>
	 <e27b78a40901260625w53acd646xeb5a9ca85555c74d@mail.gmail.com>
	 <e27b78a40901260956w4e69d33s7db60defc026c8d7@mail.gmail.com>
	 <45e8e6c40901280954l42bbe788y8723141d673bb7b3@mail.gmail.com>
	 <e27b78a40901300446y294504d5kd7acaa6c5a26edd@mail.gmail.com>
	 <e27b78a40901300601p35d68125kfc3a10a7d7db0900@mail.gmail.com>
	 <7c8826910901301109s6d80a75ale251ec837eabccf0@mail.gmail.com>
	 <e27b78a40902021013v272ec315nece744d3cf1dc75c@mail.gmail.com>
	 <7c8826910902021255g2563400an24f97014abf854f8@mail.gmail.com>
	 <b6c5339f0902021333x2880b7dfj279822622a3d5cc3@mail.gmail.com>
	 <7c8826910902021513o5719927ej12c860d55b49101c@mail.gmail.com>
	 (sfid-20090203_001409_488889_1CE4DB14)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-uoVyWKgzU+SBHyFIrV62"
Date: Tue, 03 Feb 2009 10:53:14 +0100
Message-Id: <1233654794.3964.15.camel@johannes.local> (sfid-20090203_105331_585419_F4D188AB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uoVyWKgzU+SBHyFIrV62
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-02-02 at 15:13 -0800, Mike Cui wrote:
> No I don't have stack trace. The system completely freezes, to a point
> where even the magic sysreq key doesn't respond.=20

Just switch to a vt _before_ making it crash.

johannes

--=-uoVyWKgzU+SBHyFIrV62
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJiBQIAAoJEKVg1VMiehFY0HAP+wS1AZH2ouQuIc8jlvtPFNgU
HZMjSHSsJkvv29bQHWEEOadLc86cBtBnFZKuIEFUMpNFaAijIlZV2VHZ/p1CmxtV
/s8448D4t4pYEYPFeqxdJAt6y5YEWDrCokiWExx+s9G+A3WKZfaIa3LqlTaLgrRb
p1l0h6bW6zmCjmR7T+knO6qeDfC7m4XBiwLR1sAvw4jHLgZgtv0sYf67hY/2LpUT
297eKgmY1/f2Z13z2Tpt8libO5D4QSCeaReC2/ySZu77/W5iJWYHuTkbZabZiI9r
pX/W4XqIS3aCiakAv67rh3h+s3g5YdlmisRph61DluvczX+/2s230Z4Vct+WmLI1
EawSoyJGxYLzc9R3Zpc2PNAfC6s2hUEd59+PuBlAf7CUQZkwaH+xFpF8Cw0DKrVH
Rs/0u42Nj7+3V3DTWLCC13fDv++ulUXbpmoW0Xta7gd2X5ooDG5nLDpTJmtrP8h4
EUXEBlEvkRHQE5/tNaAMXxD2zk8O64QK4HKKyvDiW8KSY4qCLsFv8HB9kCpcAdSv
a1F0mISMrbsP+SldZVRjiZoIbWg9ap7WTh46GFY70UQXwgPhbkhaHbeAd0afk0Hf
Gx7ZZxmI6gp4gKcGwo+yrf3RhZoMHtOeE4MySWEuc3GKxuQPQ0TfTaY3uE4s+pNn
SETDXyS0Waq/eUFG9Bdh
=W8GN
-----END PGP SIGNATURE-----

--=-uoVyWKgzU+SBHyFIrV62--

