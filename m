Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:28417 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab2EAUzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 16:55:24 -0400
Date: Tue, 1 May 2012 22:56:17 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120501205616.GA2563@ritirata.org> (sfid-20120501_225530_529748_8B8DB7CC)
References: <20120422182928.GA2854@ritirata.org>
 <20120430145803.GE2630@ritirata.org>
 <20120430170337.GA2560@tuxdriver.com>
 <4595B4D22AB93C4FABBA84AAD5AA37FD143115@ORSMSX103.amr.corp.intel.com>
 <CANUX_P1Nx4jYbRwehi+qW-2RVy=ntb_cCzBzpYXkJysuPvrCPA@mail.gmail.com>
 <20120501183415.GG4316@ritirata.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
In-Reply-To: <20120501183415.GG4316@ritirata.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 01, 2012 at 08:34:15PM +0200, Antonio Quartulli wrote:
> On Tue, May 01, 2012 at 08:13:46PM +0300, Emmanuel Grumbach wrote:
> > Hi,
> >=20
> > I am not sure the patch will help because the race is _very_ unlikely.
> > But I would be glad to know if you can reproduce on latest
> > compat-wireless.
> > How reproducible is that on 3.3.3 ? Is that 100% ?
>=20
> it seems so. It happens at least once at boot time.
> I will try wireless-testing and see what happens. Then I will apply your =
patch.

The problem is there either with wireless-testing and with
wireless-testing+your_patch.

If it can somehow help, I also got several stack trace regarding intel_iova
functions. But then the I got kernel panic and I was not able to copy the
messages.



Thanks

> >=20
> > I guess my machine doesn't have IOMMU, but honestly, I am not sure I
> > know how to check.
> >=20
> > On Tue, May 1, 2012 at 19:52, Venkataraman, Meenakshi
> > <meenakshi.venkataraman@intel.com> wrote:
> > >
> > > Hi John, Antonio,
> > >
> > > Emmanuel found a race condition in rx buffer allocation/deallocation,=
 and
> > > attached is a patch that fixes it.
> > >
> > > >> > since linux-3.0 (I don't remember if it was the case even before=
),
> > > >> > I'm getting this output in dmesg:
> > > >> >
> > > >> > [ =C2=A0 53.662990] ------------[ cut here ]------------
> > > >> > [ =C2=A0 53.663016] WARNING: at drivers/iommu/intel-iommu.c:2911
> > > >> > intel_unmap_page+0x14b/0x180()
> > > >> > [ =C2=A0 53.663047] Hardware name: Latitude E5420
> > > >> > [ =C2=A0 53.663066] Driver unmaps unmatched page at PFN ffd1a000
> > > >>
> > > >>
> > > >> I see that I always get the same addr passed to the unmap function:
> > > >>
> > > >> [ =C2=A0 23.950535] Driver unmaps unmatched page at PFN ffd1a000
> > > >>
> > > >> is it a coincidence?
> > > >> I'm running linux-3.3.3 right now. I can try wireless-testing if it
> > > >> would help.
> > >
> > > [MV] Antonio -- can you try out the patch attached and let us know if=
 you
> > > continue to see the problem?
> > >
> > > >Just for the record, we are seeing a similar problem on RHEL 6.3 (wh=
ich
> > > > has an
> > > >iwlwifi driver derived from linux-3.2).
> > > >
> > > > =C2=A0 =C2=A0 =C2=A0 https://bugzilla.redhat.com/show_bug.cgi?id=3D=
815998
> > >
> > > [MV] John -- I'll update the redhat bugzilla as well.
> > >
> > > Thanks
> > > Meenakshi
>=20
> --=20
> Antonio Quartulli
>=20
> ..each of us alone is worth nothing..
> Ernesto "Che" Guevara



--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPoE3wAAoJEFMQTLzJFOZFR2MIAKoZn+oRnOhgm86zjtQnv+Hw
Gcmp5ZoOHPKwghpTzripbhuTpQYjn1LSdIC0RZs48YxGU/ys4uiWZBUHiJiVg5de
15L1ayoiaDoJwrY5FmfUmR6VerZ8RYYCwc4BLW8dhGcZSLen0fYeM6loZ8Mhaa6P
eOzt1gvFtS5pKXsNL+RENRG3YODDLMNsUoF6WAtS8/+aT7iGyxZEqzQvDxxxoDkr
YY4yKb6Af65BIm4UtWMADyu3xcma/ufDGETukvWW1JRS/FbbKcBz6g/y1T22wKBv
eV1a60xLhNQDH7cqwkEpl7pARGooQHBDnpRZnkE9POye9GcfxPDDr8RfW7+y6dU=
=ALso
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
