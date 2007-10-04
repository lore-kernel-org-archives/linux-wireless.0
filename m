Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:34863 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757364AbXJDVS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 17:18:27 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: Fix TX after monitor interface is converted to managed
Date: Thu, 4 Oct 2007 17:16:28 -0400
Cc: Michael Buesch <mb@bu3sch.de>, Daniel Drake <dsd@gentoo.org>,
	johannes@sipsolutions.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
References: <20071004113343.552139D502B@zog.reactivated.net> <200710041311.37997.flamingice@sourmilk.net> <20071004181516.GH6037@tuxdriver.com>
In-Reply-To: <20071004181516.GH6037@tuxdriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3810229.ukmq4tXfGv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710041716.31942.flamingice@sourmilk.net> (sfid-20071004_221832_868374_C3FA198F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3810229.ukmq4tXfGv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 04 October 2007 14:15, John W. Linville wrote:
> Falling back on bloat as an argument against a BUG_ON in a
> configuration path seems a bit weak. :-)
>
Seems strong to me. Bloat slows me down and distracts me from what code rea=
lly=20
needs to do. Bloat is an indication that one does not understand what the=20
code really needs to do.

> Programming with assertions (and BUG_ON is a form of that) is
> generally a good practice.  Almost any book or other source on
> good programming practices will agree.  Yes, it can be overdone.
> But I don't really think that is the case here, since the check is
> relatively inexpensive and the consequence should it ever *somehow*
> happen could be a something wierd (crash, corruption, etc) w/o any
> other indication of what occured.
>
A line has to be drawn somewhere. There's about a billion places where we c=
an=20
add checks like this because if an assumption should ever break, the code=20
will break into pieces. However, we don't, and there's no reason to do so=20
here other than to needlessly add code just because it makes you feel safer.

=2DMichael Wu

--nextPart3810229.ukmq4tXfGv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBHBVgvT3Oqt9AH4aERAgpPAJ9Ub3RvKYnZ7tCM8js1xPscKgFrUgCgmcp+
+3sdmlJO3OQEaqHChXH+gtc=
=K82d
-----END PGP SIGNATURE-----

--nextPart3810229.ukmq4tXfGv--
