Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:29347 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161369AbXDKW7m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2007 18:59:42 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: mabbas <mabbas@linux.intel.com>
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and association
Date: Wed, 11 Apr 2007 18:56:51 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Jouni Malinen <jkm@devicescape.com>,
	Simon Barber <simon@devicescape.com>
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com> <200704111630.06160.flamingice@sourmilk.net> <461D5FC5.5070404@linux.intel.com>
In-Reply-To: <461D5FC5.5070404@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1186853.QFNyqI7QHb";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704111856.55885.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1186853.QFNyqI7QHb
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 11 April 2007 18:23, mabbas wrote:
> where i can get mac80211 userspace mlme?
> Mohamed
It's wpa_supplicant with mlme code turned on.

Git repo: git://w1.fi/srv/git/hostap.git

-Michael Wu

--nextPart1186853.QFNyqI7QHb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGHWe3T3Oqt9AH4aERAja6AKCnTVCqTnOOeyMyVeHVLx5VLvM91wCdEbJF
GBZgdxREx47V6woUC3eA6bc=
=crG7
-----END PGP SIGNATURE-----

--nextPart1186853.QFNyqI7QHb--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
