Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:17993 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750813AbXF2GA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2007 02:00:56 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Export short-preamble bit to drivers
Date: Thu, 28 Jun 2007 23:01:11 -0700
Cc: Michael Buesch <mb@bu3sch.de>, Jiri Benc <jbenc@suse.cz>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200706251628.00838.mb@bu3sch.de> <200706271840.09719.flamingice@sourmilk.net> <1183024620.4769.80.camel@johannes.berg>
In-Reply-To: <1183024620.4769.80.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart24148086.5xsq4YdW2F";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706282301.16474.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart24148086.5xsq4YdW2F
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 28 June 2007 02:57, Johannes Berg wrote:
> I don't think we ever care about configuring it per-frame and currently
> can't afaik, so I don't think we can rightfully say "short preamble
> allowed" unless we want to confuse driver authors about who is
> responsible for then determining whether to use it or not for each
> frame.
>
mac80211 does this per-frame. It does matter. Short preamble should not be=
=20
configured by a global bit. What does the bcm43xx firmware do with this bit?

=2DMichael Wu

--nextPart24148086.5xsq4YdW2F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGhKAsT3Oqt9AH4aERAu+CAKDMUWhhb4NFRhzQYOUuCv98wWqDmwCdGTwQ
e/ms8suJzCXBLsN3010x71o=
=f7E+
-----END PGP SIGNATURE-----

--nextPart24148086.5xsq4YdW2F--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
