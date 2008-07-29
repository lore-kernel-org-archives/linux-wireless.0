Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35515 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755385AbYG2LTO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 07:19:14 -0400
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
	rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807290416l7c489b50yca9efe637895725b@mail.gmail.com> (sfid-20080729_131603_908568_547AEACB)
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	 <200807290021.45400.herton@mandriva.com.br>
	 <1217314430.15381.11.camel@johannes.berg>
	 <1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com>
	 <1217320089.15381.25.camel@johannes.berg>
	 <1ba2fa240807290138h7deced1cob0836ae3e3c1e71a@mail.gmail.com>
	 <1217322974.10489.0.camel@johannes.berg>
	 <1ba2fa240807290226n19ab0944u8e27f40cb688cfcc@mail.gmail.com>
	 <1217323749.10489.7.camel@johannes.berg>
	 <1ba2fa240807290416l7c489b50yca9efe637895725b@mail.gmail.com>
	 (sfid-20080729_131603_908568_547AEACB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xEnGL8UOeug+1J7FxJ37"
Date: Tue, 29 Jul 2008 13:18:53 +0200
Message-Id: <1217330333.10489.17.camel@johannes.berg> (sfid-20080729_131917_857274_90FC00A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-xEnGL8UOeug+1J7FxJ37
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 14:16 +0300, Tomas Winkler wrote:

> I think the path of enabling user to control this through iw(nl) or
> wext is closer to
> come to usability as to relay on any application to implement it in
> next half a year.
> You need single API anyway since there have to be single point of
> decision as there are many applications
> running over single NIC e.g. VoIP and web browser have different requirem=
ents.

Umm, no, you just use min(what applications requested).

> What I would actually start with is to get notification about dc or
> battery supply. I don't think that class
> implements notification chain though.

That policy is probably just powersave on/off and definitely belongs
into userland.

johannes

--=-xEnGL8UOeug+1J7FxJ37
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjvyZAAoJEKVg1VMiehFY5KEP/1eG9UDuZW8j8cIPO+VGO1lj
Mu8Zhsau6dvQVIROu9l0v46aqWSd4NIoflWt3Xd2nL7dcVfShWAjYACKSCAFzErd
vS+rlUZCXetSDtvfNIPPZGIoVQ8phuc8AerL1ZsnDO1TpBMBxxyu0PS6M8vSVvyJ
LkexK7nDN8pksrJqA7G2BvCtrahIe2jGbSzUMGzxLYZdAw8p+qMra9RQPLX8TrfI
8tOyhvoiGkYJvJan+vmW/IYrLCbhdAxpOCBt/cOGbBiLvPdVt+r8t1sUyJcBOzRY
8EKZcG5jBNgsL1OsYkzIUS+YTSNnSPklHif115CN2wnUPqrWEnOISkUm4kRtC4m6
zolnSI4LZpB92TSJl++j+HlBwQbOmyPoKTNiSlW0kcJ+Um9a1w1auGTNDUdLvXJM
USDZjBbhFZKGTaIxsNGH2QGRn+lLa2aWd+GFeO/SlfSS84D8gDK69xo/1z3VN5zO
2snlPPwI1+SG7WbD0dmjn/p4e47wugZhi1zxCQE5vXQZBFNssh0SllGHo4wcmbiQ
LQ90enbGsVyJx3kjMLyV837MF5ic0vCoXYFPa7YgfTPwoTgkrjy5DkCEaQ9pMDZi
KoXf1Sm6Jwk+xbjaM6BqXe5X51y1ZObagiOMI2TS3J220lQQDL+sG0+lPDe6dsLk
pKoPWBr3yJrA4SPUGGuK
=HrGm
-----END PGP SIGNATURE-----

--=-xEnGL8UOeug+1J7FxJ37--

