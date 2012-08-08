Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from latitanza.investici.org ([82.94.249.234]:24508 "EHLO
	latitanza.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757883Ab2HHXCG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 19:02:06 -0400
Date: Thu, 9 Aug 2012 01:02:00 +0200
From: Antonio Quartulli <ordex@autistici.org>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: =?utf-8?B?Tmljb2zDoXMgRWNow6FuaXo=?= <nicoechaniz@codigosur.org>,
	Guido Iribarren <guidoiribarren@buenosaireslibre.org>,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	ordex@autistici.org
Subject: Re: [ath9k-devel] ath9k_htc 1mbps in IBSS mode
Message-ID: <20120808230200.GC6767@ritirata.org> (sfid-20120809_010210_999291_5B4313FA)
References: <4FD56DCA.1080200@codigosur.org>
 <CAJ-VmomzoXV8YBdiS_2nkzVagBupX3Be-Dmboxotwy9s3h3r7w@mail.gmail.com>
 <CAHD-aqKWdUBGyadCnVoSbkf4BysoSuvBBHrupXx-JbowqqNZPQ@mail.gmail.com>
 <CAHD-aqJrKfL8OL97wcnaaTYFZrx2cBXvdY5vKeK67u_-VjGOKg@mail.gmail.com>
 <20474.20627.928963.262924@gargle.gargle.HOWL>
 <4FFF2B15.5070502@codigosur.org>
 <20482.22437.126251.847921@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7F3eY7HS/tUJxUd"
In-Reply-To: <20482.22437.126251.847921@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--i7F3eY7HS/tUJxUd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 15, 2012 at 11:09:49AM +0530, Sujith Manoharan wrote:
> Nicol=C3=A1s Ech=C3=A1niz wrote:
> > Sujith, does this mean that the problem is outside the scope of the
> > ath9k_htc driver itself or could it be fixed?
> >=20
> > we are doing some heavy use of hardware based on this driver for many
> > projects; any further debugging work you might need, we are more than
> > willing to help.
>=20
> This is a regression introduced by this commit:
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dcommit=
;h=3D6d810f10325522cfcf498dc6d64b9f96e1f5153f
>=20
> Fixing this requires either introducing a new mac80211 callback or
> revert to the older behavior which issued a station notification only
> after the supported rates have been setup.
>=20

Hello people, Sujith,

after having read your previous email in the mail-archive (I was not in the
thread since then) I realised that the problem concerns only some drivers. I
better looked at the code and I realised where the problem is.

Thank you.
Cheers,

--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--i7F3eY7HS/tUJxUd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlAi7+gACgkQpGgxIkP9cweEXACfTIMc8crsGphy/RFeHwM8DTQ0
fMYAn2cJ7RlkKX0aP4P9DdOkhQdy/gf1
=KoXR
-----END PGP SIGNATURE-----

--i7F3eY7HS/tUJxUd--
