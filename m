Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694AbXKYKyB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2007 05:54:01 -0500
Subject: Re: mac80211 regression: doesn't associate automatically
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Dyson <will.dyson@gmail.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org
In-Reply-To: <8e6f94720711241439x27c1a48dxe3f3698043fb05a8@mail.gmail.com> (sfid-20071124_223922_820218_8E241E5A)
References: <200711220912.10452.hs4233@mail.mn-solutions.de>
	 <200711221719.40412.hs4233@mail.mn-solutions.de>
	 <1195821998.4149.113.camel@johannes.berg>
	 <200711231423.23910.hs4233@mail.mn-solutions.de>
	 <1195940177.4149.203.camel@johannes.berg>
	 <8e6f94720711241439x27c1a48dxe3f3698043fb05a8@mail.gmail.com>
	 (sfid-20071124_223922_820218_8E241E5A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ugN23KRUDtc4xIN7nGv0"
Date: Sun, 25 Nov 2007 11:53:55 +0100
Message-Id: <1195988035.4149.218.camel@johannes.berg> (sfid-20071125_105407_969604_7EEA90E1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ugN23KRUDtc4xIN7nGv0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > iwconfig eth1 blabla
> > iwconfig eth1 mode monitor
> > iwconfig eth1 mode managed
> > ip link set eth1 up
> >
> > can probably never work properly. In any case, we ought to fix this
> > though right now I don't know what the best way would be.
>=20
> Ugh, yeah.
>=20
> Would "bringing up a STA interface always triggers a scan" be too
> horrible of a kludge to contemplate?

Simply triggering a scan won't trigger association either though, will
it? So we'd have to manipulate the mlme state machine too. I don't like
it much but I guess we don't have too much choice.

johannes

--=-ugN23KRUDtc4xIN7nGv0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0lUQaVg1VMiehFYAQKDZg//UYF7vj2zDA1SVlsMg+NZdCJpYo8Rwv6c
ExHYLu2KIGyIYVQrbYC2ZMcnPmu4qkA21+x1jbDwTwPMzkz5zIMO4z3RAtRyb48k
LIvsfzTkXIPc8Iuo0rzT3c0P7qAsfleZuwU+VRotWWRkkPRAIaJ9ncK1pgHVJdpC
LKq51NTQVZ5yPFSL0Ogpw6NHnCNLciOemM4HLMz7Kk4L6BluPw1SaXUsJJ6DUR8Q
EG2YfqTXQqcMxxskSb5k4ttUfp1gBPP/Pqccjyem3Fy1X/przLil6agHc4uFWX9L
8SB4eAT1RXLDjNF1SEQsw0IFDQJIXR+pQwl8m31T6lXwmrrPw+xZj3eXj2MxXuHm
xQJzONbNpu9Jwt1UpBlzaY9XPWVpcWPVAg/DUfR9vN8ELbjFvhhPLdXJvY722GBl
maJkGKAVV1f2b26Mt4FxEhhkMm2H36lByJIDaWRHLxTm3jEKMPUppOec1I7hiGYP
PFAQyHfiWWcU93eyGNFH/OEjKGrQ4RkWGUBqq4mWf17cP8LK0Q4FSm1iJByfHe4f
Vd6+A8aJeidzoFODgaF3yP6nrZgeyA46b9Y676tBbf/BEda3C00+EpF56SCowCve
ljjOASOdDYN6fayeKMVSELI80Y6hCxMVaKO5hbocSs1kqctaCsA3Ged6tQAUupHt
pRoUUeupg/8=
=pAoE
-----END PGP SIGNATURE-----

--=-ugN23KRUDtc4xIN7nGv0--

