Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35693 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYG2I2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 04:28:23 -0400
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks
	rtl8187
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com> (sfid-20080729_102332_148538_ADA964EA)
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	 <48874F09.7060400@lwfinger.net>
	 <3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	 <200807290021.45400.herton@mandriva.com.br>
	 <1217314430.15381.11.camel@johannes.berg>
	 <1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com>
	 (sfid-20080729_102332_148538_ADA964EA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aXFR9dJxdrPDPKRYg4zL"
Date: Tue, 29 Jul 2008 10:28:09 +0200
Message-Id: <1217320089.15381.25.camel@johannes.berg> (sfid-20080729_102827_806204_8924A498)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aXFR9dJxdrPDPKRYg4zL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 11:23 +0300, Tomas Winkler wrote:
> On Tue, Jul 29, 2008 at 9:53 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2008-07-29 at 00:21 -0300, Herton Ronaldo Krzesinski wrote:
> >
> >> [3] /sbin/iwconfig wlan0 power on
> >
> > I don't think turning on power management (yes, this command is
> > completely misnamed, it turns on power _management_ not the power, you
> > may want "txpower auto") does anything on this chip, does it?
> >
> iwconfig power on is not implemented by mac80211 yet. There was one
> patch posted that implements it.
> I wanted to expand it but  wireless_tools 29 has a bug in parsing this
> command. It is fixed only in 30.pre6 which is usually not in distros.

Heh, fun. Time for putting that into cfg80211 instead if nobody can use
it with wext anyway?

johannes

--=-aXFR9dJxdrPDPKRYg4zL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjtSVAAoJEKVg1VMiehFYrA4QAKI3j8yZS5SIgAxVsrrvkjIV
tmLiVUzCSSzzo13M1LylASi6s1og4p+Lb0l2IcHHrZOTu9vMYFQ0uR1GmesH3OQ8
3afTXyP0cya7vOKr5GDFVrUt7eqO3sv7HQn/K3Ipzpy5bQveca+MSM3xKiTE9VAo
FA9KXa0k+5v/iXDQdI1UTdhJJ2lKCgi7L5JSk/8ca/A9g9m64jEV2qmSvQNyOCMb
8ns0SkzDuwVomaHd/xMITt4bquVHLxaanejc2a1KVLYKUbVvrXbHvN17BhdpvG5X
nIBq8VTRD6ojK/I5tVmOQNSYfFN5UlTVRRbav97YoU4SSohwv495TJVmoPUr7dWl
8cRknJuPutOVWODJJL5nEcr2w9pSNUZ+qRy8npgwrQO06+CjmuK1QjJkuCUJNsU6
XlFBMza3LYWbGsNiJSSXazALbHg2AivTuHIwuyyhTnOvTfzpbX1WzfDszxRKf2LT
kLOUCGGYzjsDomL/zIzrso6CORPv52ohGnORsMGh6poQczZZ7vLG5NRlXKlJ2tYK
BD1YMaeTR+PIkUoFDpFaptsR+2K6QjyuNPjEE8nfrURHahoK4L0riM66seV27BFI
t8DasDxvoEjSUZbvGTK7xZ48R5MGuy8vmbygLNzWriIQLjnOb4wwTjv3sgPIrD6u
vxEGnVAtMNTLbebJ2ILq
=TBQf
-----END PGP SIGNATURE-----

--=-aXFR9dJxdrPDPKRYg4zL--

