Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43667 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYCLOoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 10:44:16 -0400
Subject: Re: [PATCH] PS3: gelic: ignore scan info from zero SSID beacons
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Masakazu Mokuno <mokuno@sm.sony.co.jp>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, cbe-oss-dev@ozlabs.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	Stefan Assmann <sassmann@suse.de>
In-Reply-To: <1205332288.6387.58.camel@johannes.berg> (sfid-20080312_143256_070309_3580CC5E)
References: <20080312102148.0B08.40F06B3A@sm.sony.co.jp>
	 <1205310310.6387.56.camel@johannes.berg>
	 <20080312182438.0B1F.40F06B3A@sm.sony.co.jp>
	 <1205329351.32049.8.camel@localhost.localdomain>
	 <1205332288.6387.58.camel@johannes.berg>
	 (sfid-20080312_143256_070309_3580CC5E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AXQgo+RpmGBPgQNPaWG/"
Date: Wed, 12 Mar 2008 15:43:11 +0100
Message-Id: <1205332991.15910.0.camel@johannes.berg> (sfid-20080312_144502_579674_68C62D28)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AXQgo+RpmGBPgQNPaWG/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Wed, 2008-03-12 at 15:31 +0100, Johannes Berg wrote:
> > > >           Cell 02 - Address: 00:0A:79:A5:D2:E2
> > > >                     ESSID:""
> > > >                     Channel:0
> > > >                     Encryption key:on
> > > >                     Mode:Master
> > > >                     Signal level=3D100/100 =20
> >=20
> > Ewww.  You're 100% correct; we certainly shouldn't be sending a scan
> > result like this to userspace.  Therefore:
>=20
> I agree. Can you, however, tell whether the firmware has been fixed and
> only skip these for broken firmware?

Oh, never mind, the patch will already do that. I agree with that
completely :)

johannes

--=-AXQgo+RpmGBPgQNPaWG/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9fr/qVg1VMiehFYAQKcbw/+KOt3sLR0xnWWIYTjDsaREHz+KqkyTefb
y63wlnH4A7Zr7/g2FEfkofRtDyOodIa5nruk6HO4nl3XgaKSv/CpUVbAEsNvQefK
RtJSaTX0q7sQxSi8cYiNb6FI3y94/IRvhL0wD7xWfKUWbrJjP9OIeTzQ2V2H1hpX
PV6X7WZAlAf0jsl3j4GetOtrnsLGLnQgY9rmCnTKr/iAHl5le+rY6bnUi0FAziAY
aYeRXgktgBgeyas2AqqaspcP80S6BvvGkz1i2eCpcS10aDnFV4Wi9dqaAsJdnvm9
QJcTzPVrJjFJ3McdUVsDLdrmq/JYMWHBS2vUmtMgcGqDuNNnMJSpeJhctCv7k5Uy
emOqC/wH5CzZ01eXUXCEmTZix+GtyvKizh0oeBBq+yh9b86M89WZqzpyb1d2KmgR
np2Dem+7cZrBNvGosVMeQcX7o05HDPBbC4KGW4xGNq5Auosn/2D2pjEmBTabsvAe
nlbm0YhnRyjlSS4IfB6zKtIvUCr6idqWUEsmxhXkH/KCMrEj7UcN4wzHalK5YGyU
L9EspGPUFoKRMC8kdVX+lpRbQM2n5GzlDGZ2I8VALYlssXsUQGj9TtzhCuxaXfvg
plsmlFCeNsvMvQc2XjvmzfgF1cAy0+vNuaePJf3rh/Erqw1urkCsx5SFiFP844uC
Zc+0wm53SU8=
=dfRy
-----END PGP SIGNATURE-----

--=-AXQgo+RpmGBPgQNPaWG/--

