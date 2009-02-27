Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59529 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016AbZB0VBc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 16:01:32 -0500
Subject: Re: [PATCH v2] mac80211: Implement commit in wireless extensions
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <20090226232149.51510@gmx.net> (sfid-20090227_002221_567849_E4A0B0C8)
References: <20090226232149.51510@gmx.net>
	 (sfid-20090227_002221_567849_E4A0B0C8)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MCKh36ya5/9pK9XbqkUb"
Date: Fri, 27 Feb 2009 08:19:14 -0800
Message-Id: <1235751554.7426.3.camel@johannes.local> (sfid-20090227_220136_821470_BC1F8D54)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-MCKh36ya5/9pK9XbqkUb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-27 at 00:21 +0100, Alina Friedrichsen wrote:
> This implements commit in wireless extensions for completeness and
> maybe it could be useful for debugging to initiate a new rejoining
> process without changing the config.
>=20
> I not so familiar with nl80211 at the moment, so I want add it to
> nl80211 in a second patch.
>=20
> Signed-off-by: Alina Friedrichsen <x-alina@gmx.net>
> ---
> Version 2: Fix bad header.
>=20
> Hope we can find a compromise in the conception.

I stand by my opinion that I don't want to have this in the code since
there's no real reason to have it.

johannes

--=-MCKh36ya5/9pK9XbqkUb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJqBJ/AAoJEKVg1VMiehFY1LIP/AuxlRaXrCpJctZ70T0jqdAG
Yce0fUtoQgpKQnP0Y9k0w1sRK80mQqyQ4Snm+L+7CsiZCPY5EO5bQmMY4DPrE3bC
g13Qv+oZlPfMmehSYgttuD1U91r0R98pZPnYYmjHnl/GXfs4KW80eYU4cE/9r4OG
8VakjyoF4WgLlvfMOdFRYTXz2s4FnEfsd6IthBIzXEMtWDwWbFcBBEWP2+LeTTEr
1wAeClQSuP5111nK++/0MUvt/NtxpC9B1P4u2b8tgjHjvL2k5TgQI6V/Q4ATidM/
XZwnUDcazsptRiixNIAc+Apf2POsC7RqzNcZA6031je7EWOYSWi2mXozxxEq4fzD
xqXCO5hTnc5lx9Tt0DU0KPwpgWpsuE8rMY7qtT5N00ubYJqmhnTx3uIw7spsp+d+
kRr/PZ4+F2aEWiejg4JeBKwxRXAHGNAbFQx+RU3utcDLYIOEqE0hy4AYcB+H0QDj
US/NbCsU4aFcLQl9OYzJCT/NvKIpXKdcZBHrkKjvgRnGnyIULMVr6nGeEYVro4Pr
lNSHjsaMoAYOfMSiqt5nkqhtmIs/IsngzPAFXUbfXINqTPxhaK332uDhMY3gsLm2
O1lC28J67UA3lzO/wCg+AXc85sk4D9fpSV0O2uxUrp7iRvzFkn41Uz39/CNO8nnf
VoWSFAIzH1J8PAWSB4O2
=rpLx
-----END PGP SIGNATURE-----

--=-MCKh36ya5/9pK9XbqkUb--

