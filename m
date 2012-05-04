Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:63313 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756150Ab2EDAUy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 20:20:54 -0400
Date: Fri, 4 May 2012 02:21:36 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120504002136.GA4201@ritirata.org> (sfid-20120504_022058_485515_38F648C0)
References: <20120501205616.GA2563@ritirata.org>
 <4595B4D22AB93C4FABBA84AAD5AA37FD14438A@ORSMSX103.amr.corp.intel.com>
 <CANUX_P0UYx_-PS8BUGO10Cwrm6LuhMu4Vyhad4RL-Jn6YqE-Pg@mail.gmail.com>
 <20120502153914.GA9285@tuxdriver.com>
 <20120502162100.GA2528@ritirata.org>
 <20120503065351.GB2307@ritirata.org>
 <CANUX_P03yeuU7gpXbdPVeUBnco4Cz8v78e00x+SgYbhD5K8B5w@mail.gmail.com>
 <CANUX_P0zRjSy9LOVzkWtboqAsvkD4O6EcEXLo11W1Sbb307OJQ@mail.gmail.com>
 <20120503200948.GC11326@ritirata.org>
 <CANUX_P0DL+_V8RO-CNXQx=oHF0T-opO=uw-ukYOjjVgo_OyfUw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
In-Reply-To: <CANUX_P0DL+_V8RO-CNXQx=oHF0T-opO=uw-ukYOjjVgo_OyfUw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

mhmmm I attached dmesg again. Do you really need messages?

Cheers,


On Thu, May 03, 2012 at 11:17:14 +0300, Emmanuel Grumbach wrote:
> ooops
>=20
>=20
> here it is
>=20
>=20
>=20
> Emmanuel Grumbach
> egrumbach@gmail.com
>=20
>=20
> On Thu, May 3, 2012 at 11:09 PM, Antonio Quartulli <ordex@autistici.org> =
wrote:
> > On Thu, May 03, 2012 at 10:55:12PM +0300, Emmanuel Grumbach wrote:
> >> Hi
> >>
> >> can you please apply the patch attached against wireless-testing ?
> >
> > which patch? If you refer to the patch attached to the bugreport, it do=
esn't
> > apply on wireless-testing.
> >
> >
> > Cheers,
> >
> >>
> >> You will have quite a lot of prints, so you will probably need to send
> >> /var/log/syslog or messages
> >>
> >>
> >> Thanks
> >>
> >> Emmanuel Grumbach
> >> egrumbach@gmail.com
> >>
> >>
> >> On Thu, May 3, 2012 at 10:04 PM, Emmanuel Grumbach <egrumbach@gmail.co=
m> wrote:
> >> > Please enable CONFIG_FRAME_POINTERS
> >> > Emmanuel Grumbach
> >> > egrumbach@gmail.com
> >> >
> >> >
> >> > On Thu, May 3, 2012 at 9:53 AM, Antonio Quartulli <ordex@autistici.o=
rg> wrote:
> >> >> On Wed, May 02, 2012 at 06:21:02PM +0200, Antonio Quartulli wrote:
> >> >>> On Wed, May 02, 2012 at 11:39:14AM -0400, John W. Linville wrote:
> >> >>> > On Wed, May 02, 2012 at 10:08:46AM +0300, Emmanuel Grumbach wrot=
e:
> >> >>> > > On Wed, May 2, 2012 at 12:19 AM, Venkataraman, Meenakshi
> >> >>> > > <meenakshi.venkataraman@intel.com> wrote:
> >> >>> > > > Hi Antonio,
> >> >>> > > >
> >> >>> > > >>> it seems so. It happens at least once at boot time.
> >> >>> > > >>> I will try wireless-testing and see what happens. Then I w=
ill apply your patch.
> >> >>> > > >>
> >> >>> > > >>The problem is there either with wireless-testing and with
> >> >>> > > >>wireless-testing+your_patch.
> >> >>> > > >>
> >> >>> > > >>If it can somehow help, I also got several stack trace regar=
ding intel_iova
> >> >>> > > >>functions. But then the I got kernel panic and I was not abl=
e to copy the
> >> >>> > > >>messages.
> >> >>> > > >
> >> >>> > > > [MV] Depending on how you set it up, perhaps the stack trace=
 was saved in one of the syslog files in /var/log/...
> >> >>> > > >
> >> >>> > > > Thanks!
> >> >>> > > > Meenakshi
> >> >>> > > >
> >> >>> > >
> >> >>> > > Can you please re-run with debug=3D1 and send the whole log ?
> >> >>> > > This will give a better indication on when the issue occurs.
> >> >>> >
> >> >>> > Does this help?
> >> >>> >
> >> >>> > =C2=A0 =C2=A0 https://bugzilla.redhat.com/show_bug.cgi?id=3D8159=
98#c18
> >> >>>
> >> >>> I applied patch in comment 17 on linux-3.3.4. IT didn't help but t=
his time I got
> >> >>> the WARNING even with debug=3D1. Log is attached.
> >> >>>
> >> >>
> >> >>
> >> >> Is there any particular kernel debugging option I could enable to m=
ake the log
> >> >> more verbose?
> >> >>
> >> >>
> >> >> Cheers,
> >> >>
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

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPoyEQAAoJEFMQTLzJFOZF6a4H/RnOF9QaqhjEclpvZt+rVIWh
TszR/aBh1MZSr76drfXwiquJ5UTMP8nfvm2aPTz91PLiMRAAB2Cum6pT74pgdgL4
3UnecSA/vNvxksd7Bw2uZ4m1mQXMCQIteKzJ1YjMlR3j6wGTvWGqdd8E9cjjcDlr
mHOKq7ajX2rbmPf26AcD6ovoIyblrk2j6tpxg0HzsREHYIjVaPinv799vv5XkMSV
cB5i3bihGJO+BRVa4Dvm55dpOb4kEEA47uLIk21r74kXJuC7QGCs0vrONkfVjBsT
CoCdQPHRb4jFp5H5IM5+0vkD2QzQHM26GNsV/Uvwu5YiNMeKCu0X+dFdfsrOx3I=
=yYPF
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
