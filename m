Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:16741 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755792AbXGEGFq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2007 02:05:46 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: Multiple interfaces in mac80211
Date: Wed, 4 Jul 2007 23:05:36 -0700
Cc: linux-wireless@vger.kernel.org
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com>
In-Reply-To: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1298232.k1KcJ7fKcl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707042305.40944.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1298232.k1KcJ7fKcl
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 04 July 2007 17:23, Jon Smirl wrote:
> I added some debugging code to __ieee80211_rx() and I noticed in this loop:
> 		list_for_each_entry(sdata, &local->sub_if_list, list) {
>
sub_if_list includes the master interface.

-Michael Wu

--nextPart1298232.k1KcJ7fKcl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGjIo0T3Oqt9AH4aERAtXpAJ48Pu2RtcPfl8E0PER8R6N4IEFmrwCdEfSS
XLQ+C0BFLplpqthRpb7rMSA=
=C1eV
-----END PGP SIGNATURE-----

--nextPart1298232.k1KcJ7fKcl--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
