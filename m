Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54144 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755313AbYJIKky (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 06:40:54 -0400
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: Elias Oltmanns <eo@nebensachen.de>, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com
In-Reply-To: <20081006143055.M60271@bobcopeland.com>
References: <200808101401.03339.toralf.foerster@gmx.de>
	 <87od23mo08.fsf@denkblock.local>
	 <b6c5339f0810020552m7b745a0fr336ae7b245b3b899@mail.gmail.com>
	 <20081002144600.M31352@bobcopeland.com> <87bpy32c1w.fsf@denkblock.local>
	 <b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com>
	 <20081003134648.M45120@bobcopeland.com> <87fxnd2112.fsf@denkblock.local>
	 <20081003193739.M19356@bobcopeland.com> <877i8nky65.fsf@denkblock.local>
	 <b6c5339f0810060712r24b0dfd8s6236e65304749572@mail.gmail.com>
	 (sfid-20081006_161241_841588_FA70583E) <1223302987.15196.24.camel@johannes.berg>
	 <20081006143055.M60271@bobcopeland.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9CXbdzDQqGiMxZsVVuRK"
Date: Thu, 09 Oct 2008 12:40:39 +0200
Message-Id: <1223548839.22490.49.camel@johannes.berg> (sfid-20081009_124058_254312_22F4F1F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9CXbdzDQqGiMxZsVVuRK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-06 at 10:36 -0400, Bob Copeland wrote:

> > However, I still think ath5k shouldn't be much concerned with all this
> > because mac80211 should just disable all interfaces etc. from it when
> > suspending.
>=20
> Agreed.  I guess if no one else gets to it by then, I can take a look at =
it in
> a couple of weeks after my GRE.

Cool, see also
http://wireless.kernel.org/en/developers/todo-list#suspend.2BAC8-resumemana=
gement

johannes

--=-9CXbdzDQqGiMxZsVVuRK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7d+kAAoJEKVg1VMiehFYhJ0QAKoOn8+surBFcTSkHhgcIUll
nTvILmomsZt5TeSxtSF9Q7qVhASadBfNubuUe0XvBzFfi78k1h4R5A0KN9d+bTic
+D5MeDN08n7NCS0OlW7suwDS4+cqDR70eNM7BGFv7lgE//gXZ2u1Tdgp6JlTqUN6
3EngwHDabVSFF69KR6PJSfGylGGu4zlzwRbbwW2GU4iDKz9tguOwik+sapphV3qO
JUIrQWfmM3drUPax2Y6Rsxeg+wCdHCluiNKTgPJclDXhWOQtCFXVPe3qHRs8tmPT
aXnWhp5KwgfCDpT9gnmqmhVmdz/EwEDBHqAjiH1joGpa4Mw7cwO0dRmoSaOkkC92
s7JwnFirkHiU6zuqKafq/eNMpiS/ESSSl5GvYVOxcXtX3DpH4g57Amla90zW1kII
2+wRikMaTDkWD4KCXTEDGiCThI+++ocTHdT1eNaMiiZcWQ/BNfuCU4Sx5g1ykDLz
Hyov3tr8WGYxMlWver4v1LtBVdo0JvcKwZvtp++dGrJkUdcKWfRkzimNIiVUXz3F
hJFTMyxbTOMLZCuRlfgcGR2tgVW61OEVdAUGM8LF/PFUABF9of161ZfQqN47auDn
BUk8qkOYqPDBlQGma4rXaDG/d1eB9m8SlYFdgzg1+XsmyHqA8A4LEu1qLL1B8/Gd
YD74PrsubO+TJe4t2aQ1
=TylW
-----END PGP SIGNATURE-----

--=-9CXbdzDQqGiMxZsVVuRK--

