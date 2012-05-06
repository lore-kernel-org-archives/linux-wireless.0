Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:46527 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369Ab2EFI7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 May 2012 04:59:07 -0400
Date: Sun, 6 May 2012 10:59:03 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120506085902.GC1288@ritirata.org> (sfid-20120506_105910_493222_EB62CABE)
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
	protocol="application/pgp-signature"; boundary="sHrvAb52M6C8blB9"
In-Reply-To: <CANUX_P09Bx=kZ+OoHLTdZgJy_rJOQvutg3yVrBLHzPzV=KMQsg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--sHrvAb52M6C8blB9
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 06, 2012 at 11:26:32 +0300, Emmanuel Grumbach wrote:
> All right,
>=20
> Can you please test the patch I sent to you (which was good but not enoug=
h)
> And add this one too ?

What branch are these patches based on?
I'm applying them onto wireless-testing, but I always messages like:

patching file drivers/net/wireless/iwlwifi/iwl-debugfs.c
Hunk #1 succeeded at 2211 (offset 1 line).

The patches apply anyway, but just to be sure I'm testing the correct branch


Cheers,

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

--sHrvAb52M6C8blB9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPpj1WAAoJEFMQTLzJFOZFZSwH/3z/7b3BySsxeXnixVKYvW/z
FBg0Un9g6ApcuLXKtqwYqvm/PBpEtXrkGoH+LypdFH+/f7D4rrHrYebVCJsggie/
EEDeha2vcfCVZXY0c7x46L6zBUNqOhzuJKRxDOC/MXblag0eQXg+ydJ2Gio+K8lo
vselec/vGnmDtYeeZBe5eWFt89429sfHxaq8yrfI66QGtast4llXYJ1/7iH4JX9H
6DA6dJKMQ4tpoQ6Xpyar9OZmWA1uJ3oHs6nF3Xgz1ptYO9z3wfcDRLJtI6stRz6F
yL5SaR5Wjtj7YPdfUHGgrCFVMpX0NIpEdpGAvT/3ThKuW02Rvle8CcjKrsLlNSk=
=64L6
-----END PGP SIGNATURE-----

--sHrvAb52M6C8blB9--
