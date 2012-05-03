Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:50967 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab2ECGxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 02:53:04 -0400
Date: Thu, 3 May 2012 08:53:53 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120503065351.GB2307@ritirata.org> (sfid-20120503_085309_786788_5C7C08CD)
References: <20120430145803.GE2630@ritirata.org>
 <20120430170337.GA2560@tuxdriver.com>
 <4595B4D22AB93C4FABBA84AAD5AA37FD143115@ORSMSX103.amr.corp.intel.com>
 <CANUX_P1Nx4jYbRwehi+qW-2RVy=ntb_cCzBzpYXkJysuPvrCPA@mail.gmail.com>
 <20120501183415.GG4316@ritirata.org>
 <20120501205616.GA2563@ritirata.org>
 <4595B4D22AB93C4FABBA84AAD5AA37FD14438A@ORSMSX103.amr.corp.intel.com>
 <CANUX_P0UYx_-PS8BUGO10Cwrm6LuhMu4Vyhad4RL-Jn6YqE-Pg@mail.gmail.com>
 <20120502153914.GA9285@tuxdriver.com>
 <20120502162100.GA2528@ritirata.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A6N2fC+uXW/VQSAv"
In-Reply-To: <20120502162100.GA2528@ritirata.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 02, 2012 at 06:21:02PM +0200, Antonio Quartulli wrote:
> On Wed, May 02, 2012 at 11:39:14AM -0400, John W. Linville wrote:
> > On Wed, May 02, 2012 at 10:08:46AM +0300, Emmanuel Grumbach wrote:
> > > On Wed, May 2, 2012 at 12:19 AM, Venkataraman, Meenakshi
> > > <meenakshi.venkataraman@intel.com> wrote:
> > > > Hi Antonio,
> > > >
> > > >>> it seems so. It happens at least once at boot time.
> > > >>> I will try wireless-testing and see what happens. Then I will app=
ly your patch.
> > > >>
> > > >>The problem is there either with wireless-testing and with
> > > >>wireless-testing+your_patch.
> > > >>
> > > >>If it can somehow help, I also got several stack trace regarding in=
tel_iova
> > > >>functions. But then the I got kernel panic and I was not able to co=
py the
> > > >>messages.
> > > >
> > > > [MV] Depending on how you set it up, perhaps the stack trace was sa=
ved in one of the syslog files in /var/log/...
> > > >
> > > > Thanks!
> > > > Meenakshi
> > > >
> > >=20
> > > Can you please re-run with debug=3D1 and send the whole log ?
> > > This will give a better indication on when the issue occurs.
> >=20
> > Does this help?
> >=20
> > 	https://bugzilla.redhat.com/show_bug.cgi?id=3D815998#c18
>=20
> I applied patch in comment 17 on linux-3.3.4. IT didn't help but this tim=
e I got
> the WARNING even with debug=3D1. Log is attached.
>=20


Is there any particular kernel debugging option I could enable to make the =
log
more verbose?


Cheers,



--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--A6N2fC+uXW/VQSAv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPoit/AAoJEFMQTLzJFOZF3VoIALYnKK0+HPvVkemfqgr/d+yE
fDVIEM3dhORvCm2gESnrKXDnnsGGU/tv4ZJJu1KQIqjO0ndwGleiW3fvwy40HN+B
1cCtG6nSDg0CHYOfkcGx5lQ6yWtL/Y0Gcieng6orhwT3M2TgcMM91/HmI5aaT3Fp
RsK9dvpyPvvs+Qqg4k7u8jh62eMJDc5dYPNMlXvQnkalZCr8A3UkfqB2wtzmXR2v
aJWvy07S8SMfspI7F2jN17oDjmKYCL4HH6au/YKZl+0nPUHiMD7dH9hndwCBNh+0
BJYYPIpymxl9tj5eSlD2EFC9wXrAJe3jclF80gSRyVdvPO/gxhGY3DLiVghF/D8=
=PhZ3
-----END PGP SIGNATURE-----

--A6N2fC+uXW/VQSAv--
