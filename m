Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:38116 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932470AbXCVXTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Mar 2007 19:19:33 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 0/4] Try #5: Radiotap on Monitor Mode interfaces for rx and tx
Date: Thu, 22 Mar 2007 19:10:30 -0400
Cc: andy@warmcat.com, linux-wireless@vger.kernel.org
References: <20070320103955.600509703@warmcat.com> <1174502809.3944.36.camel@johannes.berg>
In-Reply-To: <1174502809.3944.36.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3681876.jLAWxxaL6S";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703221910.36705.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3681876.jLAWxxaL6S
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 21 March 2007 14:46, Johannes Berg wrote:
> If the driver does not support radiotap, ieee80211_rx_monitor needs to
> expand the head for each packet. Currently, this is also true, but since
> currently no non-management frames are sent down the management
> interface, this is not an issue. If each data packet needs to be first
> reallocated though, it quickly becomes a problem for low-power embedded
> access points running hostapd.
>
That's why drivers should be modified to support radiotap.

> Additionally, the overhead of tacking on radiotap headers to each
> received frame is also rather high if you're only interested in
> receiving the information for management frames.
>
It's really not that much overhead.

-Michael Wu

--nextPart3681876.jLAWxxaL6S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGAwzsT3Oqt9AH4aERAs+cAKDDtlTknHbkwciWZMtG552pcoSsFwCdEtcu
7W2kGiGTJ2oAUsR5FR/PNlc=
=kIL3
-----END PGP SIGNATURE-----

--nextPart3681876.jLAWxxaL6S--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
