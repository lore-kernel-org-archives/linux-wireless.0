Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:43799 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab2EFI4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 04:56:44 -0400
Date: Sun, 6 May 2012 10:56:38 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120506085637.GB1288@ritirata.org> (sfid-20120506_105648_795110_22805B0B)
References: <CANUX_P0DL+_V8RO-CNXQx=oHF0T-opO=uw-ukYOjjVgo_OyfUw@mail.gmail.com>
 <20120504002136.GA4201@ritirata.org>
 <CANUX_P1Ji6H0zaA_kMHx2F1AD+czB=XtrDhjEvR8t1aCDpZhUQ@mail.gmail.com>
 <20120504063644.GA2912@ritirata.org>
 <CANUX_P0XhRQNVMQKtrw4j1UT9S=CMcjApCyNsdHHtLVME3jeEQ@mail.gmail.com>
 <20120504142006.GA2040@ritirata.org>
 <CANUX_P28EcqDVXQkSrGk2fetf=Evf2Yd_Fg9Czwb1jEPpdgTWg@mail.gmail.com>
 <CANUX_P0ygFyDjOo1Thygw_dEiHKPPiH4=GDKN4ncX3vwy0ujrw@mail.gmail.com>
 <20120506075433.GA1288@ritirata.org>
 <CANUX_P09Bx=kZ+OoHLTdZgJy_rJOQvutg3yVrBLHzPzV=KMQsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
In-Reply-To: <CANUX_P09Bx=kZ+OoHLTdZgJy_rJOQvutg3yVrBLHzPzV=KMQsg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 06, 2012 at 11:26:32 +0300, Emmanuel Grumbach wrote:
> All right,
>=20
> Can you please test the patch I sent to you (which was good but not enoug=
h)
> And add this one too ?

Ok, I'll also leave the print.patch.
I'll report the result.

Thank you

>=20
> Thanks
>=20
> Emmanuel Grumbach
> egrumbach@gmail.com
>=20
>=20
> On Sun, May 6, 2012 at 10:54 AM, Antonio Quartulli <ordex@autistici.org> =
wrote:
> > On Sun, May 06, 2012 at 08:49:52 +0300, Emmanuel Grumbach wrote:
> >> wait - I just noticed that this one introduced another issue...
> >
> > ok, I'll drop this patch
> >
> >>
> >> Emmanuel Grumbach
> >> egrumbach@gmail.com
> >>
> >>
> >> On Sat, May 5, 2012 at 9:49 PM, Emmanuel Grumbach <egrumbach@gmail.com=
> wrote:
> >> > Well,
> >> >
> >> > this is not the same warning as before.
> >> > Can you try the patch attached ?
> >> > I have submitted it internally.
> >> >
> >> > thanks
> >> >
> >> > Emmanuel Grumbach
> >> > egrumbach@gmail.com
> >> >
> >> >
> >> > On Fri, May 4, 2012 at 5:20 PM, Antonio Quartulli <ordex@autistici.o=
rg> wrote:
> >> >> On Fri, May 04, 2012 at 09:58:30 +0300, Emmanuel Grumbach wrote:
> >> >>> This can't be with my patch, is it ?
> >> >>
> >> >> here is the log. Some pieces are missing at the beginning, didn't c=
heck why.
> >> >> However the WARNING comes up later, so it should be ok. Tell me if =
I can do
> >> >> something else!
> >> >>
> >> >> Cheers,
> >> >>
> >> >>
> >> >> --
> >> >> Antonio Quartulli
> >> >>
> >> >> ..each of us alone is worth nothing..
> >> >> Ernesto "Che" Guevara
> >
> > --
> > Antonio Quartulli
> >
> > ..each of us alone is worth nothing..
> > Ernesto "Che" Guevara



--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPpjzFAAoJEFMQTLzJFOZFgIMIAL9NDDin7bBfzQ0nMjuYq9Tu
c8nFZAq8aiL8vFro8D+JC9KeqAY7V9rgw3AaZoPeK+R5FL4Y382v9fa3IYuqbuAn
zNAaoNAtIzoS4LnSADYJqjmzRhxisn8ylcifRia7yb8fxvP4sZNT8XiRb5uChm1w
Yab9ax3Haan3O1gjMxbb7VN8FAQQuJ59eVCSrG6dPWGNHfA/qIZrvE1Y77Nm1DtP
nUhnDVZs4JCAzlfLvpExVDHK5FuFZRjDZ3EcVgIrjbhVzs2rjgGO54vQ37R4ueXn
m5FmxgKrT+VOdVU0BPfv3jh4z08YaYwnO7XHRxGND+iB9nSEekUGFa2JMsQTtiU=
=MdwJ
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--
