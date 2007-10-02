Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45879 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbXJAX7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2007 19:59:42 -0400
Subject: Re: mac80211 hostapd state
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710020151.56539.mb@bu3sch.de> (sfid-20071002_005512_326306_3C3BB318)
References: <200710020151.56539.mb@bu3sch.de>
	 (sfid-20071002_005512_326306_3C3BB318)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YWkaqRiig+dmBHsBXabN"
Date: Tue, 02 Oct 2007 02:01:13 +0200
Message-Id: <1191283273.16022.5.camel@johannes.berg> (sfid-20071002_005944_453389_FCAA3A50)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YWkaqRiig+dmBHsBXabN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> What's the state of your mac80211 hostapd work?
> Did you get hostapd compiling and working again on mac80211?

Yeah, it spews a lot of errors because it can't change the regulatory
stuff until Luis fixes it up, but it works again. You need both the
changes to hostapd and the kernel changes from my patches:
http://johannes.sipsolutions.net/patches/hostap/all/LATEST/
http://johannes.sipsolutions.net/patches/kernel/all/LATEST/
(for kernel you want to start at patch 5, some of them have been sent
already)

> I have several AP and IBSS related patches in my queue that
> I'd like to test before pushing them out to John.

Great!

johannes

--=-YWkaqRiig+dmBHsBXabN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwGKSKVg1VMiehFYAQLeZA/+PlP+eSGwu7ijLr3mmD5rqC3k10G2qGg7
13hncFIUv/sUXmzMhf5OeYrNC2yvwWZ0KhjZXDaaeLFINqdP6s1vcUByS2d3XSa5
LQqMXgBvOHL0Ieq61kMgDo1YESplxWfYs/q5fiq25+/y3OL9eBBTkTLs1AVy3VLY
ua65YxnVIANPyi3PMil9a0BleVLO0L76gBe2OoRDX70QFyOjNoJ05rYEIbOVpz/5
1+OzO8lUmrxabd5Jq8c8sUcX/JKNurez/EzIUntYFW+GF5JKD8cMODW4xSTjeQ6t
HgXDSUGlVID9RFKnta4eV9LfmrjQVK2hP+4eB0aWR6oSZfK7LCHAS191X9c44Zcg
NkbQFVcU3U2QQgpQLmjg8QSKEiuHlATwjFADAHnOz/S8avu246j2HAmf/fo0vH//
IPz+LryFGkOWlvZyD2eiS7o0qwEk2ViWhxYkk43qrr/+kQoxZyiUjBbkyr72nyvk
x3SIZ+5v0/WuOI0uv5xCzKqFm18CV3vD4Ickqp7q/oVw2nNBQOgvNwUVfFPm8kF9
FT0Z9V6HVdVDGpX7Q9gkwvPDn4FfPtXQwqkWeADJVXJiL1AeB3dhMmunjawdUeG5
HIAMQDWP3LSEeC2DbUjPjHXyTcGEZJ+gG9kxK6EfiproaB8+6txycLDesNMfLD3j
6E1ZjqHfbcQ=
=/PQn
-----END PGP SIGNATURE-----

--=-YWkaqRiig+dmBHsBXabN--

