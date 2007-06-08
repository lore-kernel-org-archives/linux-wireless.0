Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:50044 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754778AbXFHFGF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 01:06:05 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH V3] mac80211: Set low initial rate in rc80211_simple
Date: Thu, 7 Jun 2007 22:05:21 -0700
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <4668c71b.E0vXnFMnxxm8I5gE%Larry.Finger@lwfinger.net> <200706072038.36708.flamingice@sourmilk.net> <4668D1BB.40705@lwfinger.net>
In-Reply-To: <4668D1BB.40705@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1193994.ljxoNYFWvd";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706072205.27902.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1193994.ljxoNYFWvd
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 07 June 2007 20:49, Larry Finger wrote:
> Does mode->rates[0].flags automatically have IEEE80211_RATE_SUPPORTED set?
> That wasn't clear to me.
>
Yes. (see ieee80211_prepare_rates)

-Michael Wu

--nextPart1193994.ljxoNYFWvd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGaOOXT3Oqt9AH4aERAv8IAJwInPJuASZweZ2kzvkSjQngpbzSxwCfThXU
h/cMgDULNpmMfYDOubjgN7w=
=7ZtQ
-----END PGP SIGNATURE-----

--nextPart1193994.ljxoNYFWvd--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
