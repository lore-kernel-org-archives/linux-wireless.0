Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56751 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbYJFOXy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 10:23:54 -0400
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Elias Oltmanns <eo@nebensachen.de>, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com
In-Reply-To: <b6c5339f0810060712r24b0dfd8s6236e65304749572@mail.gmail.com> (sfid-20081006_161241_841588_FA70583E)
References: <200808101401.03339.toralf.foerster@gmx.de>
	 <87od23mo08.fsf@denkblock.local>
	 <b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com>
	 <20081002144600.M31352@bobcopeland.com> <87bpy32c1w.fsf@denkblock.local>
	 <b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com>
	 <20081003134648.M45120@bobcopeland.com> <87fxnd2112.fsf@denkblock.local>
	 <20081003193739.M19356@bobcopeland.com> <877i8nky65.fsf@denkblock.local>
	 <b6c5339f0810060712r24b0dfd8s6236e65304749572@mail.gmail.com>
	 (sfid-20081006_161241_841588_FA70583E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3Qm6989d9d4m6SX7XffL"
Date: Mon, 06 Oct 2008 16:23:07 +0200
Message-Id: <1223302987.15196.24.camel@johannes.berg> (sfid-20081006_162357_366732_03793708)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3Qm6989d9d4m6SX7XffL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 10:12 -0400, Bob Copeland wrote:

> Nonetheless, I admit not being expert in this area, nor do I know if rely=
ing
> on the freezer is acceptable, so someone more clueful, please chime in.

It's not, it's supposed to be removed.


However, I still think ath5k shouldn't be much concerned with all this
because mac80211 should just disable all interfaces etc. from it when
suspending.

johannes

--=-3Qm6989d9d4m6SX7XffL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI6h9HAAoJEKVg1VMiehFYGfEP/342JtyBPKe3md6BpG+C+kZN
dUfpBRitEV5xk2Qa63L0MUvPPIHP23AGv/qfIgSP+J5I9XJz1qRZtTM/G9HIAuN2
DakWKRN6fJI9G6TWIYQchcXK1hArwonmpQARyNwRFsA4T+Yi+9aLIaUWvLBkZejZ
HooWhD89my39JKbYd+GOWPvs7Olo4bezd/HkNBLK3JhTGd2pPxjrGif/QuXHpqY5
V0OYWZI68dt+gkowZHM7YMjNAYGG3Nqya+e6AUhlO6ruVDzseU8u8inwtZ7pqRea
4DKkHjhZmIbmnuaLtI0upzESNsm/Xkua73kAa+JQUwqKIUggwukUix7BN0s/tY7Y
kwlokRJ6ZlHRhAvFp7v3g0Wpzm+drs85Zn6dbs5nrsJi+DSFpJBB5YDhrJuB87nK
NHiA7jTTobaJjFMdDgwHi49zkx5R+rNS8go3FZjCFpoTenVzI5zvFxak3FVclvxW
fKTRpg2MNRT+jYjs4PUKKD2AfNqX+QtBmHeXEsS3//7ienOayOj3iaC/Mw/KmoZg
kG/uI+NAYL7T3kQ9P05M9+VaxNcrWjylUjMfnTBhy6VBS/WtK72hiPK970ByF0LR
VSe+FJUC3fx8hwgosUKtKIjNbByMI0idOgwSLjV58X/5c0hwTXXuipxNnK1FNLaM
5cbwv4sqRB0edI8bmD7D
=QVsy
-----END PGP SIGNATURE-----

--=-3Qm6989d9d4m6SX7XffL--

