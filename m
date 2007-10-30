Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:13533 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752379AbXJ3DPe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2007 23:15:34 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: remove unused driver ops
Date: Mon, 29 Oct 2007 23:11:49 -0400
Cc: linux-wireless@vger.kernel.org
References: <1193670933.5197.67.camel@johannes.berg>
In-Reply-To: <1193670933.5197.67.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1649180.2Pg4c2nVLD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200710292311.54628.flamingice@sourmilk.net> (sfid-20071030_031538_797920_8CBDDA70)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1649180.2Pg4c2nVLD
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 29 October 2007 11:15:33 Johannes Berg wrote:
> The driver operations set_ieee8021x(), set_port_auth() and
> set_privacy_invoked() are not used by any drivers, except
> set_privacy_invoked() they aren't even used by mac80211.
> Remove them at least until we need to support drivers with
> mac80211 that require getting this information.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Acked-by: Michael Wu <flamingice@sourmilk.net>

Let's do this.

-Michael Wu

--nextPart1649180.2Pg4c2nVLD
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHJqD6T3Oqt9AH4aERAqPaAJ9CFGZH6d1oIQN73b05abA4EEbzCwCdGWN1
wqFjlclxr1Z3eEm4j/TJ8J4=
=wuBQ
-----END PGP SIGNATURE-----

--nextPart1649180.2Pg4c2nVLD--
