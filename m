Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:54237 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057Ab0ETGso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 02:48:44 -0400
Date: Thu, 20 May 2010 08:48:09 +0200
From: Kurt Garloff <kurt@garloff.de>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Michael Green <Michael.Green@atheros.com>,
	David Quan <David.Quan@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: WLAN Regulatory Domain Germany
Message-ID: <20100520064809.GC32757@tpkurt2.garloff.de>
References: <20100519172944.GB32757@tpkurt2.garloff.de> <AANLkTilXo13Pn6n0n3mJONuUj50BImufADLveYAjX3YR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
In-Reply-To: <AANLkTilXo13Pn6n0n3mJONuUj50BImufADLveYAjX3YR@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Luis,

On Wed, May 19, 2010 at 03:20:24PM -0700, Luis R. Rodriguez wrote:
> On Wed, May 19, 2010 at 10:29 AM, Kurt Garloff <kurt@garloff.de> wrote:
> > country DE:
> > =A0 =A0 =A0 =A0# entries 279004 and 280006
> > =A0 =A0 =A0 =A0(2400 - 2483.5 @ 40), (N/A, 100 mW)
> > =A0 =A0 =A0 =A0# entry 303005
> > =A0 =A0 =A0 =A0(5150 - 5250 @ 40), (N/A, 100 mW), NO-OUTDOOR
> > =A0 =A0 =A0 =A0# entries 304002 and 305002
> > =A0 =A0 =A0 =A0(5250 - 5350 @ 40), (N/A, 100 mW), NO-OUTDOOR, DFS
> > =A0 =A0 =A0 =A0# entries 308002, 309001 and 310003
> > =A0 =A0 =A0 =A0(5470 - 5725 @ 40), (N/A, 500 mW), DFS
> >
> > 8<---------------------------------------------------------------------=
---
> >
> > (Or in db, as displayed by iw reg get)
> > country DE:
> > =A0 =A0 =A0 =A0(2400 - 2483 @ 40), (N/A, 20)
> > =A0 =A0 =A0 =A0(5150 - 5250 @ 40), (N/A, 20), NO-OUTDOOR
> > =A0 =A0 =A0 =A0(5250 - 5350 @ 40), (N/A, 20), NO-OUTDOOR, DFS
> > =A0 =A0 =A0 =A0(5470 - 5725 @ 40), (N/A, 27), DFS
> >
> > PS: I'm not subscribed, please copy responses to me.
>=20
> Thanks for the e-mail and your review, I've passed this to our
> regulatory gods and it is now being picked at and reviewed.

Thanks.

Two more remarks:
- Having looked at the framework how we handle this regulatory stuff
  in Linux these days, it looks very reasonable to me -- good job!
- The frequencies above (from Frequenznutzungsplan =3D freq. util. plan)=20
  are really the limits of the frequency ranges to be used, not channel
  center freqs. So if we'd have to put possible center freqs in there=20
  and assume 22MHz (+-11MHz) for the 2.4 GHz range, we'd need to put=20
  2411 -- 2472.5 in the DB. Likewise, assuming 20MHz (+-10MHz for the
  5GHz range, we'd specify 5160 -- 5240, 5240 -- 5340 and 5480 -- 5715),
  of, for 40MHz(+-20MHz) channels, it would be 5170 -- 5230, 5230 --
  5330 and 5490 -- 5705. Such values are displayed with iw reg get=20
  for our neighbors NL, FR, ... which gave me the idea that we might
  not have the real boundaries in the db, but center freqs.
  That said, I'd think real boundaries make more sense, as channel
  widths may evolve over time ...

Thanks,
--=20
Kurt Garloff, VP OPS Partner Engineering -- Novell Inc.

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iD8DBQFL9NspxmLh6hyYd04RAuF1AKC3MVVKx3xI2RXpYqIAqWTwQkUS3wCgjdcL
5WvyOTtLAgytZsb88zCa4Co=
=Sg76
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--
