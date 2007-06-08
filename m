Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:33987 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966457AbXFHDjh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2007 23:39:37 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH V3] mac80211: Set low initial rate in rc80211_simple
Date: Thu, 7 Jun 2007 20:38:27 -0700
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
References: <4668c71b.E0vXnFMnxxm8I5gE%Larry.Finger@lwfinger.net>
In-Reply-To: <4668c71b.E0vXnFMnxxm8I5gE%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1474228.qm12186NhP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706072038.36708.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1474228.qm12186NhP
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 07 June 2007 20:03, Larry Finger wrote:
>  	for (i = 0; i < mode->num_rates; i++) {
>  		if ((sta->supp_rates & BIT(i)) &&
>  		    (mode->rates[i].flags & IEEE80211_RATE_SUPPORTED))
>  			sta->txrate = i;
> +			break;
>  	}
Uh, what's the point of having a loop if you're gonna do that? ;)

-Michael Wu

--nextPart1474228.qm12186NhP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGaM88T3Oqt9AH4aERAnAZAJ9bFh1sWaOOknfMVpkb8O0TyQL1UwCeNfQj
duBcUZJ0LgJXlxtirreIegA=
=P0ra
-----END PGP SIGNATURE-----

--nextPart1474228.qm12186NhP--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
