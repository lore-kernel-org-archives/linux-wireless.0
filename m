Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:34430 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab2EDH1T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 03:27:19 -0400
Date: Fri, 4 May 2012 09:28:05 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120504072804.GC2912@ritirata.org> (sfid-20120504_092723_506392_3253C9D4)
References: <20120502162100.GA2528@ritirata.org>
 <20120503065351.GB2307@ritirata.org>
 <CANUX_P03yeuU7gpXbdPVeUBnco4Cz8v78e00x+SgYbhD5K8B5w@mail.gmail.com>
 <CANUX_P0zRjSy9LOVzkWtboqAsvkD4O6EcEXLo11W1Sbb307OJQ@mail.gmail.com>
 <20120503200948.GC11326@ritirata.org>
 <CANUX_P0DL+_V8RO-CNXQx=oHF0T-opO=uw-ukYOjjVgo_OyfUw@mail.gmail.com>
 <20120504002136.GA4201@ritirata.org>
 <CANUX_P1Ji6H0zaA_kMHx2F1AD+czB=XtrDhjEvR8t1aCDpZhUQ@mail.gmail.com>
 <20120504063644.GA2912@ritirata.org>
 <CANUX_P0XhRQNVMQKtrw4j1UT9S=CMcjApCyNsdHHtLVME3jeEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pQhZXvAqiZgbeUkD"
In-Reply-To: <CANUX_P0XhRQNVMQKtrw4j1UT9S=CMcjApCyNsdHHtLVME3jeEQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--pQhZXvAqiZgbeUkD
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 04, 2012 at 09:58:30AM +0300, Emmanuel Grumbach wrote:
> This can't be with my patch, is it ?

it should. I will give it another try, maybe yesterday night I messed up
something. Sorry.


Cheers,

>=20
> Emmanuel Grumbach
> egrumbach@gmail.com
>=20
>=20
> On Fri, May 4, 2012 at 9:36 AM, Antonio Quartulli <ordex@autistici.org> w=
rote:
> > ops... my fault
> >
> > On Fri, May 04, 2012 at 08:11:54 +0300, Emmanuel Grumbach wrote:
> >> nothing attaced
> >>
> >> Emmanuel Grumbach
> >> egrumbach@gmail.com
> >>
> >>
> >> On Fri, May 4, 2012 at 3:21 AM, Antonio Quartulli <ordex@autistici.org=
> wrote:
> >> > mhmmm I attached dmesg again. Do you really need messages?
> >> >
> >> > Cheers,
> >> >
> >> >
> >> > On Thu, May 03, 2012 at 11:17:14 +0300, Emmanuel Grumbach wrote:
> >> >> ooops
> >> >>
> >> >>
> >> >> here it is
> >> >>
> >> >>
> >> >>
> >> >> Emmanuel Grumbach
> >> >> egrumbach@gmail.com
> >> >>
> >> >>
> >> >> On Thu, May 3, 2012 at 11:09 PM, Antonio Quartulli <ordex@autistici=
=2Eorg> wrote:
> >> >> > On Thu, May 03, 2012 at 10:55:12PM +0300, Emmanuel Grumbach wrote:
> >> >> >> Hi
> >> >> >>
> >> >> >> can you please apply the patch attached against wireless-testing=
 ?
> >> >> >
> >> >> > which patch? If you refer to the patch attached to the bugreport,=
 it doesn't
