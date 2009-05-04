Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47678 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbZEDK1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 06:27:37 -0400
Subject: mesh parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8LjgNOUeXRMP4twRpw32"
Date: Mon, 04 May 2009 12:06:41 +0200
Message-Id: <1241431602.8683.13.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8LjgNOUeXRMP4twRpw32
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

I was looking at all the mesh parameters and I'm not exactly happy with
the way they are implemented.

Can you tell me which parameters are actually changeable while the mesh
point is operating? I would like to change the model to be more like the
IBSS thing I did in nl80211 (keeping backward compat, of course).

johannes

--=-8LjgNOUeXRMP4twRpw32
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ/r4uAAoJEKVg1VMiehFYE7wP/AjunWLa1tmEr6Ez3gDJ6yr/
Hd9ouMHKE5y5H2PsSx1i4DwhTjfCTjk+1T7VB2IjjuuDT8LFenUW3WLuFZRq+OwJ
uS1K7EpvbpYUxtSGc452/q9yWoc9eJxhJ57Dp13kX0Jbfo21AHiKB+yC7Vz5lcNc
EcFYwWlwXjudNqNYZMfrLquBjpr8/2Xy3RRI3I1iV4Kk8bFFIv4ZF4dpTaO/qlRP
cKEf0SkQrkD0pp/ZZbvFPjH9eFLEUMIqkXebW//GC2RqNXRwYPQ//JFC5aoCONKf
pUPi0H2z95QKR5h3NlsuQ6BDEs7XSDD5DjdMWMQB17RF4qQonOrkJ0+sDKzl3eiP
31zdfzBsgnipeEnDt4ZO455dNhaCbL2rcb9dw9/4mdFccoqAubB+hcxDk7Jqp1xD
b8dtwBA3biiegp35KCP9rz08JIFWWxq3CEKz3PzT+QRwZnntS0CPy8DgpCb0fe7j
54Ue0AJYDUUWy39CyagWU9g3REv0zCXWpAnuiRk6oR9ehee/riR1I37hjiSROsv2
cJcfvwt/Vw/hK+LIPZTv34h/lIOEJ5ugVLtdhm6dlhBoJnoR748f+TxACJZ/VvQl
8xJ+rFw/ZDFl7mQ/ylmNbLXjr7Hwe+zUH+BQexLJzi3ggkzX6Cbs3j7z2IjqnE/f
uHydE/T9sPAx6YctXIXc
=EoD/
-----END PGP SIGNATURE-----

--=-8LjgNOUeXRMP4twRpw32--

