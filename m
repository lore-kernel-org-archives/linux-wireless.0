Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:29491 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755829AbXHNEXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 00:23:48 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "maali Al Janoob" <mms82@hotmail.com>
Subject: Re: wireless drivers that doesn't require firmware
Date: Mon, 13 Aug 2007 21:21:45 -0700
Cc: linux-wireless@vger.kernel.org
References: <BAY111-F3063D70AED453915236D9FB6DC0@phx.gbl>
In-Reply-To: <BAY111-F3063D70AED453915236D9FB6DC0@phx.gbl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1623818.23S6y84Ape";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708132121.49345.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1623818.23S6y84Ape
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Monday 13 August 2007 15:04, maali Al Janoob wrote:
> Do you know any linux wireless drivers that implements all 802.11 related
> functionalities in software and doesn't require a firmware? The only one
> that I know is madwifi, do you know others?
>

All Realtek chips - rtl8180, rtl8185, rtl8187.
All ADMtek ADM8211 chips (but they're not made anymore)
Some Ralink chips, IIRC. Don't know which ones.

-Michael Wu

--nextPart1623818.23S6y84Ape
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGwS3dT3Oqt9AH4aERApt/AJ9aT76IDC+u43Q+eROCJOTx+0J5YwCffwlE
nTpo0gAqxvIcN29c8ws9oAs=
=DEai
-----END PGP SIGNATURE-----

--nextPart1623818.23S6y84Ape--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
