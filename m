Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53216 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754886AbYBAMjS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2008 07:39:18 -0500
Subject: Re: [PATCH 1/1] ath5k: Cleanup after API changes patch
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, bruno@thinktube.com,
	jirislaby@gmail.com, mickflemm@gmail.com
In-Reply-To: <20080201012544.GD28995@ruslug.rutgers.edu> (sfid-20080201_012557_226237_9E84B85A)
References: <20080201012544.GD28995@ruslug.rutgers.edu>
	 (sfid-20080201_012557_226237_9E84B85A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YQb4dAeeGGz8bZ1PvOOD"
Date: Fri, 01 Feb 2008 13:38:16 +0100
Message-Id: <1201869496.4188.15.camel@johannes.berg> (sfid-20080201_123922_324302_217CB4B8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YQb4dAeeGGz8bZ1PvOOD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Finally make a note that we should eventually move cap_range stuff
> to struct wiphy.

What is cap_range and why should it be in struct wiphy?

johannes

--=-YQb4dAeeGGz8bZ1PvOOD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6MSt6Vg1VMiehFYAQKmtQ/9GYHBMkBRCZ/77aWUK0w1sqOb9vLHWJeu
8cTn9Pq+N9aOdfydF1WQ+aH4evBUdcpzTeIKbZ/fxogzcw4+t34evfRhjNlk1i6V
5gqh4Shijgkl4BEf7byXkY0Gh3EFKHQ6rwvXvP5lwpgDovtQl8xogiU6lPtvA80/
v8RhsJZ+jeoZNHe/OXSfYoMEdJzVSJ3Ixk2N6qVEeZKhW2Ylq1216Tzw7kEaR8Fg
1ajGgewkAisX8Zfe6eioaffo9e92m3mHT5Kvr+jEqJf5GexBzi1ygdbjGfX4s21E
QNOSvObQIklxMQksbkuIsrFypXC0wtWraBJ1Wu+I06KU4oTgB2nhMxli5veJA3Tx
FTrjcSzsyRskuQKhKbUdJE866GXw2knK1lbPOf1IG3kASs/nV5r213H3UYKuk3bJ
hSsnqxatfViRnyxQKcOthdmbQjYhcLM+B/RcAk4DmnzV6UDpCy8pHNO4fv+1cd5C
NupQRzTPW+3C2mORTuD2boF5DiKwHv5JK/9vgS+rxsgiJ5AViRo20Ahs32r2YnQd
Jlr7gZI0D0Y/Sh238Pw0D120+w3YfigHgQyhprJnkdrMJ/P1O/1CQO6ObvT6oB/h
4ZizhU9xGS6oZya7dMCHiHNgtcne04/dHeJHj0VQQTnfntZ/dR90Rn485/7qGRyE
gVziGWnA0+w=
=22gP
-----END PGP SIGNATURE-----

--=-YQb4dAeeGGz8bZ1PvOOD--

