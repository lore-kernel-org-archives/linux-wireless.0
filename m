Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:51732 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab2FMSmm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 14:42:42 -0400
Date: Wed, 13 Jun 2012 20:42:30 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andre Heider <a.heider@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >=
 n_queues))
Message-ID: <20120613204230.474d1b6c@milhouse> (sfid-20120613_204246_189004_E4255C9D)
In-Reply-To: <1339602402.4519.48.camel@jlt3.sipsolutions.net>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	<1339168600.5748.2.camel@jlt3.sipsolutions.net>
	<CAHsu+b_Dp-A_kC-MSofJko3hr4dYxreYQ7rrq7wzsJXVoY_5yw@mail.gmail.com>
	<4FD21C6B.5000402@lwfinger.net>
	<1339170182.5748.7.camel@jlt3.sipsolutions.net>
	<1339170287.5748.8.camel@jlt3.sipsolutions.net>
	<1339170510.5748.9.camel@jlt3.sipsolutions.net>
	<1339170742.5748.10.camel@jlt3.sipsolutions.net>
	<CAHsu+b8ZGPN3iQNGH1mdzMO6kH+F1n+qZ5cT4KMcx8bh_BP1qg@mail.gmail.com>
	<1339171159.5748.11.camel@jlt3.sipsolutions.net>
	<CAHsu+b9EgAfq6_G8xqRzf0qHkmyQnvs7j=g4wWcSVJXstAz4mw@mail.gmail.com>
	<4FD22727.7000500@lwfinger.net>
	<1339180580.5748.32.camel@jlt3.sipsolutions.net>
	<1339180948.5748.35.camel@jlt3.sipsolutions.net>
	<1339182289.5748.36.camel@jlt3.sipsolutions.net>
	<1339576294.4519.17.camel@jlt3.sipsolutions.net>
	<CAHsu+b9soGKgZmqWLU=-v0zOG0v_Arf8DFoCn1EQ7-86Mg_CdQ@mail.gmail.com>
	<1339602402.4519.48.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AQdaI11w1T9ZT2YfjJ/c=O1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/AQdaI11w1T9ZT2YfjJ/c=O1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Jun 2012 17:46:42 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Wed, 2012-06-13 at 17:39 +0200, Andre Heider wrote:
> > On Wed, Jun 13, 2012 at 10:31 AM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > > On Fri, 2012-06-08 at 21:04 +0200, Johannes Berg wrote:
> > >
> > >> Ahrg, b43 only sets fw.opensource too late ... this moves it:
> > >> http://p.sipsolutions.net/00c0056dc206e247.txt
> > >
> > > Has anyone tested this?
> >=20
> > Sorry, missed that one.
> > I get this crash with that patch: http://i.imgur.com/2CMzA.png
>=20
> Huh, that doesn't make a lot of sense to me, I don't move any
> locking ...

This just seems to be a follow-up oops and the original one scrolled off sc=
reen.

--=20
Greetings, Michael.

PGP encryption is encouraged / 908D8B0E

--Sig_/AQdaI11w1T9ZT2YfjJ/c=O1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2N8WAAoJEPUyvh2QjYsOmmcQAJVO+zJsT5kJDSo3onjGNjTJ
+Uy+fLMLHU4mNwSAWxrqaDEXYQttq7TJIGFLAIeqiVOFn/ZLRsp8vTK/grEeom8+
Ut+1+0yM6Fqzld7WXQnRmA2K3TI23Z4AtBoNSeVMU8j3jorxJmfu9jxhf/0OkN9o
dPauueOx2RruZBDTt7r/WTKKvcCUiT6Rt5LZHIkp70gPDgW//2ICJCeC+s/vFaZa
20xQ9g8/C8obDUsgvjoXilQv0CsqGlXcyQRXYP6URoPzqpkRL34Fc8vrd9lOE4NA
7ngEvsXO1FPbhGGE03+Mm+HyCR14itxc5Spjs8MPpKKoJRfgZbwvSEWvo0OQtkwv
4YjqzTESpBZn5SDw2KWJXrVRgv2qcSTrcPtwFu8pubmhe1utHS3qb4Fwu/DKFfWd
GQHYo6hTBqPnujNmCGrb9aMGXb+Lrzv+GI1nO2h0pdys7H5ur5xCCLw+/NoC2Yed
TCgJZDksaa/8h3MGUW11Cc4MMX1MY4kq66BFkWFqMxx89zTKjXvgUsOqbcAF1hQb
QvH2DniTRgBX6H4Dwjnyac2TYcJMlYYfq3UvTCLj0FMhvpMPHnYtYQE3pcouxCfa
a/cf4T2xpQse2XQTgh3GI2kZOOT19/EK0w8A0HWH8n2nJqeRp51/wpKjYg07uklS
BpOR4rbPDxkU0EXSLxuK
=TmOd
-----END PGP SIGNATURE-----

--Sig_/AQdaI11w1T9ZT2YfjJ/c=O1--
