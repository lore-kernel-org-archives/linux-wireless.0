Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbYG2Mxq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 08:53:46 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240807290535h3ebd4121h399b8a8cd1d8b276@mail.gmail.com> (sfid-20080729_143514_115734_59CDA1F1)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217331408.10489.26.camel@johannes.berg>
	 <1ba2fa240807290525o41832ccei92ff554bef876b37@mail.gmail.com>
	 <1217334452.10489.42.camel@johannes.berg>
	 <1ba2fa240807290535h3ebd4121h399b8a8cd1d8b276@mail.gmail.com>
	 (sfid-20080729_143514_115734_59CDA1F1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-X54L3Zw2vHSxhqOcjcha"
Date: Tue, 29 Jul 2008 14:53:43 +0200
Message-Id: <1217336023.10489.51.camel@johannes.berg> (sfid-20080729_145350_830426_95810CDE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-X54L3Zw2vHSxhqOcjcha
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 15:35 +0300, Tomas Winkler wrote:

> Sorry for misleading I'm not in focus today :). You cannot remove this
> code. This is form
> This is required for emptying packets from legacy queue before
> starting aggregation queue.
> You cannot transmit from both queues for the same tid  Aggregation is
> sensitive on ordering.

I see, it's required because mac80211 would otherwise start putting
packets into the new agg queue and then that could be used by the hw
before all frames from that sta/tid in the regular queue were sent,
right?

johannes

--=-X54L3Zw2vHSxhqOcjcha
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjxLUAAoJEKVg1VMiehFY60AQAKJDWMnfkYgVXg3B5EZffKsA
8K/dRAZ+FPJaDA2haylYlfwOUwfiBd4IQbtmD3Qweq0UMsnNcROw+q8WR+Hl4Xr5
6IfV1QZfu0W433TS0C8+UpkYzqX6ES4Qo5qbeQCrUgsbYXMVnFnpYgBQhzIwcrWB
5Gyf1KRU0vK9tfUKZt88GHQv3NhLoNVC3qfhQ3B2n815At1LGgH+X13MfYt/sk8T
REMtO4Z3PVmpuzn+YgWlqMDgoNnd8Ev8R8YKoTo+17nbhp12CuBYvm2CHJnK+DzM
UJDNqnTEbsm+MdZWMFmkv/ziz5gnEdnSghrd+Q6WQsqDJs5BMrlKLeaF+PJBSn+d
MHzKuH1GSJ0BTOtsP/IrEV4DapRqI/nbr5hCH8Rm5Ha7JLR03NUl/hP0kQmlx9mT
inR129VC0iqKlL+2lmUpR3EPXoKGbgJ2DiXq1AHG66sYiLkWAWcxxS0NaZd+RuN6
6Xa62iOxtRJXhbKvvS/sTt9tEtrAB92TcicVIZbzaoxj4k6euxrQVA+kaMvb4uae
PEMzSIA5JxVJb/as8heK0WlanyH73fUvwDihIwUrGdQr8OapqkE7MwHOb136Q6/8
MNQBrwqGGoPJ9d2lbzz/Mi33EUeb4M8gPenNhC7/SAU00qi+TduDslXGgZB72Hu/
+cmQMOmRw1DiQ5wVzqV1
=8VSs
-----END PGP SIGNATURE-----

--=-X54L3Zw2vHSxhqOcjcha--

