Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:22883 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S969319AbXHMPul (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 11:50:41 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCHv2] mac80211: dynamic wep
Date: Mon, 13 Aug 2007 08:48:52 -0700
Cc: Volker Braun <volker.braun@physik.hu-berlin.de>,
	linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
References: <pan.2007.08.10.23.31.32@physik.hu-berlin.de> <200708130054.57899.flamingice@sourmilk.net> <1186995283.27916.60.camel@johannes.berg>
In-Reply-To: <1186995283.27916.60.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2397490.8UWUZAqrst";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708130848.53128.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2397490.8UWUZAqrst
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 13 August 2007 01:54, Johannes Berg wrote:
> On Mon, 2007-08-13 at 00:54 -0700, Michael Wu wrote:
> > This part seems fairly evil. I suspect a better solution here is to allow
> > unencrypted frames when the interface is dormant (netif_dormant()) and
> > then we might be able to get rid of the specific check for WEP.
>
> Might that address Tomas's concern with EAPOL too?
>
Nope, this is just for the privacy mismatch check.

-Michael Wu

--nextPart2397490.8UWUZAqrst
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGwH1lT3Oqt9AH4aERAhmYAJwNrRSaOVeP37US8Tahuac36YJ/ZwCgyieL
1imMIGp8WMDNLEzI9NefsAU=
=egPA
-----END PGP SIGNATURE-----

--nextPart2397490.8UWUZAqrst--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
