Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51229 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755342AbYBAULz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 15:11:55 -0500
Subject: Re: wireless mini-summit agenda proposals?
From: Johannes Berg <johannes@sipsolutions.net>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <40f31dec0802011107n3389bbc5l2f43be0f6111d222@mail.gmail.com> (sfid-20080201_190744_758093_9B00D531)
References: <20080131162514.GC6413@tuxdriver.com>
	 <1201882577.4188.68.camel@johannes.berg>
	 <40f31dec0802011107n3389bbc5l2f43be0f6111d222@mail.gmail.com>
	 (sfid-20080201_190744_758093_9B00D531)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rgc/U5d1RyccnA6OHvWr"
Date: Fri, 01 Feb 2008 21:11:14 +0100
Message-Id: <1201896674.4188.74.camel@johannes.berg> (sfid-20080201_201159_684445_DF8ECC65)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-rgc/U5d1RyccnA6OHvWr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Plzzz someone explain how WMM is implemented in mac80211 and suggest
> some tests so we can be sure we implement it correctly, we really want
> to add multiqueue support in ath5k ;-)

Well nobody knows ;)

> Also it would be great if someone explained what's new in
> 802.11n/802.11s and what drivers are expected to do (i think on the
> previous summit there was a talk about encrypted management frames, do
> we have a plan for that ?).

There's no 11s support yet, the cozybit guys never came forward with a
second patchset after we commented on their first. 11w (encrypted
management frames) is pretty straight forward, we add the new
"encryption" algorithm and wpa_supplicant does the rest (in fact, it
already has code)

johannes

--=-rgc/U5d1RyccnA6OHvWr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6N84KVg1VMiehFYAQKHTBAAgoxFj4w8+VbKbC2DrIrCpMLnibQNs6OO
EM6t7Eog7lFAoilbDXiPR5rjAHZrHPhcLJ71fjqYDHBleWM6bRJAsS6AtxxTY3MV
JRVIIBtdlFJ5Fcb+wrLe7PimJdXiehRsvPW5gO9z/+5GxHzMrTjw0jCntQxyAiB9
j/RswwQGB5MkY/1fL4+2xh9RNaMyd8sE7z7VMt4Be7Pqbp5PtwEfgUXK8lElTP+z
H6avOlIV1eZhcUJuhLSdB9W3izKptuSc7OxTFyrG/kj8qOxoopIGkX3cWQ8mdn3S
qVnPe4D6EILggJLWCrByEO2boq8kVBmCdvNDSlOUx8s7U736aMc9hIGDfh88sJ99
s5V8CA1mR8/HgocaMC0V8zaTLNu9kr3Jt6SSayVxsfPu7F46tXX+3T+UW5EIglFf
N0kr9mKkBqn8oA43o2vA8nAF7W7hAFkRrEZ6qe5u5fvxPBuV5A8AJk1oK+wk24Nb
Fg8J4O+tXBjYc2eGs9jbmGDm1Bft1wQwwjMFeKryQtuQW/mlMlJyUekRzLL0GFBT
r6pmNiS2b7IQO+hzT2L9MRHAHOJQhy7CloxDrqEqlNTJPoRmKv91RHaZFGzwVZjy
RYoJRfviZzwNWI67Rc80+39eqzdGhmsqfqBwTyoqNOhZx5FIVaJPPVvjWKjc3p0v
7+vB/qjPK0Y=
=uPx3
-----END PGP SIGNATURE-----

--=-rgc/U5d1RyccnA6OHvWr--

