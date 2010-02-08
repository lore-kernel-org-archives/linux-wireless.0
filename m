Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade.minaslivre.org ([72.232.254.139]:44421 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755734Ab0BHUbv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 15:31:51 -0500
Date: Mon, 8 Feb 2010 18:26:44 -0200
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Javier Cardona <javier@cozybit.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Andrey Yurovsky <yurovsky@gmail.com>
Subject: Re: [PATCH] nl80211: allow adding new station to devices in mesh
 mode
Message-ID: <20100208202643.GA1420@holoscopio.com>
References: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
 <20100205165726.GA1496@holoscopio.com>
 <c1545bb51002050947q707bb5ebud5ec7b4680f49ac5@mail.gmail.com>
 <1265446793.4041.2.camel@johannes.local>
 <c1545bb51002071151wb2cefa3mb03501e0d6b3fb4b@mail.gmail.com>
 <1265620089.3783.2.camel@johannes.berg>
 <445f43ac1002081125i61bb53dap5b9df374b3116ba9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
In-Reply-To: <445f43ac1002081125i61bb53dap5b9df374b3116ba9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 08, 2010 at 11:25:37AM -0800, Javier Cardona wrote:
> Thadeu, Johannes,
>=20
> On Mon, Feb 8, 2010 at 1:08 AM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > On Sun, 2010-02-07 at 11:51 -0800, Andrey Yurovsky wrote:
> >> On Sat, Feb 6, 2010 at 12:59 AM, Johannes Berg
> >> <johannes@sipsolutions.net> wrote:
> >> > I do wonder though, the commit (155cc9e4b1d60161ee53) I referenced w=
as
> >> > yours, and now you're asking the same question as I am -- "why even
> >> > allow adding stations?"
> >>
> >> It was supported for automated testing and experimentation (you could
> >> then force certain topologies). =C2=A0I can't think of any other reaso=
n to
> >> do it. =C2=A0I suppose that the same thing goes for mpaths and the mesh
> >> portal tables.
> >
> > So would you prefer to fix it (however we would do that, I don't think
> > that the patch here is correct since it leaves the station struct with
> > no usable rates afaict), or just disallow it?
>=20
> After reviewing our mesh test suite, I would vote for disallowing mesh
> point addition via iw.  We currently force topologies by 1. turning
> auto peering off, 2. waiting for neighbors to be discovered and 3.
> controlling peering with 'iw ... station set <MAC address>
> plink_action <open|block>'
>=20
> Thadeu, would this approach work for you?
>=20

That's OK for me. Do you want a patch?

> Javier
>=20
>=20
>=20
> --=20
> Javier Cardona
> cozybit Inc.
> http://www.cozybit.com

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktwc4MACgkQyTpryRcqtS1rBACfcN5PnDShBUAz1m2W5x0T5GIH
PCAAnisUqToENb3ITivqwNQaxtuY6/W6
=wuGo
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
