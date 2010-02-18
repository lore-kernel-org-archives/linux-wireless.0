Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57472 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0BRILi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 03:11:38 -0500
Subject: Re: [PATCH v2] nl80211: add power save commands
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e891002171432u16bd9d5eo71d3856e52993065@mail.gmail.com>
References: <20100217155810.4534.69338.stgit@tikku>
	 <43e72e891002171432u16bd9d5eo71d3856e52993065@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uQxARR6SKXmQLcGK2JQW"
Date: Thu, 18 Feb 2010 09:11:35 +0100
Message-ID: <1266480695.6539.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uQxARR6SKXmQLcGK2JQW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-02-17 at 14:32 -0800, Luis R. Rodriguez wrote:
> On Wed, Feb 17, 2010 at 7:58 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> > +       {
> > +               .cmd =3D NL80211_CMD_SET_POWER_SAVE,
> > +               .doit =3D nl80211_set_power_save,
> > +               .policy =3D nl80211_policy,
> > +               .flags =3D GENL_ADMIN_PERM,
> > +       },
> > +       {
> > +               .cmd =3D NL80211_CMD_GET_POWER_SAVE,
> > +               .doit =3D nl80211_get_power_save,
> > +               .policy =3D nl80211_policy,
> > +               /* can be retrieved by unprivileged users */
> > +       },
>=20
> Any reason this can't be stuffed into the set/get wiphy command?

per netdev.

johannes

--=-uQxARR6SKXmQLcGK2JQW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLfPYzAAoJEODzc/N7+QmaRLMP/1uHU7k4YsIUou+snLYkZhEp
G2Jx/gIS2iMyUte8mi0hZEtsEts1k2gB5/KkHw7jqzsd2mG74SCwkFUom8tsNF7Z
CUcMKHnfgTdprWylpdIW/snHPs/gGtk//IAPVrtK5qxMROW9STlNygPKzt/l7g0d
88jZyebjtzqX6kNY5EQ35L2itTP1qfMbQ37Yy1TaAp5AvZ0YAv/PmxDUTufXlce6
AuxfDzevPtFV9S60TGipIFqGHvZoEWZ9iOhykKboZAYzJN5RJbK5G0fqGooktBWL
RvrXDpt/Xeuq8oJQEklHC713GEHIl9gbaQei8VSW/oCHyf0jDsQ5cBlg2R9ztyt3
thE4fXz4t8GdXnQW63YoLVqS0CIbfFGlckdR2svQHju6F5YKPmDlpVVrqScXu2wd
vn+Jc6Y+XPkejalr4h2VwAMMBEXdgyb2DBOJT4kIpBTnD8FZaECQvkapl/hesEyo
lLubcFzbYaydgmQCdbCz/2ht4rS4xOlCRZzERtOWFoifBUAgXv4/akXc/4F+OIla
jaB5zogzwAK4Aj50Os2xaM+t2D2FrdKqevXaXaD/mNnY0CjdGlry5ZSUoJgH4yUX
NwLvZsBuWvchma6JSn+lmUzeq9z4BDvjmv5Jhi7e0B4lrXUBRk/yqwk3WEikrcXK
xZfxaiVSNow9XnvcTopa
=z9el
-----END PGP SIGNATURE-----

--=-uQxARR6SKXmQLcGK2JQW--

