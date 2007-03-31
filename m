Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:11257 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753170AbXCaPjd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2007 11:39:33 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: mohamed <mabbas@linux.intel.com>
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and association
Date: Sat, 31 Mar 2007 11:37:19 -0400
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Jouni Malinen <jkm@devicescape.com>
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
In-Reply-To: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8280531.ca2BLHECuS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200703311137.24379.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart8280531.ca2BLHECuS
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 26 March 2007 07:38, mohamed wrote:
> Add basic support for IEEE 802.11n discovery and association.
>
> This patch adds support to discover IEEE 802.11n AP and enable
> association to 802.11n Network. It parses beacon to discover 802.11n
> IE and include HT capability information element in Association Request
> Frame.
> It also call low level driver with the HT capability available during
> association.
>
So.. what happens when the user is using a userspace mlme?

-Michael Wu

--nextPart8280531.ca2BLHECuS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGDoA0T3Oqt9AH4aERAj8AAJ9d3Kk0nXK8dDHPsPfl8dMFztRQ6wCgrGlW
7Ce8mEXdlC5Fo9iHFLGIy8U=
=tdrZ
-----END PGP SIGNATURE-----

--nextPart8280531.ca2BLHECuS--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
