Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59729 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbXLUMej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Dec 2007 07:34:39 -0500
Subject: Re: [PATCH] mac80211: remove useless sdata variable
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Schwab <schwab@suse.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <je63ysp7ua.fsf@sykes.suse.de>
References: <1198195385.16241.68.camel@johannes.berg>
	 <je63ysp7ua.fsf@sykes.suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AYbynet+1/A7zmgnbk39"
Date: Fri, 21 Dec 2007 13:34:31 +0100
Message-Id: <1198240471.16241.70.camel@johannes.berg> (sfid-20071221_123443_223952_87CD6BF4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AYbynet+1/A7zmgnbk39
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> Perhaps because it is used?
>=20
> > --- everything.orig/net/mac80211/ieee80211_sta.c	2007-12-21 01:02:11.25=
3160428 +0100
> > +++ everything/net/mac80211/ieee80211_sta.c	2007-12-21 01:02:32.1131659=
07 +0100
> > @@ -458,12 +458,10 @@ static void ieee80211_set_associated(str
> >  		return;
> > =20
> >  	if (assoc) {
> > -		struct ieee80211_sub_if_data *sdata;

Too little context. There's another one in the surrounding scope that is
already initialised exactly the same.

johannes

--=-AYbynet+1/A7zmgnbk39
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2uy1qVg1VMiehFYAQLNQhAAqdBz078U2yVo9wGTAUo5yDtAL4KSoejc
ijvyJ20JAtsQaluNQB/8g7vU7/kvEpy5aY1nM1J1XnFQQlbFCM+N+Ni6wUV9sRkt
AQnnJBmMWgoFm3zszrGW4ZfjrSR6AfCUEdfSMmIzHalAO8NlvOYChG/bwG/v5Zf/
rPcT0OUVIGfzHMNnpuNvw05Z+eIWyrgGXrzbNW6pb1IShMRBHgV8bRp6YXL/S8fu
rauuS7u8bCud4ZPbMMHkIdgo/nwZK8zx7TtJ+M1QBKIu/qudyzq82GcWUAeDCfrJ
3fo0QemWHYDMLbqcrWKOXx/hT5mTNDzUVzijBcbAq9fRiMr0y0ZFh0eevFVnir87
sWzBzMFhSH2O1tmID2y+l/gr2KBF3n0BtqXRdm9jh3KDKXMrJ5qWwPvxtp30AUZB
KqcW4Ad6268/maVb5ffMpTOakNtF8ylLLQf3aj6zs7yXxglRDPp0zeqrB4QdwCeL
kpIgXeovodgMhNxBCy03rKOoT8WesLcUc/63r0+kaRruWhuKHwRYzgjeyc5P6wSM
K0vcvyAXFEmImCtZJ/AiVC2jhRrXj6jzt+7hx0r1xvdC/wLxeRktbvn8LFdqeaa/
g6MgGsNndVkVdAWNdMajed1xKFmGPQCHviHlrf4acQFmOFhwfrm0nwrw/HfVCqLJ
xj0v94yeU7E=
=4d3n
-----END PGP SIGNATURE-----

--=-AYbynet+1/A7zmgnbk39--

