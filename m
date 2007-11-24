Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:40376 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753218AbXKXFUF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Nov 2007 00:20:05 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: include MAC timestamp in radiotap header
Date: Sat, 24 Nov 2007 00:21:12 -0500
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <1195814754.4149.86.camel@johannes.berg>
In-Reply-To: <1195814754.4149.86.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3949579.gcXcgm8aC9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200711240021.12394.flamingice@sourmilk.net> (sfid-20071124_052019_820794_EB267ACC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3949579.gcXcgm8aC9
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 23 November 2007 05:45:54 Johannes Berg wrote:
> This makes mac80211 include the low-level MAC timestamp
> in the radiotap header.
>
No thanks. Not every driver supports reporting the timestamp and supporting=
=20
timestamp/no timestamp in the default radiotap rx code makes it not so simp=
le=20
anymore.

=2DMichael Wu

--nextPart3949579.gcXcgm8aC9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHR7TIT3Oqt9AH4aERAqUVAJ9XN6czV3lAWYgYyx77m1jCPaF09gCgj9WC
0zEKGHalMEzZEwWMDgIJHFw=
=m2pl
-----END PGP SIGNATURE-----

--nextPart3949579.gcXcgm8aC9--
