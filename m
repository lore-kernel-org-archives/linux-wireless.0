Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40618 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbZLPPyJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2009 10:54:09 -0500
Subject: Re: [PATCH] iw: add country IE parsing support for scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, ic.felix@gmail.com,
	=?UTF-8?Q?Luk=C3=A1=C5=A1?= Turek <8an@praha12.net>
In-Reply-To: <1260945398-301-1-git-send-email-lrodriguez@atheros.com>
References: <1260945398-301-1-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ebhdl98os5KkMxdr+hFG"
Date: Wed, 16 Dec 2009 16:54:04 +0100
Message-ID: <1260978844.10356.86.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Ebhdl98os5KkMxdr+hFG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-12-16 at 01:36 -0500, Luis R. Rodriguez wrote:

>         Country: US     Environment: Indoor/Outdoor
>         Country IE triplets:
>                 Channels [36 - 48]
>                 Channels [52 - 64]
>                 Channels [149 - 165]

Can we do this more like

Country: * US (Indoor/Outdoor)
	 * Channels 36-48, 52-64, 149-165

?

Not sure what the "triplets" text buys us?

johannes

--=-Ebhdl98os5KkMxdr+hFG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLKQKZAAoJEODzc/N7+QmaYH4P/ihDFj0bz3G1ANGeRzdzNPPV
xrCSij/mZLKmuzKUCm3FKRxPrcNuKCk09GexVdpDTvkqGj2gN8V+3HRLcYIxvkw/
5JLDEoedtY1HfN1sA/J0h1mpMiDgG3rQHOjjk/R9tlBcxk1mmtVscOXcd9AWw89/
VElTmIfhlvZ7nnmPXoo+OTFHYbd+GFQFPJUQ6LtvB3m7WcHaq+kSVGz3s9U8WsHm
XDPysErZnbRcEDrMeVN06Gr+X9s5yWAucHDqw0vp0SgaNT/J+Lv3Rpg+oUFehPTW
9sBcdb0rdrznt1ocqBJNm2VD8fkY21tSM+R09/hq0zHQQVrexly4dk++w3h+Bokb
ycJp5vpSPD5VikWCnKutHrQT0cF+EgiHtB1QetzbhklfiO4og72Pv66t4ntdrIK1
lubx6AuwCMQOrW0ky6Q4S6LHLRKwYM+ffcyki4PvEuIeqolhdpl8a0vSt2NXyT6R
3sR+fJNA3Hk62YbyVw8gevdpw1s/1DcbYJLMvC7Hb39fw76aqvpVGSP57YsOYlA6
AC7VBI2akEgju4w36rUUd7pPVa2p99H2KVgHC6U4YxFahq2vJZ3eIs/CRal3eeyt
Hd5mSpQ9+BCE+b+CITuID6UneBHtzYXtA7NKPtuAf6Zo3NGCxRzLolRzptRRg9gn
+hycTogaUCz9DncKfdQl
=wNU7
-----END PGP SIGNATURE-----

--=-Ebhdl98os5KkMxdr+hFG--

