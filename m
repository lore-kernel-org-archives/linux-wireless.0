Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:25551 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754306AbXFMG4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2007 02:56:35 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: David Lamparter <lists@diac24.net>
Subject: Re: [PATCH] cfg80211: use nl80211_* enums
Date: Tue, 12 Jun 2007 23:55:35 -0700
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <20070611221224.GA10598@charon.n2.diac24.net>
In-Reply-To: <20070611221224.GA10598@charon.n2.diac24.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3025471.xIL7J02ekR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706122355.36078.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart3025471.xIL7J02ekR
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 11 June 2007 15:12, David Lamparter wrote:
> @@ -3,6 +3,7 @@
>
>  #include <linux/netlink.h>
>  #include <linux/skbuff.h>
> +#include <linux/nl80211.h>
>  #include <net/genetlink.h>
>
It seems to me that cfg80211 shouldn't depend on nl80211, so the=20
nl80211_iftype enum should be moved to cfg80211.h and become cfg80211_iftyp=
e.

=2DMichael Wu

--nextPart3025471.xIL7J02ekR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGb5ToT3Oqt9AH4aERApMOAJ9Q5sqq1Pjnu5mQxNF22K6THuv90ACeMQ/v
RFOLLkkSux+1h7X7z6ifoBA=
=oiUR
-----END PGP SIGNATURE-----

--nextPart3025471.xIL7J02ekR--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
