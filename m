Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:35987 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750931AbXHIESW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2007 00:18:22 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: probe for hidden SSIDs in pre-auth scan
Date: Wed, 8 Aug 2007 21:16:33 -0700
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <20070807203315.GG3330@tuxdriver.com> <1186565651.11717.23.camel@johannes.berg> <1186566071.11717.28.camel@johannes.berg>
In-Reply-To: <1186566071.11717.28.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10694037.qIMs4RabWP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708082116.38013.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart10694037.qIMs4RabWP
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 08 August 2007 02:41, Johannes Berg wrote:
> On the other hand, calling with a "anything, 0" probably has the same
> effect as calling with "NULL, 0" so the "ifsta->ssid_len" condition can
> go away just as linville had it.
>
Yep.

-Michael Wu

--nextPart10694037.qIMs4RabWP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGupUlT3Oqt9AH4aERAsslAKDAp0CRlaDN0Jf1ipC45t1kXeMPIwCfZGaC
caBnJcWcgnHFnLan9azky0w=
=jjW3
-----END PGP SIGNATURE-----

--nextPart10694037.qIMs4RabWP--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
