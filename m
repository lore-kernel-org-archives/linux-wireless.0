Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:15701 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933257AbXCKGv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Mar 2007 01:51:27 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] remove dead header junk
Date: Sun, 11 Mar 2007 01:51:39 -0500
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jkm@devicescape.com>
References: <1173112674.6131.93.camel@johannes.berg>
In-Reply-To: <1173112674.6131.93.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1844334.Pz19RNIuoI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703110151.43475.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1844334.Pz19RNIuoI
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 05 March 2007 11:37, Johannes Berg wrote:
> -	PRISM2_HOSTAPD_SET_ASSOC_AP_ADDR = 11,
FYI, this breaks the compile of the devicescape driver for hostap.

-Michael Wu

--nextPart1844334.Pz19RNIuoI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF86b/T3Oqt9AH4aERAhlqAKDDO/kePVxL8T1Lu+D3mKOUFiGHKACdH7qA
JFHqKtar+vlw7k+vRqxR8kg=
=7ARo
-----END PGP SIGNATURE-----

--nextPart1844334.Pz19RNIuoI--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
