Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44629 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbZJTAd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Oct 2009 20:33:59 -0400
Subject: Re: [RFC] libertas: monster-patch to make CFG/WEXT configurable
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <200910191449.18915.hs4233@mail.mn-solutions.de>
References: <200910191449.18915.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AIpR4wk8oJJq12o2o4sM"
Date: Tue, 20 Oct 2009 09:33:22 +0900
Message-Id: <1255998802.4475.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AIpR4wk8oJJq12o2o4sM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-10-19 at 14:49 +0200, Holger Schurig wrote:
> This is a monster patch that makes CFG80211/WEXT operation
> configurable. My cfg80211-RFC/WIP-Patch would come on top of it,
> but would then be quite small, e.g. almost only changed to
> cfg.c/cfg.h.
>=20
> As there's no mesh/adhoc/monitor mode implemented in cfg80211-
> mode, I added many, many #ifdef/#endif pairs. Maybe too many.
> Is this too ugly?   Or would this patch be applyable as-is ?
>=20
> If the patch is perceived to be too ugly, I could create an
> monitor.h/monitor.c file and singleout everything related to
> monitoring in it, where monitor.h would resolv to dummy static
> functions in the cfg80211-case ... at least as long as we don't
> have monitor suppport in libertas+cfg80211. The same for mesh
> support, e.g. here I could create a mesh.h/mesh.c and do the
> same.

I really don't understand the point. Can't you just use the cfg80211
hooks and keep both functional at the same time? Just like orinoco does
-- it uses cfg80211 only partially.

johannes

--=-AIpR4wk8oJJq12o2o4sM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK3QVOAAoJEODzc/N7+QmaOigP/3jPG6+cMifLS/g1FqFcYggb
QSs1+ZuXHp9wrRO/iEJonMS2KZUNKGgFTVB74YQF8/qyuBqcWT8WBHyCZKC2aTDi
3PKGx0GqLs+9YnjR+iKUIAmqy0mkWewtZ4OjZnLGMu+X+zP97+d9q7brK8Bbk+2z
IyHqW+uvGxO64ijMr64SrWVB6qvrg4k25+nFPC9Z3Ex/X+18c48wuvbZOvZkKTzP
Z4kmUryj+B2xOrCwCu4oZB/895QRlyrexVs7XuIe4LbqEXyXtz+uAXlTcRaygfZG
pjQiVe/CGp+Bfd1ylIoETppQyD75yefHDJWvKpVV+bsC//fD+yKvNzWRzQ6oC6o4
bBM+bAu9tEIyUnkYNWwHH5hRMKuLK76iBFheP5otF7TWFfw5aXXcMw4+9mmPad/Z
cTfpCYHVtvNHXcTQQn89pdAIM+hanomA2T8o+opGZiyceqAeUq1NxIH69BsD7ZfC
ZWCwZnR/XCL3GA6Rv/UWnInB34SBAubZA6+TWWusj2hZYtQ4KWOT4D+Pfb6XwpOb
SfWUjv9LkN8Mcw2ha97nwTh7w2+g3vmNMvBc3MpPYbOn6fOSbP2BHugNMAUIvvcE
t9oEMswy5VWHiU/3LCNK234pAoaufauxOMHIWW4DCJC+MY+Dyfy8aYjcF27w7AXi
apP/DF6jOFMN/vGeAxne
=kDRA
-----END PGP SIGNATURE-----

--=-AIpR4wk8oJJq12o2o4sM--

