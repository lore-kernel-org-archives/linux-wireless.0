Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57680 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZHRSID (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 14:08:03 -0400
Subject: Re: [PATCH] rt2x00: configure_filter() callback is allowed to sleep
From: Johannes Berg <johannes@sipsolutions.net>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200908182004.58584.IvDoorn@gmail.com>
References: <200908181954.23419.IvDoorn@gmail.com>
	 <1250618324.9886.25.camel@johannes.local>
	 <200908182004.58584.IvDoorn@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Q1d1M+81r9+seqhm6FXt"
Date: Tue, 18 Aug 2009 20:07:33 +0200
Message-Id: <1250618853.7887.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Q1d1M+81r9+seqhm6FXt
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-08-18 at 20:04 +0200, Ivo van Doorn wrote:

> > Speaking of which -- bss_info_changed can sleep too, which means you ca=
n
> > remove DRIVER_REQUIRE_SCHEDULED completely I think?
>=20
> Seriously, that would be great. Patch coming up in a few minutes. ;)

Cool.

Hey, sorry it took so long to make it possible :)

I wonder if drivers now ever have a reason to queue work on the mac80211
workqueue? Some periodic calibration tasks maybe?

johannes

--=-Q1d1M+81r9+seqhm6FXt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKiu3hAAoJEODzc/N7+QmaxhwP/i4c01jlRgSisfQi2MjPJi06
7opa+opqj+fGVooIf8Gk9AWRiATYCo1vazj4aI3oFGctFPO3cIDfMyOhP3jUPKel
gVEGAF/1MVJQ1wFgYCKGDftaug96IUS5altJE5I5MfVk/W2B4oHOViuVDWnHQuQe
antXTGBZTiamxh4xjrw+E+nUpXfbzZ/NmYN9s4X/fQdj/m1HGPDl9SETgJu4Zyzk
AcVET5O+E6aEEoKa48SWoUTAeoXMjHPfc7AenoO4OkWYYhMWuqBW9icmawTf02vL
N3/DaotZB9Gbl9yfU6+1ib68TO1WheDjIfZqPHelgJ2Ku9Y4ZwZX2Eqt0Vq7nW+7
A6lOhmizbBh0JXgtvmnnHZyTrbxKTG67E7ZFSdO0yJEhsltS7W9UiUmVtSP34y6N
pWZNHzK7n3l4/sKyDM9O2ko/nfGubQTKbdvNJ6paTMqwUO11wBeePeuGur/udvlq
XQCXoM1OA9GHoMRgr4gQgO93bYULQx7++earQtkmJha/91dI1KoJxuAm2xfK9sSM
Yhvv3njWtsY8jefpwNV8v1Zf1iI5IIp7mUc4R6gE99FhoqTSKV1DsSbvnCgeb8Zq
iy+LjHr79CPRJndEkmjYQVErmUyEqINAHK3ZtgcGILTsvbV7W8VXAJ72cKa2Fzw0
yT2GHwxz6YpP5MXv/r9w
=U13r
-----END PGP SIGNATURE-----

--=-Q1d1M+81r9+seqhm6FXt--

