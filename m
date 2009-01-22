Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39124 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179AbZAVOEs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 09:04:48 -0500
Subject: Re: poor performance with ath5k; reverting to ath_pci
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>,
	Glenn Burkhardt <gbburkhardt@verizon.net>,
	Bob Copeland <me@bobcopeland.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090122134958.GA27560@tuxdriver.com> (sfid-20090122_150113_735117_2FF31F66)
References: <200901140003.31693.gbburkhardt@verizon.net>
	 <200901151734.46144.gbburkhardt@verizon.net>
	 <b6c5339f0901160733u433b1154sfb8b5662c4fe991c@mail.gmail.com>
	 <200901202238.08756.gbburkhardt@verizon.net>
	 <20090121151435.GB3643@tuxdriver.com>
	 <69e28c910901211022j7f9c67dfv6392ce043dcff522@mail.gmail.com>
	 <20090121191141.GA14710@tuxdriver.com>
	 <69e28c910901211133n25c1a151nc9ca7172a9de7d3a@mail.gmail.com>
	 <40f31dec0901212032j65371fc6j5fcc1952f841d2ef@mail.gmail.com>
	 <20090122134958.GA27560@tuxdriver.com>
	 (sfid-20090122_150113_735117_2FF31F66)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UsHCBraYiATLVklmpE1+"
Date: Thu, 22 Jan 2009 15:04:35 +0100
Message-Id: <1232633075.4224.6.camel@johannes.local> (sfid-20090122_150459_769846_7D5D17D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UsHCBraYiATLVklmpE1+
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-22 at 08:49 -0500, John W. Linville wrote:
> On Thu, Jan 22, 2009 at 06:32:55AM +0200, Nick Kossifidis wrote:
> > 2009/1/21 Stefanik G=C3=A1bor <netrolller.3d@gmail.com>:
> > >
> > > I think EMBEDDED is for options that replace full-featured Linux
> > > components with dumbed-down, "low-profile" equivalents (like SLOB) -
> > > PID vs. minstrel is more like SLAB vs. SLUB.
> > >
> > > G=C3=A1bor
> > >
> >=20
> > Minstrell performs very well even on embedded devices, i don't think
> > it's that heavy compared to pid.
>=20
> I think his point was that people should be able to select multiple
> algorithms without having to select EMBEDDED.

The reason it was originally under EMBEDDED is that this allows you to
turn off _all_ algorithms, and that breaks, but might be desirable if
you have a system where you know you're using iwlagn or ath9k only which
have their own algorithms.

johannes

--=-UsHCBraYiATLVklmpE1+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJeHzxAAoJEKVg1VMiehFYgzMP/ideMhkghI/sxdonof4QVBPK
juwhnAGo6JHbbj/StSDasT1/ivO1svz+Y4ik0HjwaJaB4N6TUNqVWI/WGs112Ddz
ZrsZmpAFmvwk7rsQTIbrNM+u5TUtI3ZOq7zBVLAQ0lowO20l7cUGsAmiG1pshtWe
3hW0KKzNQDQ+cuyMcxI/6fv9FCeZtpTs/JKPQvT6wVAIxfCNYrJdxZUz4jmdCVXY
r9GFGqa8E/Vm0QYJ714q/4eTURacbcQ2kXH8mL8S5PlmnvjnMpBVuXDLz5PMKxLB
Xi5Bk7xZJFoIhgJu6L37lU/SwolpYBO7xzLdfhAO/VGyzIjcdi3GEVULvhZipBdd
lIIUksIb8lFjzYwkbf6mSfQhzlTa+6mqYEcGNDOMYQ8zpMjrmtgMBxxB/HfW3gC5
pqlHFoZxeskP6iB5ugOKnFuajdRvqXIJhy2rx61JA1q4xENGuEosKsj4yPfqTv+7
eSGLpg039nwwSUcmNAagFsCgJIjpM8y642Hzn8Z1McMhb7/eLgui2jWmLSdI9SBJ
7Ht2pNHTk63lAneGxuSExucK4TKjeYS43XB2r7I9m5IA0wFojZbyoUHp6ZzQDWzQ
6zTzT79wjf5bLrv17hwd5L/mHNHsWcHdnRq5RnFma0nQrZhonA5185/z5QYKApws
u03XXuAfu9WZy3D4G3zX
=Xn16
-----END PGP SIGNATURE-----

--=-UsHCBraYiATLVklmpE1+--

