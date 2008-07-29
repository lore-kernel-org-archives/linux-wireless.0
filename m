Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55096 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYG2JQj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 05:16:39 -0400
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
	rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807290138h7deced1cob0836ae3e3c1e71a@mail.gmail.com> (sfid-20080729_103802_642936_02CAC6A2)
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <48874F09.7060400@lwfinger.net>
	 <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	 <200807290021.45400.herton@mandriva.com.br>
	 <1217314430.15381.11.camel@johannes.berg>
	 <1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com>
	 <1217320089.15381.25.camel@johannes.berg>
	 <1ba2fa240807290138h7deced1cob0836ae3e3c1e71a@mail.gmail.com>
	 (sfid-20080729_103802_642936_02CAC6A2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+rlq4M9WXdsNl7gTkUi7"
Date: Tue, 29 Jul 2008 11:16:14 +0200
Message-Id: <1217322974.10489.0.camel@johannes.berg> (sfid-20080729_111643_208782_8B10FA2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+rlq4M9WXdsNl7gTkUi7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 11:38 +0300, Tomas Winkler wrote:

> >> iwconfig power on is not implemented by mac80211 yet. There was one
> >> patch posted that implements it.
> >> I wanted to expand it but  wireless_tools 29 has a bug in parsing this
> >> command. It is fixed only in 30.pre6 which is usually not in distros.
> >
> > Heh, fun. Time for putting that into cfg80211 instead if nobody can use
> > it with wext anyway?
>=20
> I've planned to but I waited for some API design suggestions  you guys
> will come from OLS but I didn't get much input.

This particular thing I don't remember talking about except that we
want, when powersave is on, be able to select the powersaving level
based on information applications attach to their sockets, rather than
requiring the user to make a guess.

johannes

--=-+rlq4M9WXdsNl7gTkUi7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjt/aAAoJEKVg1VMiehFYBPYQAKrnpOQtavFNNRUbCNQ+5Pon
AkR/g2wfsyWoZxzVyXsxDCWg+PqiVBdGVWKQOPoN9HO0tKXChKiLKE7Q59pmFJHb
zNfvFPVotaZOylqomVCBYSprc0p+7A9KKhBAWjKHa5Hs5ERAiwDJrlFCyrw0daiG
aDdmspraWiAVInwO36VA2jYKsKA3feN8/o6571BAOnsFa3HQ4yE4skcjsB1Xmx1s
HLBYXxT9XOQKSSp6OwIE13Dre2k8UxG4l9xhIfQtc++VwuOt+CsNpsqUYVXT9kkN
L+kPlVqmN9YiuWGWn74bdmLONkKxh1CDkn/90vi+bjaW2jtnpYuINMr3ix+R3zLf
xqjdutTPFvKs2ipyXDmPEnWmSdCqLKr0NnuFZsg5mVoA7vpIBGFJqOFIiluGdDTl
d497Mpke9bstNp/pw71e+bDEOtbbE4gzTHPYVqnsFS7gW0lNeEdipBwW95kjugXf
pQMWI4L+v/YHsMLlvEy2cgUogehX2H3zefYeq7Z4FCnmba+EQDcMNbpgY817oiCx
zMh0ty83Mqq6LTPVf53bJVA3xmAuStkhiidHCfPn8x2McaH0DRY0D12aeVSrbiQc
SHMsPNsmX5Ch4fT1wnZlj0ET9uJjEJAfc0/l8wZKdHcCC5Yn3CURWlOCjCGg/bS/
xB1P3EoFJDZJTWHQUmfv
=boE/
-----END PGP SIGNATURE-----

--=-+rlq4M9WXdsNl7gTkUi7--

