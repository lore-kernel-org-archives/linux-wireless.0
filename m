Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59939 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbZGBTgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 15:36:06 -0400
Subject: Re: [PATCH] orinoco: fix printk format specifier for size_t
 arguments
From: Johannes Berg <johannes@sipsolutions.net>
To: David Kilroy <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1246562805-9785-1-git-send-email-kilroyd@googlemail.com>
References: <1246562805-9785-1-git-send-email-kilroyd@googlemail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EFBaYrhp6e3+qwSRmThL"
Date: Thu, 02 Jul 2009 21:36:10 +0200
Message-Id: <1246563370.16770.49.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EFBaYrhp6e3+qwSRmThL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-07-02 at 20:26 +0100, David Kilroy wrote:
> This addresses the following compile warnings on 64-bit platforms.
>=20
> drivers/net/wireless/orinoco/scan.c: In function 'orinoco_add_hostscan_re=
sults':
> drivers/net/wireless/orinoco/scan.c:194: warning: format '%d' expects typ=
e 'int', but argument 3 has type 'size_t'
> drivers/net/wireless/orinoco/scan.c:211: warning: format '%d' expects typ=
e 'int', but argument 3 has type 'size_t'
> drivers/net/wireless/orinoco/scan.c:211: warning: format '%d' expects typ=
e 'int', but argument 4 has type 'size_t'
>=20
> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
> ---
>=20
> Thanks to Johannes for pointing this out.

Thanks for the fix!

johannes

--=-EFBaYrhp6e3+qwSRmThL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKTQwlAAoJEODzc/N7+Qma1RYQALuebJhUh7zuRpZ20Yvg94UE
dg2Y48FYLBxovP68YDzSF+h8BO5UgROIZak40jDxNDtu1IqqR6hkGdw8d7cDgJ6z
6JVspNSdvg7Gk+WgeqQDunW4YcuIHaIVMHINPT9QD6ye15pX2YOi8ytztg88TSCX
obeAkoX/pGp1CiDg5MpbSUPLgF0ZKNoO2uM8VmJ7LVW6GdCVU/WXVGz5HS0GaLP0
5JGY8EiCJwWvNjn6SnnnxoBOTBKeu+QwpLergM4t890kz5J2Me04TmvYWhjcrWrg
1M8/t9Jy7ttgWbPpmALHdkjRDk7Z+ywyr4mKQHg2vZaqNOGJ/0ZOITrENPi2T6fH
IZmuOv+kjcAIO4eYUYnB1GfhRqrDFtV4C9YUoIJGEc1tTCC7Rh/fGM7aqjYPkqmA
HnIYCB5kVUxfuUycMm91QJg60y6t3P3GHISUkuYGEdEbY/my24ErYuP2ek2l8kik
saYTtz+p06vzhS14IR5pv5hSq5ahWeXI1BdPyVAkQceYr7MP32+pTsjYrc6H/rnU
RqKXZBWWJgoWPfyekbv8EWpfX7g6rY6u2bHzIqgF3R8oOxmY0OaVUsOoc6ojwPGC
UiNw/FPoc1lwANwf0t+mgHtnN/WsqMknrlPrA/mpRKLV6WF2EVi80gDzav7MfNgU
zq3zs7OOcF3xqk7/Hh3P
=DYCk
-----END PGP SIGNATURE-----

--=-EFBaYrhp6e3+qwSRmThL--

