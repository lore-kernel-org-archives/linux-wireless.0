Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46927 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbYDCKV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 06:21:28 -0400
Subject: Re: [PATCH] mac80211: add station aid into ieee80211_tx_control
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Chr <chunkeey@web.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
In-Reply-To: <1ba2fa240804021305o502d7e22o5ffebd0f466e4188@mail.gmail.com> (sfid-20080402_210556_074734_510676EE)
References: <200804012145.18294.chunkeey@web.de>
	 <1207128858.10910.19.camel@johannes.berg>
	 <1ba2fa240804021305o502d7e22o5ffebd0f466e4188@mail.gmail.com>
	 (sfid-20080402_210556_074734_510676EE)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-S4oDhWU7UTN20tlT9c0w"
Date: Thu, 03 Apr 2008 12:21:23 +0200
Message-Id: <1207218083.3636.12.camel@johannes.berg> (sfid-20080403_112131_682341_4865BA10)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-S4oDhWU7UTN20tlT9c0w
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> >  On Tue, 2008-04-01 at 21:45 +0200, Chr wrote:
> >  > This patch is necessary for the upcoming Accesspoint patch for p54.
> >
> >  Hm. I don't like increasing the tx control structure size but I guess
> >  you really need that :)

> Not sure why this cannot be bookeeped in the driver.
> Upon association AID is delivered to driver, so every packet that will
> be sent to this AP has this AID?

We're talking about AP mode, and afaict to do that in the driver you'd
have to have a hash table from sta MAC -> AID.

johannes

--=-S4oDhWU7UTN20tlT9c0w
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/SvoqVg1VMiehFYAQLf+Q//QxqC18Q69hGJ4DREwTdxMZBn2vcf45fy
cQjPbF8ZnGM4RvMcV78uyXAC17Vyg6RgU+gSTUwOApGMlq6wYFQ80oDIYZ77UOi2
fuGN+6BjP1144o6npd1V8QRdLFr5tKzmi3IUufaEwQCdh9PC/aqWDC+Q4u4p8clA
IY7a7P8mp67Oe/2RaChR2p/GNBvBYvO0zlMv3idGDkF3TgxLI+VO37R9OipDVoJl
PUsMusRCK4hjBQB1fmkHHrbi5aDIWWKdUljhGS7JsztUDcsrWCShQYKnMtE6AQGo
rWncmvaBng6urUwsp+SFC70ph0eG1reM8REa1nGk1EvBJnGC7JeZNAOxOCof14Xc
iXANZXwLpN5xbvCaDEwG4hvSB85qBuX70WlpXSuekOXUYeNCbkyuQbafnU3OmsC3
XdVZvjNU70fEBPVQ2JAU2SU5MSGC9wNFrTMdvat2rA6jIK+ArizLUL0spPWa6KOU
ySO/7pm49mYth/u1n/Rjuy2sr7vqiO7/MfbzuPWhJK8l5GJEM0sGmhpfofjUw00D
hpLn8yWbDV/wz0b/TJ2rB8Be3n0QdBPJBQ+LrZg1mx6rV0ooNqXrfM5dAGPxy6Pj
HZ/BDwd5Y3cdwAoTGz7VG0xZx29QxsKeAYrXuqRkef9v5838NmzjGeA8oAZJyYF7
X8+soHBJ6dk=
=zyo1
-----END PGP SIGNATURE-----

--=-S4oDhWU7UTN20tlT9c0w--

