Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:63034 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751256AbXHVEo2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Aug 2007 00:44:28 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] mark islsm list as subscribers-only
Date: Wed, 22 Aug 2007 00:42:11 -0400
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Jean-Baptiste Note" <jbnote@gmail.com>
References: <1187282653.23489.36.camel@johannes.berg> <1187714252.4218.9.camel@johannes.berg> <43e72e890708211039y53e2c24aqbf5c00c24f0a0df6@mail.gmail.com>
In-Reply-To: <43e72e890708211039y53e2c24aqbf5c00c24f0a0df6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12376129.44H6VyZI9N";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708220042.16421.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart12376129.44H6VyZI9N
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 21 August 2007 13:39, Luis R. Rodriguez wrote:
> ACK -- we can create a new list too which we are sure is for p54. Michael?
>
I do cc that list, and it's useful since some people who know the firmware =
and=20
hardware very well are on the list. However, subscriber only lists aren't=20
acceptable in MAINTAINERS AFAIK, so we need to remove it. Not sure if there=
's=20
a better solution. We just need a list which isn't subscribers only.. if a=
=20
list hosted somewhere else can help with that, I think everyone on islsm=20
should be migrated there.

=2DMichael Wu

--nextPart12376129.44H6VyZI9N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGy76oT3Oqt9AH4aERAteEAKC9Tgj5JlYrzhoCZBXdOjgvdEYCaQCgqb0o
ncNm8li1sK9hjKnWYesXFyo=
=GT/x
-----END PGP SIGNATURE-----

--nextPart12376129.44H6VyZI9N--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
