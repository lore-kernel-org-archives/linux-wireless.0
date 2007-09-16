Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:58202 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750709AbXIPFBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Sep 2007 01:01:12 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: David Miller <davem@davemloft.net>
Subject: Re: Please pull 'adm8211' branch of wireless-2.6
Date: Sun, 16 Sep 2007 01:00:37 -0400
Cc: jeff@garzik.org, linville@tuxdriver.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
References: <200709152017.02646.flamingice@sourmilk.net> <200709160047.45128.flamingice@sourmilk.net> <20070915.215053.74746915.davem@davemloft.net>
In-Reply-To: <20070915.215053.74746915.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8097998.hlQ87qHbmv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200709160100.48055.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart8097998.hlQ87qHbmv
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 16 September 2007 00:50, David Miller wrote:
> From: Michael Wu <flamingice@sourmilk.net>
> Date: Sun, 16 Sep 2007 00:47:40 -0400
>
> > Huh? How does a driver use NAPI if it can't pass a struct net_device?
>
> It is now managed by a struct napi_struct which you can embed into any
> object you like.
>
> NAPI is now totally disconnected from the network device structure.
> This was necessary for proper support of multi-queue cards.
Ah, very nice.

-Michael Wu

--nextPart8097998.hlQ87qHbmv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBG7LiAT3Oqt9AH4aERAlQBAKDYllqzSaN4FMKHcWt40T3P4aDFkwCfZZQD
+Iw30pC/cd2UBldOSQLSEwI=
=cYB4
-----END PGP SIGNATURE-----

--nextPart8097998.hlQ87qHbmv--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
