Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.lateralplains.com ([203.208.66.137]:54416 "EHLO
	mx.lateralplains.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYF2BhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 21:37:09 -0400
From: George Fong <george@lateralplains.com>
To: "Stefanik =?iso-8859-1?q?G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: Problem making compat-wireless-2.6
Date: Sun, 29 Jun 2008 11:33:42 +1000
Cc: linux-wireless@vger.kernel.org
References: <200806281953.16371.george@lateralplains.com> <69e28c910806280421t5e0de8edm8d6aab9cd582ccb7@mail.gmail.com>
In-Reply-To: <69e28c910806280421t5e0de8edm8d6aab9cd582ccb7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5986745.ovzdhR0tSU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200806291133.45866.george@lateralplains.com> (sfid-20080629_033744_225918_390A7A27)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart5986745.ovzdhR0tSU
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

<snip>

Dang :-) This was the fix.

> Try editing drivers/net/wireless/b43/rfkill.c, and replacing
> RFKILL_STATE_UNBLOCKED with RFKILL_STATE_ON and
> RFKILL_STATE_SOFT_BLOCKED with RFKILL_STATE_OFF. Looks like rfkill is
> not part of the compat package, and no work has been done to match
> compat-wireless to older RFKILLs.

Thank you for such prompt responses. Although I did this for the b43 driver=
, I=20
ended up progressively having to do the same fix for the drivers for a coup=
le=20
more, ie iwlwifi and rxt200=20

I am not concerned about the rxt200 but the driver I was interested in was =
the=20
iwl4965, so I am not sure that by changing the settings on iwl-rfkill.c I=20
have affected the driver I am using ....


Having said that... the email is brought to you courtesy of the iwl9645 wif=
i=20
device .. which has got to be a Good Thing ;-)

Agree about the proper way of doing things - should really install a newer=
=20
kernel, but I am strapped into an nVidia graphics card on my laptop and the=
=20
livna drivers keep pace well but I think I risk breaking these at the momen=
t=20
with the newer kernel.

Thank you all for your prompt responses and asistance... on a weekend no=20
less :-) I'll monitor progress and contribute whatever little I can as I ge=
t=20
this new laptop settled.

Cheers
G.

=2D-=20
George Fong
Lateral Plains Pty Ltd
Tel: +61 3 53 302 880
=46ax: +61 3 53 302 881
Just remember, wherever you go .... there you are.

--nextPart5986745.ovzdhR0tSU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkhm5nkACgkQyT6GKA4fvlBJ+gCfUhoMZ5KJw3M9lqlDOLadxZmB
S2wAoJ6QVXOmXjA6PqSMZa7B1bjx1rSU
=tIC+
-----END PGP SIGNATURE-----

--nextPart5986745.ovzdhR0tSU--
