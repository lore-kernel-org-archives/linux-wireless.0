Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:9553 "EHLO annwn13.rutgers.edu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751156AbXHPEy5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 00:54:57 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: remove reset callback
Date: Wed, 15 Aug 2007 21:52:59 -0700
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>
References: <1187133209.31200.30.camel@johannes.berg>
In-Reply-To: <1187133209.31200.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2194106.i6ufahs1h0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708152152.59760.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2194106.i6ufahs1h0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 14 August 2007 16:13, Johannes Berg wrote:
> Somebody (I think it was Uli) recently complained about this callback so
> when I just remembered that I went and looked where it is used. Guess
> what: nowhere. I think it was at one point used in the tx timeout
> handler but that should probably do something else anyway.
>
I removed the code that used it since it couldn't possibly work right and m=
ost=20
drivers end up just doing a stop and open on their interface to implement=20
reset anyway.

=2DMichael Wu

--nextPart2194106.i6ufahs1h0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGw9grT3Oqt9AH4aERAuhlAKCJc0M8t8UBDvxjSUeFm8pVdFm77ACfRS8r
y4k03fx9P+HFySGWEpMEHig=
=S9Nn
-----END PGP SIGNATURE-----

--nextPart2194106.i6ufahs1h0--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
