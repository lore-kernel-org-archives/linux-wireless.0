Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:21201 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751806AbXFUGgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 02:36:49 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Hong Liu <hong.liu@intel.com>
Subject: Re: [PATCH]mac80211: add support for iwlist channel (3rd try)
Date: Wed, 20 Jun 2007 23:34:57 -0700
Cc: Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <1182391628.27548.8.camel@napa-sdv1.sh.intel.com>
In-Reply-To: <1182391628.27548.8.camel@napa-sdv1.sh.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1811155.kpzJVc6xXZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706202335.03580.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1811155.kpzJVc6xXZ
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 20 June 2007 19:07, Hong Liu wrote:
> Add supported channels info in SIOCGIWRANGE implementation.
>
> Signed-off-by: Hong Liu <hong.liu@intel.com>
ACK.

This should go upstream.

Thanks,
-Michael Wu

--nextPart1811155.kpzJVc6xXZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGehwXT3Oqt9AH4aERAv+eAKDXwE/GPBISaOCTNqdPMs8gSlgAEACfe/uP
KWnPKYqPHzxMp65rgd120L8=
=ST1x
-----END PGP SIGNATURE-----

--nextPart1811155.kpzJVc6xXZ--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
