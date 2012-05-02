Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:36517 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753729Ab2EBPa7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 11:30:59 -0400
Date: Wed, 2 May 2012 17:31:51 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120502153151.GB3692@ritirata.org> (sfid-20120502_173102_815983_C9C4D341)
References: <20120422182928.GA2854@ritirata.org>
 <20120430145803.GE2630@ritirata.org>
 <20120430170337.GA2560@tuxdriver.com>
 <4595B4D22AB93C4FABBA84AAD5AA37FD143115@ORSMSX103.amr.corp.intel.com>
 <CANUX_P1Nx4jYbRwehi+qW-2RVy=ntb_cCzBzpYXkJysuPvrCPA@mail.gmail.com>
 <20120501183415.GG4316@ritirata.org>
 <20120501205616.GA2563@ritirata.org>
 <4595B4D22AB93C4FABBA84AAD5AA37FD14438A@ORSMSX103.amr.corp.intel.com>
 <CANUX_P0UYx_-PS8BUGO10Cwrm6LuhMu4Vyhad4RL-Jn6YqE-Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
In-Reply-To: <CANUX_P0UYx_-PS8BUGO10Cwrm6LuhMu4Vyhad4RL-Jn6YqE-Pg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 02, 2012 at 10:08:46AM +0300, Emmanuel Grumbach wrote:
> On Wed, May 2, 2012 at 12:19 AM, Venkataraman, Meenakshi
> <meenakshi.venkataraman@intel.com> wrote:
> > Hi Antonio,
> >
> >>> it seems so. It happens at least once at boot time.
> >>> I will try wireless-testing and see what happens. Then I will apply y=
our patch.
> >>
> >>The problem is there either with wireless-testing and with
> >>wireless-testing+your_patch.
> >>
> >>If it can somehow help, I also got several stack trace regarding intel_=
iova
> >>functions. But then the I got kernel panic and I was not able to copy t=
he
> >>messages.
> >
> > [MV] Depending on how you set it up, perhaps the stack trace was saved =
in one of the syslog files in /var/log/...
> >
> > Thanks!
> > Meenakshi
> >
>=20
> Can you please re-run with debug=3D1 and send the whole log ?
> This will give a better indication on when the issue occurs.

I tried but I haven't seen the WARNING anymore...it smell like a race condi=
tion
(at least this is what is usually "fixed" by printings :-D).

I also retried to insert the module without the debug option but I didn't g=
et
the error anyway. This means that I get the error only at boot.

I will try to make more tests and eventually report what I see/understand.

Thank you for the work done so far!


Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPoVNnAAoJEFMQTLzJFOZFGzoH/1CzX600z35UIGxh4mCYCTtj
dVjbEtwFjTz0JWnezchaI1xizEPOJw+BFc1r9NEZiRd9cPMJZh29n+8NZ1Drrc89
3DbQmEB1RcQVr0s8gX+7iOM0eGyAjhZWNEpeAoWFS86t71gGfyvGKSBHsAl3xjxw
GmoMePuQMEoLFwBAl0APikPMt175EFW+lfK/SYz4//g+BHcLEbMfqwbwwXlnTJXv
gPAirCvHO9HLeqYn5aTgLm+UMJ2lC+qvbTomjw/c7GRV7ZB4DwQrD9VupD6VjF04
Zx4C3IRivaUrtbcRXFbJTDfwOwrfLnR2E8+/5dWdZHVSyxjwr33XTzZb0FAExWc=
=bi8W
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
