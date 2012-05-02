Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:38633 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751843Ab2EBQLi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 May 2012 12:11:38 -0400
Date: Wed, 2 May 2012 18:12:32 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	"Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi warn_slowpath with 3.*
Message-ID: <20120502161231.GD3692@ritirata.org> (sfid-20120502_181141_648500_95E5F607)
References: <20120422182928.GA2854@ritirata.org>
 <20120430145803.GE2630@ritirata.org>
 <20120430170337.GA2560@tuxdriver.com>
 <4595B4D22AB93C4FABBA84AAD5AA37FD143115@ORSMSX103.amr.corp.intel.com>
 <CANUX_P1Nx4jYbRwehi+qW-2RVy=ntb_cCzBzpYXkJysuPvrCPA@mail.gmail.com>
 <20120501183415.GG4316@ritirata.org>
 <20120501205616.GA2563@ritirata.org>
 <4595B4D22AB93C4FABBA84AAD5AA37FD14438A@ORSMSX103.amr.corp.intel.com>
 <CANUX_P0UYx_-PS8BUGO10Cwrm6LuhMu4Vyhad4RL-Jn6YqE-Pg@mail.gmail.com>
 <20120502153914.GA9285@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
In-Reply-To: <20120502153914.GA9285@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 02, 2012 at 11:39:14AM -0400, John W. Linville wrote:
> On Wed, May 02, 2012 at 10:08:46AM +0300, Emmanuel Grumbach wrote:
> > On Wed, May 2, 2012 at 12:19 AM, Venkataraman, Meenakshi
> > <meenakshi.venkataraman@intel.com> wrote:
> > > Hi Antonio,
> > >
> > >>> it seems so. It happens at least once at boot time.
> > >>> I will try wireless-testing and see what happens. Then I will apply=
 your patch.
> > >>
> > >>The problem is there either with wireless-testing and with
> > >>wireless-testing+your_patch.
> > >>
> > >>If it can somehow help, I also got several stack trace regarding inte=
l_iova
> > >>functions. But then the I got kernel panic and I was not able to copy=
 the
> > >>messages.
> > >
> > > [MV] Depending on how you set it up, perhaps the stack trace was save=
d in one of the syslog files in /var/log/...
> > >
> > > Thanks!
> > > Meenakshi
> > >
> >=20
> > Can you please re-run with debug=3D1 and send the whole log ?
> > This will give a better indication on when the issue occurs.
>=20
> Does this help?
>=20
> 	https://bugzilla.redhat.com/show_bug.cgi?id=3D815998#c18

Hello John,

the patch you provided in comment 17 is not applying on top of
wireless-testing..

Applying: iwlwifi: give PCIe its own lock
error: patch failed: drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h:226
error: drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h: patch does not ap=
ply
error: patch failed: drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c:329
error: drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c: patch does not app=
ly
error: patch failed: drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c:477
error: drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c: patch does not app=
ly
error: patch failed: drivers/net/wireless/iwlwifi/iwl-trans-pcie.c:217
error: drivers/net/wireless/iwlwifi/iwl-trans-pcie.c: patch does not apply
Patch failed at 0001 iwlwifi: give PCIe its own lock


Cheers,

>=20
> John
> --=20
> John W. Linville		Someday the world will need a hero, and you
> linville@tuxdriver.com			might be all we have.  Be ready.

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAEBAgAGBQJPoVzvAAoJEFMQTLzJFOZFB/QIAIDqzcTT2WIKwNBmVDceOByP
PiO/4Nwa3P21uF75bOxxoGw47v3pnwwk4vTSy/J5DmQNHHRrMnOfgOEZLJP+3yrE
NoAswuOq1OtcVqNj6/r3kxJ4QMT5KncgOxN8pAW1tuoNJ3elBV4Z+fIkeY576ZsX
9EgW7apPH90jD89YWEaw7JFrKmt7FunZuDsG/DL28diT1l4jWd8Il6/R3n6jfqs6
zenqjrs1LDEliTG9MMXKUhNsIoXx5gNDyoQ7kqlnoYnTmeXfjmPrCvf09znHhAoB
AVzA/4yln37pSqvsqPaUm1Gefl4uf6StX2x3zApNE4zXULLud15VtjdvwLOSELw=
=OOGM
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
