Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbZFWL2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 07:28:12 -0400
Subject: Re: [PATCH 1/2 RFC] cfg80211: connect/disconnect API
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <20090622170409.GB30147@sortiz.org>
References: <20090622170409.GB30147@sortiz.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VWN3zrFqW3jihtLuO67Y"
Date: Tue, 23 Jun 2009 13:28:12 +0200
Message-Id: <1245756492.4184.45.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VWN3zrFqW3jihtLuO67Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Also, something seems to be wrong with the IEs:

hostapd says:
STA 02:00:00:00:01:00: No WPA/RSN IE in association request

and the client gets:
[  469.426983] wlan1: RX AssocResp from 00:11:24:91:07:4d (capab=3D0x411 st=
atus=3D40 aid=3D0)
[  469.428119] wlan1: AP denied association (code=3D40)

johannes

--=-VWN3zrFqW3jihtLuO67Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKQLxIAAoJEODzc/N7+QmaXQ0QANFnp3UcfLz9YuTf8KTb2bDc
HcCJ5zeiw3Bp/XpdBs/PD9SIp654p9+Nwu1a3/h3Bsd/fsZxsdbMqfN1K3ra1tkG
C4XrcTgQgPNXBdJ1AdOGBLHLNhV8VsaBPteY3dIyWaFp/YUpRBpwMsg6l6l51mPK
lvQoc0f8uEc+n/Dv7AlTKSDvJ6mtS+EjTKuNNhavs/DghymqdSLEVkVl68PBxcQC
5JPuTWJN0Y4gPF+J9LWBiao3YO12alSJM6ZjVG51tRBc8eSzPBfXULAo2FSItvtL
WE/oxZeAChh78r04hn+AXbFCs8hv4s4iRU5UJsiv356+teUqbjuqmACxF81r2AnJ
ODCXbZFxkxBcwu4HoFvUy2494DVlv9IhoPZibhSj+qyHSzgK2T2JQOCtFYrY8G1X
QyWoWBa8wyGhrcT6/oRi0UcUbaXFzAEQd+9P1enyb4s5Mv5L4Bz7iHWK71hIVJYd
hAnbbIkW7t3CN5JNbl6wIvCxhhhds1OOkxXo3vkraTTMfocH2JULDP0R5vGTeoLY
TDFcBsS04UpFsHQLft/M1dhiMXXyO1aXDB0M9f0prv2idlLuUcSAFncgOklHL6Z/
CjsrMczy5xiHMCGrROy8m9C4ZMbQTRaYulZA8JXmFpQtaHuVKXvRZyGLhP/sttLB
IcAM02sUTPkZSDUzpamB
=MUDo
-----END PGP SIGNATURE-----

--=-VWN3zrFqW3jihtLuO67Y--

