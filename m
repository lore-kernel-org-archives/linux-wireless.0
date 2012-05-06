Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:29624 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929Ab2EFHy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 03:54:27 -0400
Date: Sun, 6 May 2012 09:54:33 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120506075433.GA1288@ritirata.org> (sfid-20120506_095500_887568_2F2A2062)
References: <CANUX_P0zRjSy9LOVzkWtboqAsvkD4O6EcEXLo11W1Sbb307OJQ@mail.gmail.com>
 <20120503200948.GC11326@ritirata.org>
 <CANUX_P0DL+_V8RO-CNXQx=oHF0T-opO=uw-ukYOjjVgo_OyfUw@mail.gmail.com>
 <20120504002136.GA4201@ritirata.org>
 <CANUX_P1Ji6H0zaA_kMHx2F1AD+czB=XtrDhjEvR8t1aCDpZhUQ@mail.gmail.com>
 <20120504063644.GA2912@ritirata.org>
 <CANUX_P0XhRQNVMQKtrw4j1UT9S=CMcjApCyNsdHHtLVME3jeEQ@mail.gmail.com>
 <20120504142006.GA2040@ritirata.org>
 <CANUX_P28EcqDVXQkSrGk2fetf=Evf2Yd_Fg9Czwb1jEPpdgTWg@mail.gmail.com>
 <CANUX_P0ygFyDjOo1Thygw_dEiHKPPiH4=GDKN4ncX3vwy0ujrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
In-Reply-To: <CANUX_P0ygFyDjOo1Thygw_dEiHKPPiH4=GDKN4ncX3vwy0ujrw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 06, 2012 at 08:49:52 +0300, Emmanuel Grumbach wrote:
> wait - I just noticed that this one introduced another issue...

ok, I'll drop this patch

>=20
> Emmanuel Grumbach
> egrumbach@gmail.com
>=20
>=20
> On Sat, May 5, 2012 at 9:49 PM, Emmanuel Grumbach <egrumbach@gmail.com> w=
rote:
> > Well,
> >
> > this is not the same warning as before.
> > Can you try the patch attached ?
> > I have submitted it internally.
> >
> > thanks
> >
> > Emmanuel Grumbach
> > egrumbach@gmail.com
> >
> >
> > On Fri, May 4, 2012 at 5:20 PM, Antonio Quartulli <ordex@autistici.org>=
 wrote:
> >> On Fri, May 04, 2012 at 09:58:30 +0300, Emmanuel Grumbach wrote:
> >>> This can't be with my patch, is it ?
> >>
> >> here is the log. Some pieces are missing at the beginning, didn't chec=
k why.
> >> However the WARNING comes up later, so it should be ok. Tell me if I c=
an do
> >> something else!
> >>
> >> Cheers,
> >>
> >>
> >> --
> >> Antonio Quartulli
> >>
> >> ..each of us alone is worth nothing..
> >> Ernesto "Che" Guevara

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPpi45AAoJEFMQTLzJFOZF3LQH/3lNzAC9ljLlNtQzc0T9/NVN
twwgEAoRer+lKQv/cAF0P2FGqLU8COX2pcc2SoJkC/6NVrBUyR1iznXSuvez1quC
B3n8IHakm2jQuAxw5gWXfvdtlfslDHcnwP6Zr2OA5/CnPIBp1byvA5t8QdacJ9+r
X3yw9Nejd7d9duHON23YanLWawCkXSd4iInWOYL8uIl0YPKXTxVxaniegWzSwTR1
KbkOE0IW8Wpvd0gBIzEDBVy7ueEvw7TN+1EyofQNRQjAzHzt3pNQFhZdu81K7/wd
PPkb3P4qJ3ZHUMqr/Hs6TRwNoSWr0n7biEowUoKn3NU4xBNo+gsGIQds/Uy7rl4=
=Moko
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
