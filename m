Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:43732 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759999AbXHHDPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 23:15:21 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix tx status frame code
Date: Tue, 7 Aug 2007 20:13:24 -0700
Cc: linux-wireless@vger.kernel.org, jbenc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>
References: <1186475037.4067.14.camel@johannes.berg> <1186480510.4067.35.camel@johannes.berg>
In-Reply-To: <1186480510.4067.35.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart395517996.MhdPVv1izx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708072013.28765.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart395517996.MhdPVv1izx
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 07 August 2007 02:55, Johannes Berg wrote:
> This should probably go to .23 as well as -stable.
>
-stable is for .22.. I don't think outgoing frame monitoring was in 2.6.22.

-Michael Wu

--nextPart395517996.MhdPVv1izx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGuTTYT3Oqt9AH4aERAuRhAKCx1tdmEz5ZvusDafg4upL3Mi+nAQCeNHce
fhG3Ky2S3Spo8iGw9h4oycM=
=LarN
-----END PGP SIGNATURE-----

--nextPart395517996.MhdPVv1izx--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
