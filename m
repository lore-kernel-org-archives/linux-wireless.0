Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57198 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbXIGTgZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2007 15:36:25 -0400
Subject: Re: Kernel panic with rt2500pci built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: Rob Hussey <robjhussey@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <6b8cef970709071231s5693b835vaf8493254c8292da@mail.gmail.com>
References: <6b8cef970709052006q43d5602ewde0cea45500deede@mail.gmail.com>
	 <6b8cef970709052025w4885b075yc9cf79c9f7f6dd52@mail.gmail.com>
	 <1189125944.28781.125.camel@johannes.berg>
	 <6b8cef970709071231s5693b835vaf8493254c8292da@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Am0p2kmZE3c72jsErh4s"
Date: Fri, 07 Sep 2007 21:37:20 +0200
Message-Id: <1189193840.28781.197.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Am0p2kmZE3c72jsErh4s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-07 at 15:31 -0400, Rob Hussey wrote:

> This was with wireless-dev git. I can try DEBUG_KOBJECT once I get a chan=
ce.

That'd be good.

> I'd like to try to bisect this though, but I'm having trouble finding
> a point in which it worked.

> If I do:
> git clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless=
-dev.git
> and then:
> git pull . remotes/origin/rt2x00
>=20
> Then my commit history has all rt2x00 commits on top, and trying to
> reset to an earlier point in time reverts rt2x00 commits, but not
> wireless-dev commits (unless I  reset to before the initial rt2x00
> commit). This causes compile errors mostly involving undeclared stuff
> prefixed "IEEE80211_" Is there a better way to do this? Did I even
> start out correctly?

I'm not sure you can bisect due to the way mac80211/rt2x00 are currently
developed, in lockstep but in different branches that are pulled
together.

johannes

--=-Am0p2kmZE3c72jsErh4s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG4ahw/ETPhpq3jKURAnJDAJ0RlAjmnlH3qR/dPxZKp18+X91rcACcCDcv
fLhJwub/TwZcmTdZoC6wcQg=
=vSuj
-----END PGP SIGNATURE-----

--=-Am0p2kmZE3c72jsErh4s--

