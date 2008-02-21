Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39785 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYBUTYx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 14:24:53 -0500
Subject: blockack sessions vs. sta removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vwxWWAm/y0c0Ff7ZKzu4"
Date: Thu, 21 Feb 2008 15:17:43 +0100
Message-Id: <1203603463.4462.1.camel@johannes.berg> (sfid-20080221_192506_247976_9BB07AC6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-vwxWWAm/y0c0Ff7ZKzu4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Ron,

I was looking through some kernel oops with removing a driver
(unregister_hw()) while an AP is active and noticed that we don't clean
up, i.e. call ieee80211_sta_stop_rx_ba_session(), when a sta structure
is deleted. I think that's a bug.

johannes

--=-vwxWWAm/y0c0Ff7ZKzu4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR72IBqVg1VMiehFYAQIpjA//YytMIBalo1pvZSPhPFZuqkw3KNWTIyEY
WxovRUlSzDuu/M8zSU1fdqPM3QGiU4l6gQRN5WJSrYWxyY2b2eBNeo/nn8Ma58IG
aNu5se2V9b8srmenZfm4+WeD0gmsGSkBoSn3RAuAOV+cnVYiEr0j7GaNvqo+zqEc
BsIORlEjMKAJfwpD8JUdGIRAG4q6/hVruY+rCSpo+QSx3QWb8dQ1SSTbTPRLPJn1
m9xeFcetFG1WxyHMnMyHuRbHJTJE/1vazLBOBHbFylHFZJ7fpPpfWxjKtLsbiy9+
Vfz74aWG/h5xLVA3dUurH6YGYJo5EsBZuUIfhJ+VgDyjI8pKDaXhXvaKDQ5/uUb7
aVu0EcPZStXx4e5oGSxTAq/EnnCnLzG1ql+g3FyiR5wiObxPl9+QhrIDL+YKo+q6
F7Yada0oHiLgUn4T2LdUTjHIgTnP5+zR7t4L4zdX1s/ENITAjVq0VhWVlJfbAIsQ
4WNfzUjuJNLfYV8K/ry4yWCI7aKUnTYsLj3M1kDUXeJjUV8VKSDPKU94RFKU2M9v
XRU3AxOKkeYgJLXn010Srp34x0CJFvU5bNOtv7DTNUGpEUgbkiPjC2ASyBe+jlcz
m2UeKfSOmpGsKbPtWiLve6I3tAXYAXAQgoQ3qKWxAzfx6J/+d6zLXiJJMBZ+U6m+
0T6lNWaZK5g=
=dYCL
-----END PGP SIGNATURE-----

--=-vwxWWAm/y0c0Ff7ZKzu4--

