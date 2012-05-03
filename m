Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:33572 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2ECUJA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 16:09:00 -0400
Date: Thu, 3 May 2012 22:09:49 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120503200948.GC11326@ritirata.org> (sfid-20120503_220904_658174_6D205B57)
References: <CANUX_P1Nx4jYbRwehi+qW-2RVy=ntb_cCzBzpYXkJysuPvrCPA@mail.gmail.com>
 <20120501183415.GG4316@ritirata.org>
 <20120501205616.GA2563@ritirata.org>
 <4595B4D22AB93C4FABBA84AAD5AA37FD14438A@ORSMSX103.amr.corp.intel.com>
 <CANUX_P0UYx_-PS8BUGO10Cwrm6LuhMu4Vyhad4RL-Jn6YqE-Pg@mail.gmail.com>
 <20120502153914.GA9285@tuxdriver.com>
 <20120502162100.GA2528@ritirata.org>
 <20120503065351.GB2307@ritirata.org>
 <CANUX_P03yeuU7gpXbdPVeUBnco4Cz8v78e00x+SgYbhD5K8B5w@mail.gmail.com>
 <CANUX_P0zRjSy9LOVzkWtboqAsvkD4O6EcEXLo11W1Sbb307OJQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="69pVuxX8awAiJ7fD"
In-Reply-To: <CANUX_P0zRjSy9LOVzkWtboqAsvkD4O6EcEXLo11W1Sbb307OJQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--69pVuxX8awAiJ7fD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 03, 2012 at 10:55:12PM +0300, Emmanuel Grumbach wrote:
> Hi
>=20
> can you please apply the patch attached against wireless-testing ?

which patch? If you refer to the patch attached to the bugreport, it doesn't
apply on wireless-testing.


Cheers,

>=20
> You will have quite a lot of prints, so you will probably need to send
> /var/log/syslog or messages
>=20
>=20
> Thanks
>=20
> Emmanuel Grumbach
> egrumbach@gmail.com
>=20
>=20
> On Thu, May 3, 2012 at 10:04 PM, Emmanuel Grumbach <egrumbach@gmail.com> =
wrote:
> > Please enable CONFIG_FRAME_POINTERS
> > Emmanuel Grumbach
> > egrumbach@gmail.com
> >
> >
> > On Thu, May 3, 2012 at 9:53 AM, Antonio Quartulli <ordex@autistici.org>=
 wrote:
> >> On Wed, May 02, 2012 at 06:21:02PM +0200, Antonio Quartulli wrote:
> >>> On Wed, May 02, 2012 at 11:39:14AM -0400, John W. Linville wrote:
> >>> > On Wed, May 02, 2012 at 10:08:46AM +0300, Emmanuel Grumbach wrote:
> >>> > > On Wed, May 2, 2012 at 12:19 AM, Venkataraman, Meenakshi
> >>> > > <meenakshi.venkataraman@intel.com> wrote:
> >>> > > > Hi Antonio,
> >>> > > >
> >>> > > >>> it seems so. It happens at least once at boot time.
> >>> > > >>> I will try wireless-testing and see what happens. Then I will=
 apply your patch.
> >>> > > >>
> >>> > > >>The problem is there either with wireless-testing and with
> >>> > > >>wireless-testing+your_patch.
> >>> > > >>
> >>> > > >>If it can somehow help, I also got several stack trace regardin=
g intel_iova
> >>> > > >>functions. But then the I got kernel panic and I was not able t=
o copy the
> >>> > > >>messages.
> >>> > > >
> >>> > > > [MV] Depending on how you set it up, perhaps the stack trace wa=
s saved in one of the syslog files in /var/log/...
> >>> > > >
> >>> > > > Thanks!
> >>> > > > Meenakshi
> >>> > > >
> >>> > >
> >>> > > Can you please re-run with debug=3D1 and send the whole log ?
> >>> > > This will give a better indication on when the issue occurs.
> >>> >
> >>> > Does this help?
> >>> >
> >>> > =C2=A0 =C2=A0 https://bugzilla.redhat.com/show_bug.cgi?id=3D815998#=
c18
> >>>
> >>> I applied patch in comment 17 on linux-3.3.4. IT didn't help but this=
 time I got
> >>> the WARNING even with debug=3D1. Log is attached.
> >>>
> >>
> >>
> >> Is there any particular kernel debugging option I could enable to make=
 the log
> >> more verbose?
> >>
> >>
> >> Cheers,
> >>
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

--69pVuxX8awAiJ7fD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPouYMAAoJEFMQTLzJFOZFyVcH/jFtXAAJuTdZDR5Bo5rQiN+y
XdrHdoemWG0ifI7485Mvd+0W/y4tXhXI5MYGmg3kXp/yy8l16ona81q1bNTKSXnR
YyZj0EuSpDohxBx8TqfCP4w46j5EcYyJaOM+WAPRLEFOgLA8pdhNjCevINk+UYiK
MN6kWRtzqZYIHebOFQn6d3gUDy8zv6+8CLfNJ6VgDt6TdYE3Hy4fM1aRnC7VHFNe
OMEiTpLzdRH7x34GGtNsjAFh5RwNM2KMX9poZTz8eYTUPy678JjCWUXpEXZW6V6r
uaVUeVMw8+bIDFzZYusjOTR8xvBXuFQioWxaftrbZa/0qAYQOfCF+KCzP8TouDE=
=lSzc
-----END PGP SIGNATURE-----

--69pVuxX8awAiJ7fD--
