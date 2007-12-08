Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60547 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbXLHL4t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Dec 2007 06:56:49 -0500
Subject: Re: [PATCH 1/4] mac80211: Clean up rate selection
From: Johannes Berg <johannes@sipsolutions.net>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1197114334.7472.66.camel@localhost> (sfid-20071208_114607_163274_14030D87)
References: <1197112439.7472.34.camel@localhost>
	 <1197112909.7472.49.camel@localhost>
	 (sfid-20071208_112222_400278_02DE29F9)  <1197113375.4171.50.camel@johannes.berg>
	 <1197113615.7472.56.camel@localhost>
	 (sfid-20071208_113407_806694_1684F565)  <1197113812.4171.53.camel@johannes.berg>
	 <1197114334.7472.66.camel@localhost> (sfid-20071208_114607_163274_14030D87)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HumAEMpAReF4GbiV7VmM"
Date: Sat, 08 Dec 2007 12:56:46 +0100
Message-Id: <1197115007.4171.55.camel@johannes.berg> (sfid-20071208_115653_154843_8F4715A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HumAEMpAReF4GbiV7VmM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Right, but I guess that Intel's algorithms do something different and
> > this would break it. IMHO that decision should stay in the algorithm
> > itself.
>=20
> Actually, I carefully check the iwlwifi code and it copies this exact
> code. Finding it in there as well actually convinced me to move it out
> of the rate control.

Heh, ok. Let's leave it like this then.

> > > Yes. It's after the get_rate() call so the algorithm can override it.
> > > But if it doesn't we compute it ourselves.
> >=20
> > Hmm. Then the algorithm can't specify "no fallback rate", can it?=20
>=20
> Correct. But why would you want that to be possible?

No idea :)

johannes

--=-HumAEMpAReF4GbiV7VmM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR1qGfaVg1VMiehFYAQJ7zQ/8Czlhkghp+ZZbHUkhclWYzUNvTZuCdwJw
CTQ1UfsyCmZq5NjXTb78X69v3v45Rx6LI0TrMGyw2YKnDnDQ01cH0ozmNIs/XgrF
Qx5AFD8vf52+SsjcNvjNlT7HkedZrkM81VqWEfkZ0MqafW8XDxvPkNarpMm4GXoL
oD9plWlVPA2voXJLzOlQVNd1kz16lSeUMMjZXnyb8naNGzrNsUX4wR+qy0diu11Y
iYkIFVqPYIqa5Uv3FNDHw0nog5V6TynqmWNPjj6SQsCzBolFcAMGi/y7ApzKP3nP
iaNizdhB4C6gbZSOvappqsRsIkSRscG4UlpDqnsBmURd6wPg3VwjAMlzjLZ6vqKu
e0eLTQ7VDH1t0v7cftdLarcuuVpT86jjK7i62zdc8yU0kT0POMC8/fqSzH7cHiN7
i5GPKal1vazcB3bWl5DJz/QYIj01Iz7qEEgrkb/fTYxJHMsAWT4g0obmGYinUgvw
UU8YRUH3uF/b+2LTfpIi1BMfSIyu/nppWw021s/vN3SAwzTklk5XFZCd19kEa0dp
6ex6dFNSSC6WTJfGG0QrGeGjbkY0MziXbZdIogya1FjduLqV7T+ld5bUKxNuo6GB
vPafoLpCGoYn+K2GvVP61S1RJfOMjUWKcfMWUJtPJWC31xA/s5pgudrz2E7W0EDw
2rXTwJlDZdU=
=VqQG
-----END PGP SIGNATURE-----

--=-HumAEMpAReF4GbiV7VmM--

