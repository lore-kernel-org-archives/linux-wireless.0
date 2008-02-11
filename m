Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbYBKMWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 07:22:24 -0500
Subject: Re: [PATCH 10/13] o11s: mesh discovery and peer link establishment
	support
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1202518689.7025.59.camel@localhost> (sfid-20080209_005705_806985_310BEE6C)
References: <47a78292.22528c0a.1300.1aef@mx.google.com>
	 (sfid-20080204_212438_516087_6199B5A8)  <1202346788.9965.95.camel@johannes.berg>
	 <1202518689.7025.59.camel@localhost> (sfid-20080209_005705_806985_310BEE6C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-34SS6mhm/pO0+6M4FXi9"
Date: Mon, 11 Feb 2008 08:53:32 +0100
Message-Id: <1202716412.11481.14.camel@johannes.berg> (sfid-20080211_122227_493630_E15B2D60)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-34SS6mhm/pO0+6M4FXi9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> We definitely would implement security in user space but have not
> decided yet were to draw the line. I think that it makes sense at least
> to have path discovery in-kernel, since there is a lot of activity on
> them (each path is rebuilt every few seconds and there can be many of
> them) and many path discovery frames just need to be forwarded and do
> not have to be transferred to user space.

Sounds reasonable.

> AFAIK, it would only be necessary to move part of the peer link
> establishment to user space. Path discovery takes place after the peer
> links have been established.

Yes, ok, that makes sense then. I suppose we'll then have to "rewrite"
the peer link establishment in userspace once we want to work on that
but I think it's fine to have it in the kernel too for basic mesh
functionality, we need to shake out the userspace MLME first (though it
shouldn't be too much work any more.)

johannes

--=-34SS6mhm/pO0+6M4FXi9
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6/++6Vg1VMiehFYAQLuvxAAl9LbdWimm/iOz59u7KCA00FFBJakC1YH
LKZmt9VXp7Z+96gIKZWGpmsgadJ6+QDxMcETIcoQg/Riq8gtam8kcyTaLb+GsxQT
rDtNtZ1u8JVDAtQGxiMMcqzecy8lJf3kkKkut/tAl7CtTPePmTQVfQK4fbtwfQ/k
L5JHCcPWA1IVWLCYZPPojQyfHj9Iq4dr4hQNI9SXu3HumniVQ1HsgR8Mgp0wDPG8
ZvPaS8LEBaqfqMCfzsXdk69GuMfPeGMCyl5FPVlyGjHfxb+VtseNlazewSgeGnsZ
Wl/2IYtcM1F/mnoVCBef2S4CzPAYGAmZI6LqsgarTfqEc2ui7FUsrB+1MBP8B5/N
70GbR1wO0lzS0mBcRW4u0d63EHrggwRgLnzu56E+j/LoufYKmoDZvg8SETLaIuhh
QTfDZthuaFTxx3dalA3ThuBwMZE8ZJ3qJhac+onQSF9VIHvFA/favXmGEjKFfSgR
FEfF8QelHzIV5u7rI1hNWEkA36NhMMOpe0wtskUiQt3RiyEJ1Hq25FUNlPL9xRjU
8ndMfBEYgNzYwOgrSRtvhjt3S3MsnG0m6fHnMLCE4jqVGLuMxIJBksbfiAks+UPV
NwG3ZMVLAWJIH6ThqT9rZu6tCmqcdk+QLglu19/khkuJ/2oCNLSFcBr7Os2DXA9I
NAIGKfJkcaA=
=mmSo
-----END PGP SIGNATURE-----

--=-34SS6mhm/pO0+6M4FXi9--

