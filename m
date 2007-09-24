Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:25079 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756715AbXIXTXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 15:23:25 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: zd1211 config operation problem
Date: Mon, 24 Sep 2007 15:22:20 -0400
Cc: Michael Buesch <mb@bu3sch.de>, Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <200709231648.17107.mb@bu3sch.de> <1190654401.18521.272.camel@johannes.berg> <1190654481.18521.274.camel@johannes.berg>
In-Reply-To: <1190654481.18521.274.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart16093329.8vqcOSEOSj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200709241522.21156.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart16093329.8vqcOSEOSj
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 24 September 2007 13:21, Johannes Berg wrote:
> Also, shouldn't we then call ->config when the first interface is
> brought up or something?
>
I'm pretty sure that was done for all cases at some point. When did it get=
=20
switched to being done for just monitor?

=2DMichael Wu

--nextPart16093329.8vqcOSEOSj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG+A5tT3Oqt9AH4aERAhbDAJ9nV4HpAyk809G58pAZilgHhIh5RQCfUuVi
vmGLHFaZplyVWz8EEW04chk=
=WoR+
-----END PGP SIGNATURE-----

--nextPart16093329.8vqcOSEOSj--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
