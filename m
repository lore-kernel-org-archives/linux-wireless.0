Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:22835 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754261AbXDSX1A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2007 19:27:00 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: [PATCH] rtl818x-mac80211: fix coding style
Date: Thu, 19 Apr 2007 19:23:26 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andrea Merello <andreamrl@tiscali.it>,
	linux-wireless@vger.kernel.org
References: <20070420004258.23848470@localhost>
In-Reply-To: <20070420004258.23848470@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2523837.UIyS7K6HuQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704191923.31674.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2523837.UIyS7K6HuQ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 19 April 2007 18:42, Stefano Brivio wrote:
> Fix coding style.
>
Looks mostly good except for..

> -	// ehh?
> +	// XXX: ehh?
Use FIXME if you want to put in a prefix.

> -} __attribute__ ((packed));
> +} __attribute__((packed));
I prefer the space here.

Thanks,
-Michael Wu

--nextPart2523837.UIyS7K6HuQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGJ/nzT3Oqt9AH4aERAh4cAKCzjlX/P9FS3pXeFAl9emzrv2XxjQCfVHWn
kaku12g4467wrbGu7Jpw4PQ=
=980W
-----END PGP SIGNATURE-----

--nextPart2523837.UIyS7K6HuQ--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
