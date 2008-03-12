Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53316 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbYCLI0f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 04:26:35 -0400
Subject: Re: [PATCH] PS3: gelic: ignore scan info from zero SSID beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Masakazu Mokuno <mokuno@sm.sony.co.jp>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	cbe-oss-dev@ozlabs.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Stefan Assmann <sassmann@suse.de>
In-Reply-To: <20080312102148.0B08.40F06B3A@sm.sony.co.jp>
References: <1205254237.8774.0.camel@localhost.localdomain>
	 <20080311171024.GA18562@tuxdriver.com>
	 <20080312102148.0B08.40F06B3A@sm.sony.co.jp>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-R7jApoHaL8pBD2oJNceg"
Date: Wed, 12 Mar 2008 09:25:10 +0100
Message-Id: <1205310310.6387.56.camel@johannes.berg> (sfid-20080312_082639_900284_882B8D6C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-R7jApoHaL8pBD2oJNceg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Does this problem apply to probe responses as well?  (Do probe
> > responses from hidden SSID APs still exclude the SSID?  I would
> > guess not.)
>=20
> There has been a problem in parsing IEs, so if the received probe
> responses include zero length IEs, they also suffer this bug.
>=20
> > As long as you can still associate w/ hidden SSID APs, I don't see
> > a big problem.  Even if you can't, no information for those APs is
> > probably better than bad information, no?
>=20
> I was anxious that the userland apps or the users may get confused.  Any
> other thing harmful is not found.
> OK, I withdraw this patch.

I think John actually meant that it would be better to have the patch
in. How does a "bad" scan result look like?

johannes

--=-R7jApoHaL8pBD2oJNceg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9eTZKVg1VMiehFYAQIKZQ/9HOTKoxDMxWIwXUR80slXjo8R18zF4nCR
zI3Nb7oKwu8YUyx7ASOfYS7hTFOAOoQlRoV+FSHa7CLCmod/RkyrBd7vK/bxS0gs
XHGd7Rv1ZxI4wLOWgCQ3dozb+Hm674UfgIWe8gnYHM96abyfhhITMQHbZo5Jhm5W
SQ2IYzxJWZ4BYDgu/WdqXWrV4qeJzaQ141qhHDV/WpRfWDAYeLFzVLlmSLUYhtdu
9Z6vng1olRzuR/iTSQXK3dd3PlPOeLeXtkRlYhb2ec/aUshA5Mqs3OqM5y2X9+MM
dbVWNBt96P5ioAfvM9j0lr2h/dP9KvYeIQa+VTztVlBCesrAKT2PB81NOvjbW5jd
vY7gQVC5klVmtneyU0d17ke1ctnTif6tYkC8Ke/g7yuPltJfHbUKVkFH2ARplmd/
wIrBXP8T495O0+9uqf/AK9cs0xAsUSFZ/74a+2kBsi8dMArxb8trGM3ElQMxbyXl
tFgHj3xG34Nun1/RD81QM4zQ55BSE2wwb+HC0w1BQgi59Ekz1ge9NAPMIc8Xq9Xe
zur0hNW9M908zAsczS8XPzA20BLfRfPM0WeH8iw6r9028f0vsD/GwutF9HbWVIJg
f8LQOHJl/FCyk6I4tHpkFWYfVgRNbmitqo6Q6x43moypOYGndHgoB398PqAy/qJO
gngEZWICg/Q=
=+Xjt
-----END PGP SIGNATURE-----

--=-R7jApoHaL8pBD2oJNceg--

