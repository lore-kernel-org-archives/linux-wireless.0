Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:63718 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752082AbXBWAcF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Feb 2007 19:32:05 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH 2/3] bcm43xx: build failure
Date: Thu, 22 Feb 2007 19:31:44 -0500
Cc: linux-wireless@vger.kernel.org
References: <20070222161014.62d064a6@freekitty> <20070222161102.76a926e5@freekitty>
In-Reply-To: <20070222161102.76a926e5@freekitty>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2275055.1X7aUTjT6m";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702221931.48054.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2275055.1X7aUTjT6m
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 22 February 2007 19:11, Stephen Hemminger wrote:
> Looks like the ssi field changed.
>
A patch fixing that was sent with the original patch that introduced the ne=
w=20
wireless statistics API for d80211 and is already in wireless-dev, AFAIK.=20
(bcm43xx builds on my system)

=2DMichael Wu

--nextPart2275055.1X7aUTjT6m
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBF3jX0T3Oqt9AH4aERAsHZAJoCKSpIVV/gxoE77Kp+OnT1Skl6UACgnRW4
5vxOIBYuNsji8MDVwsagPs0=
=1cgs
-----END PGP SIGNATURE-----

--nextPart2275055.1X7aUTjT6m--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
