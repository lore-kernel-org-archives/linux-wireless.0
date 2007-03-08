Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48873 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbXCHRmh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 12:42:37 -0500
Subject: Re: sparse using insane amounts of memory
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
In-Reply-To: <1173375270.15842.24.camel@dv>
References: <1173319356.3546.54.camel@johannes.berg>
	 <1173371608.21465.12.camel@dv>  <1173372315.3248.19.camel@johannes.berg>
	 <1173375270.15842.24.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WRUTWb1nn6F/YbqVTt9K"
Date: Thu, 08 Mar 2007 18:42:29 +0100
Message-Id: <1173375749.3248.35.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WRUTWb1nn6F/YbqVTt9K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-08 at 12:34 -0500, Pavel Roskin wrote:

> FIELDS32 expands to some monstrosities.  Look for rt2x00_bbp_write in
> the dump.  Also behold the amount of parentheses in LOWEST_BIT32.
> That's almost certainly the culprit.

Ouch, yeah, looks pretty bad.

> I understand the idea is to make gcc calculate integer logarithms at the
> compile time.  That's nice, but sparse has to do the same, and it's
> probably not optimized for such misuse.

The whole logic there is beyond me without giving it some serious look
so I'll trust you on that :)

johannes

--=-WRUTWb1nn6F/YbqVTt9K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF8EsF/ETPhpq3jKURAhz2AKCX9l7I/5phmUiSoGStbJVz0kpPqQCglO7d
GYk9Cgq7ZSOv0B7+4JJBP3U=
=MM0e
-----END PGP SIGNATURE-----

--=-WRUTWb1nn6F/YbqVTt9K--