> >> >> > apply on wireless-testing.
> >> >> >
> >> >> >
> >> >> > Cheers,
> >> >> >
> >> >> >>
> >> >> >> You will have quite a lot of prints, so you will probably need t=
o send
> >> >> >> /var/log/syslog or messages
> >> >> >>
> >> >> >>
> >> >> >> Thanks
> >> >> >>
> >> >> >> Emmanuel Grumbach
> >> >> >> egrumbach@gmail.com
> >> >> >>
> >> >> >>
> >> >> >> On Thu, May 3, 2012 at 10:04 PM, Emmanuel Grumbach <egrumbach@gm=
ail.com> wrote:
> >> >> >> > Please enable CONFIG_FRAME_POINTERS
> >> >> >> > Emmanuel Grumbach
> >> >> >> > egrumbach@gmail.com
> >> >> >> >
> >> >> >> >
> >> >> >> > On Thu, May 3, 2012 at 9:53 AM, Antonio Quartulli <ordex@autis=
tici.org> wrote:
> >> >> >> >> On Wed, May 02, 2012 at 06:21:02PM +0200, Antonio Quartulli w=
rote:
> >> >> >> >>> On Wed, May 02, 2012 at 11:39:14AM -0400, John W. Linville w=
rote:
> >> >> >> >>> > On Wed, May 02, 2012 at 10:08:46AM +0300, Emmanuel Grumbac=
h wrote:
> >> >> >> >>> > > On Wed, May 2, 2012 at 12:19 AM, Venkataraman, Meenakshi
> >> >> >> >>> > > <meenakshi.venkataraman@intel.com> wrote:
> >> >> >> >>> > > > Hi Antonio,
> >> >> >> >>> > > >
> >> >> >> >>> > > >>> it seems so. It happens at least once at boot time.
> >> >> >> >>> > > >>> I will try wireless-testing and see what happens. Th=
en I will apply your patch.
> >> >> >> >>> > > >>
> >> >> >> >>> > > >>The problem is there either with wireless-testing and =
with
> >> >> >> >>> > > >>wireless-testing+your_patch.
> >> >> >> >>> > > >>
> >> >> >> >>> > > >>If it can somehow help, I also got several stack trace=
 regarding intel_iova
> >> >> >> >>> > > >>functions. But then the I got kernel panic and I was n=
ot able to copy the
> >> >> >> >>> > > >>messages.
> >> >> >> >>> > > >
> >> >> >> >>> > > > [MV] Depending on how you set it up, perhaps the stack=
 trace was saved in one of the syslog files in /var/log/...
> >> >> >> >>> > > >
> >> >> >> >>> > > > Thanks!
> >> >> >> >>> > > > Meenakshi
> >> >> >> >>> > > >
> >> >> >> >>> > >
> >> >> >> >>> > > Can you please re-run with debug=3D1 and send the whole =
log ?
> >> >> >> >>> > > This will give a better indication on when the issue occ=
urs.
> >> >> >> >>> >
> >> >> >> >>> > Does this help?
> >> >> >> >>> >
> >> >> >> >>> > =C2=A0 =C2=A0 https://bugzilla.redhat.com/show_bug.cgi?id=
=3D815998#c18
> >> >> >> >>>
> >> >> >> >>> I applied patch in comment 17 on linux-3.3.4. IT didn't help=
 but this time I got
> >> >> >> >>> the WARNING even with debug=3D1. Log is attached.
> >> >> >> >>>
> >> >> >> >>
> >> >> >> >>
> >> >> >> >> Is there any particular kernel debugging option I could enabl=
e to make the log
> >> >> >> >> more verbose?
> >> >> >> >>
> >> >> >> >>
> >> >> >> >> Cheers,
> >> >> >> >>
> >> >> >> >>
> >> >> >> >>
> >> >> >> >> --
> >> >> >> >> Antonio Quartulli
> >> >> >> >>
> >> >> >> >> ..each of us alone is worth nothing..
> >> >> >> >> Ernesto "Che" Guevara
> >> >> >
> >> >> > --
> >> >> > Antonio Quartulli
> >> >> >
> >> >> > ..each of us alone is worth nothing..
> >> >> > Ernesto "Che" Guevara
> >> >
> >> >
> >> >
> >> > --
> >> > Antonio Quartulli
> >> >
> >> > ..each of us alone is worth nothing..
> >> > Ernesto "Che" Guevara
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-wirele=
ss" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.html
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

--pQhZXvAqiZgbeUkD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPo4UEAAoJEFMQTLzJFOZF4IEH/jiKVewY2lV6kE5XKsVNZk70
g/zi9QVpis0PcavGOQVOj7ZsUKljbZ3IaDsUmXKQH1wwcA5s0XGgSl/6OJg/Lff0
rrZ7aRNksK7Bbl4Jf/qo0d7jjg4tOIex49g+5tlQb5OeQC7ZbaL50i2tsWMrZTSn
y/hdGyPAI85c16mBN3LPkPdl1FshQOkVnwyy/IKRVqN3qwmZldgSTr34EQVebj12
mTP7ssYOtTj75fOaQ16LJf3/5UN6cyXL4SmsCokfw4ZzulRqdzbh4ytVv0lNyC73
rsZBUllp4TNtq7R8TsGZPLijrWDiZYi5L1R/7mdeCEnuu0L1tU89VDemftyk7SE=
=RyK0
-----END PGP SIGNATURE-----

--pQhZXvAqiZgbeUkD--
