Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51189 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761983AbZFPT7l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 15:59:41 -0400
Subject: Re: [PATCH] cfg80211: allow adding/deleting stations on mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org
In-Reply-To: <445f43ac0906161251v63d59cc1jd72bade62910d086@mail.gmail.com>
References: <1245177064-31861-1-git-send-email-andrey@cozybit.com>
	 <1245177307.21287.34.camel@johannes.local>
	 <45e8e6c40906161142m759e6ecdgc6765333a4cced01@mail.gmail.com>
	 <1245177946.21287.42.camel@johannes.local>
	 <45e8e6c40906161155i1e5dc5bag114dea7a8c6caa66@mail.gmail.com>
	 <1245178613.21287.45.camel@johannes.local>
	 <445f43ac0906161232x743d7ab9u2f36a5893240b789@mail.gmail.com>
	 <1245181069.21287.53.camel@johannes.local>
	 <445f43ac0906161251v63d59cc1jd72bade62910d086@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Pk2NbRafD9in9fSdqGZ/"
Date: Tue, 16 Jun 2009 21:59:13 +0200
Message-Id: <1245182353.21287.58.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Pk2NbRafD9in9fSdqGZ/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-16 at 12:51 -0700, Javier Cardona wrote:

> > No, I don't have any in mind. I wasn't aware that only the mesh_id
> > defines the mesh, I was under the impression that more needs to match,
> > as codified in mesh_matches_local().
>=20
> In addition to the mesh id, a successful peering requires that peer
> candidates use the same methods for path selection, congestion
> control, synchronization and authentication.  None of these are
> configurable via iw (essentially because only one single option for
> each method is implemented).

Ahh! Ok, goes to show how little I understand the mesh code. IIRC
somebody had a patch to make those configurable though. I guess as long
as those need to be configured while creating the interface the API is
actually very good and much better than I thought :)

johannes

--=-Pk2NbRafD9in9fSdqGZ/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKN/mOAAoJEODzc/N7+QmaEVsP/0t8y1Ttj5E/bGs+UCeE7Gw5
knZ5nYviGcxND2jUh2ITi7LCMIPkAFrhFoBlVhz+gZ6GFutksm24NrZiG6dKVIZj
EKeQSrZvPV2+HuB5PqW+m68lKeMjb20DXDi1dcdhW95AQSDGxPdJhly+ouImXFxx
GEpBsYzPvj9C3uHFp9tjhC3ykHyD+LUw7zMBwN7maFjI5yNtvWd6fpA8HVz8D5XS
2fmEPUqSuoSSVs8k8jsTdt6DP1vB/LQANW2ghlgA2OolSkYG7TGrtNxmtdsXO2Kz
HZ1XzovD435HnVtWa6HlL5xmoTDJYF81nlBrNvfFCSp0bK6rPoAqlRVqnC/jWwmo
s5ogPZaC98wjxyR0rT7t05dxdrNkM5+hY345I0Oowdgd16F5WmkhqoHfqMX93eH7
VDPpEFh5sNzKCziRF8HTNQDgyw3eCJOSkbMFYa6racIxEI7Xrxcaow6WL/8eEdxw
8g+8uWFhaXYpOgBKENAj5K5LeMou5Ws3bsD3jaa/wx4tYHZpEZDzxZdN7qIhZ7Pp
JDoThQm50nzJSa273Yv7cHoC8whD/jVOqmQy6MJNISO/gB1JEINtt4Gk4SYfcz8L
nv1x5jRx7gu3nfh16xVNZyEqHvjWpaSLp/Gf0rBhYJXAr3ULkA7XNid61uZhcrsu
mPq0SosrO3t1vD/aAAmS
=NxQi
-----END PGP SIGNATURE-----

--=-Pk2NbRafD9in9fSdqGZ/--

