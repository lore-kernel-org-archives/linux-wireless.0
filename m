Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:27307 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752126AbYCaTM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 15:12:56 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: is adm8211 capable of sending arbitrary frames?
Date: Mon, 31 Mar 2008 14:38:37 -0400
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1206449800.16475.255.camel@johannes.berg>
In-Reply-To: <1206449800.16475.255.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2683315.lDo0bY5luv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200803311438.41956.flamingice@sourmilk.net> (sfid-20080331_201301_920646_B8DCE361)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2683315.lDo0bY5luv
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 25 March 2008 08:56:40 Johannes Berg wrote:
> Quick question: it appears that the adm8211 driver pulls out the 802.11
> header and instead inserts a custom TX header that only contains one/two
> addresses (3/4-addr header format).
>
Yep. It is unfortunate.

> This appears to mean that it can send neither QoS frames properly nor
> can actually communicate with an AP other than the one it is associated
> to. The latter isn't much of a problem, but it seems that the driver
> will fall over with QoS AP since it doesn't strip the QoS-data bit from
> the frame control. Or does the hardware do that? In any case, mac80211
> shouldn't be announcing QoS support for this driver, should it?
>
ADM8211A does not support QoS.. ADM8211B might and ADM8211C does for sure, =
but=20
that revision was never sold AFAIK.

At any rate, there is no QoS support for this driver.

=2DMichael Wu



--nextPart2683315.lDo0bY5luv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBH8S+xT3Oqt9AH4aERAuM6AJ48uWMwrtrMr+0nhATcR79t2sJZ3QCaAxas
AybBReqRaisznXEncuMxwKA=
=SmvD
-----END PGP SIGNATURE-----

--nextPart2683315.lDo0bY5luv--
