Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35577 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbXIHJf3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 05:35:29 -0400
Subject: Re: Kernel panic with rt2500pci built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: Rob Hussey <robjhussey@gmail.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
In-Reply-To: <6b8cef970709080126t517cd2e3r292f6b933d615384@mail.gmail.com>
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <6b8cef970709052025w4885b075yc9cf79c9f7f6dd52@mail.gmail.com>
	 <1189125944.28781.125.camel@johannes.berg>
	 <6b8cef970709071231s5693b835vaf8493254c8292da@mail.gmail.com>
	 <1189193840.28781.197.camel@johannes.berg>
	 <6b8cef970709071438o6870cecej355119fee4396dcb@mail.gmail.com>
	 <1189202441.28781.208.camel@johannes.berg>
	 <6b8cef970709072129r5d7658b8v46e5b327638b8f06@mail.gmail.com>
	 <6b8cef970709072140o23cfd152nee56313db53739ae@mail.gmail.com>
	 <1189237764.4506.14.camel@johannes.berg>
	 <6b8cef970709080126t517cd2e3r292f6b933d615384@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-k/tsqJhHMy2iiEHbcsU6"
Date: Sat, 08 Sep 2007 11:36:57 +0200
Message-Id: <1189244217.4506.16.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-k/tsqJhHMy2iiEHbcsU6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-08 at 04:26 -0400, Rob Hussey wrote:

> Much like when I commented out the ieee80211_register_hw call, the
> kernel booted fine, but there was no sign of the wireless card in the
> logs or otherwise.

?! That shouldn't have an effect like that. Are you positive that you
put the register_hw call back?

johannes

--=-k/tsqJhHMy2iiEHbcsU6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4m05/ETPhpq3jKURAkmIAKCAXI2Su/d/jvxar+sAvhPR4bP6ngCgrSp4
zeb4Vp9oDN483nwx9iFD/g0=
=uwpT
-----END PGP SIGNATURE-----

--=-k/tsqJhHMy2iiEHbcsU6--

