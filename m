Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58450 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZDSRTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 13:19:14 -0400
Subject: Re: [RFC/RFT] cfg80211/nl80211: add IBSS API
From: Johannes Berg <johannes@sipsolutions.net>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090419171546.158830@gmx.net> (sfid-20090419_191552_279073_CA045D96)
References: <1240094996.21583.1.camel@johannes.local>
	 (sfid-20090419_005015_625875_1781AFCD) <1240147370.898.0.camel@johannes.local>
	 <20090419143337.158810@gmx.net>  <20090419163204.158820@gmx.net>
	 (sfid-20090419_183237_340935_6640098A) <1240160041.28138.0.camel@johannes.local>
	 <20090419171546.158830@gmx.net> (sfid-20090419_191552_279073_CA045D96)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-9M/C+KxYF89Wn0Rz2kyX"
Date: Sun, 19 Apr 2009 19:19:10 +0200
Message-Id: <1240161550.28138.6.camel@johannes.local> (sfid-20090419_191916_897805_1F525C79)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9M/C+KxYF89Wn0Rz2kyX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Ahrg, can you stop sending mail to me and the list as two mails? If it's
a problem then just reply to the list -- although I prefer to be CC'ed.

On Sun, 2009-04-19 at 19:15 +0200, Alina Friedrichsen wrote:
> > I don't think so -- how would I express "use channel 5 if you can't fin=
d
> > anything" in a single nl80211 command?
>=20
> In the normal usage, you don't need it. Either you want make all
> settings fixed if you build a stationary node, or you set only the
> SSID if you join the IBSS temporary with your notebook. I don't see a
> real reason to have an optimized one command solution for that. And on
> multi interface wifis it's better set the channel and join the IBSS in
> two different steps. The channel setting has site-effects on the other
> interfaces, the IBSS joining mostly don't. (except TSF and so)

It's not about optimisations, it's about correctness. If you don't set
all things at once you don't know what will happen since something else
might send commands too.

johannes

--=-9M/C+KxYF89Wn0Rz2kyX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ610KAAoJEKVg1VMiehFYCQIP/ia+ao9y6vWok1jsmvASmPE+
uG32T+kfO8ChfB/JfLTpQLwvgRWOmiY9H3hQEzqbz73/5nQ3pSHhG7cO6tIO3qGz
kpE+SOqOWK7ErqVDNnxbvdxTQ9VMrRWguTUzXXMebk4o82auWeIMEmauI3AIzB00
sdDAFmsBbYuLuXosAgIbkJkOE3bUHYshaVRlJF4r8AVqStgDxUpUK22ZRKEbhfb1
m3DICZ8uZogre7438kWFLRqjOSG/kZnC5ASAZ04pP4bbpTbL02vmyb/feHu/1+Hn
qwdkZkuQu8XqAbndYCbPCYWc896fkOmmNmZCFbFwnbJWsSqWI73E43YmHLUEGmCV
jOHx80SNPeGl601R1KwyzpaAFRY9GF1vJyIPrsE7x0ReZWWNK0MmGYZpGHPwzumQ
dDrxQh/w41xoc2wteCLWukkTqOsJoTuO0tf5DfvhZd//GWHLAc8PAjOX9pLeoHbd
Nq5K/NlZDt1CxRQy4EiCqfE5k6V6Vzx1/UH1lrcVGXmqTIX5zXseZZNK7dvvv0w2
/xHJYRP+C+4UYT2xGKVJp/DoANR4p17wQ9hdMB7/1lNj0PHdzBUIG1fW07k51Gnn
wq/O+zTzldm8iaOz3BgfeT9xN3qgR6k0kJzL831CNEa+IA8FSSKvdGNF+X3jl/VD
3Wzh1XqAxOTS1C9IpGMW
=3ltT
-----END PGP SIGNATURE-----

--=-9M/C+KxYF89Wn0Rz2kyX--

