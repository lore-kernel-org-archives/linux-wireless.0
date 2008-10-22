Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42115 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbYJVTnt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 15:43:49 -0400
Subject: Re: [PATCH v2] wireless: remove struct regdom hinting
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20081022124139.GK6190@tesla>
References: <1224585042.5521.7.camel@johannes.berg>
	 <20081022113950.GE6190@tesla> <1224701496.30459.50.camel@johannes.berg>
	 <20081022122914.GH6190@tesla> <1224703869.30459.63.camel@johannes.berg>
	 <20081022124139.GK6190@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-XQTC2FM6myBOVAF0KVbR"
Date: Wed, 22 Oct 2008 21:43:42 +0200
Message-Id: <1224704622.30459.71.camel@johannes.berg> (sfid-20081022_214351_928022_21E19172)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-XQTC2FM6myBOVAF0KVbR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 05:41 -0700, Luis R. Rodriguez wrote:

> Well, the alpha2 hint from country IE we'd built it from the IE
> and then try call an rd hint routine, I take it now it would be the new
> struct one.=20

No, we'll have to add a new one for that

> But yea its useful to keep track of I think. I thought you didn't remove
> it from ignore_request(), hm.. that's where we use it to do all these
> checks.

Actually there was only one pointless warning where a driver does two
hints for the same wiphy (that's just a code bug), and it's otherwise
unused.

johannes

--=-XQTC2FM6myBOVAF0KVbR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/4JrAAoJEKVg1VMiehFYK8wP/1Rz6t61pC/4rbJU+JQYoJsp
lpyFf8YN4aWrsZvDIhFpJRtbJYSI6PbfxASgimzoVjPd8Ly8V6NyiwuJiFBiSgGG
D1sJIhuaWoHtFMm53Z8Su7gwZvde8LtCx7Rn6hOrSo3YC712V/7RSQCxCI0Lm/5u
4nbz8Po3f4U1dXhSQh9xJl55F7c7uxIxZ60W1Aca/wriWHfDltSqULylF9dB+ZMT
qV8HP3XI8IH/cCP8LRsTnpr7q5oGmYkjHjMRMcfm5ha+drMKxCul2LdLw61IPdow
/KgZ4YNgIHUA8n6AeYBR5lHoIwIVWbsv41WfJVWvjp36wFzhJWPsFIkqkqbakCAF
c6csSWptle4hjwW2/LXa7ckPOLzNXiZ8VZxHM7BxHUXcqcaGKTK+Lnh3+ZDab2Gg
wGRBCQHuCJoS4L24H8VRauH1e81TAkjur42sD/hmM4J+duKGMMP1iYmz2gjIo2v7
VQkNY+GMcRr7/uSb6UnCs6B03XLDuPpNCtrsEjc7obS/losKFrv2dhzhY384WI51
Q4ndb8ViKJ26WlVnvIUXattw5WLP6WxW4c9RKSp3tb+2OXL3DMg1BWFE3LNoRyqS
tFMMBOHLDSO79vNbtamySskrVE45WovcbQHIMfxYNjKFmnp2hVN0fLyXZdXStH3g
79s9oK+BlzFjmC63BIjL
=zix0
-----END PGP SIGNATURE-----

--=-XQTC2FM6myBOVAF0KVbR--

