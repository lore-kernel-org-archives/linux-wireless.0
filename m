Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:45250 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755179Ab3AWMwh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jan 2013 07:52:37 -0500
Date: Wed, 23 Jan 2013 13:52:28 +0100
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, victorg@ti.com,
	linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv6 0/6] Add DFS master ability
Message-ID: <20130123125228.GC23989@pandem0nium> (sfid-20130123_135240_817466_05CE82CB)
References: <1357650251-17425-1-git-send-email-siwu@hrz.tu-chemnitz.de>
 <1358378574.15012.62.camel@jlt4.sipsolutions.net>
 <20130117142125.GF19552@pandem0nium>
 <1358546933.7922.49.camel@jlt4.sipsolutions.net>
 <50FD1C7C.5050606@neratec.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="adJ1OR3c6QgCpb/j"
In-Reply-To: <50FD1C7C.5050606@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--adJ1OR3c6QgCpb/j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 21, 2013 at 11:46:20AM +0100, Zefir Kurtisi wrote:
> On 01/18/2013 11:08 PM, Johannes Berg wrote:
> > Hi,
> >=20
> >> As stated before: "available until ..." time is not neccessary as far
> >> as I know. Also the channel must stay available when AP stops operatio=
n,
> >> I'll change that.
> >=20
> > Yeah, I checked the documents myself now ... strange, but hey. Radars
> > are fixed installations and mostly active continually, so I guess they
> > figured it was no big deal.
> >=20
> We were also unsure if this makes sense and contacted regulatory for
> clarification. Indeed, with the current document a scenario where "I swit=
ched to a
> DFS channel and skipped CAC because I passed one half a year ago" is fully
> compliant. Practically, when you set up a new AP and do once a CAC for ea=
ch DFS
> channel during installation time, you don't need to do a CAC ever again (=
as long
> as you do not see radars).
>=20
Thanks for clarification. :)


> Why then bother with CAC at all, one might think. In fact, exploiting giv=
en
> requirements to such extent is mandatory to make operation on DFS channel=
s usable
> (which btw. is not the scope of the patches discussed here).
>=20

I would actually like to make operation on DFS channels usable by using the=
 implementation
=66rom these patches. :) Do you imply that we couldn't practically use it? =
Any suggestions
what can be improved?

Cheers,
	Simon

--adJ1OR3c6QgCpb/j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlD/3QwACgkQrzg/fFk7axZ7MgCgqDy1WSFBZB/Tf19rVQ6YTvUW
FswAnjj7oaosbJpRw7Px+x/oLv/8RQtC
=U2Us
-----END PGP SIGNATURE-----

--adJ1OR3c6QgCpb/j--
