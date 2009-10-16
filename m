Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58329 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbZJPLhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2009 07:37:19 -0400
Subject: Re: [PATCH] cfg80211: remove warning in deauth case
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200910131345.28395.hs4233@mail.mn-solutions.de>
References: <200910131345.28395.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-20pHizOLwsMa5AcazcSQ"
Date: Fri, 16 Oct 2009 18:32:18 +0900
Message-Id: <1255685538.4095.310.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-20pHizOLwsMa5AcazcSQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-13 at 13:45 +0200, Holger Schurig wrote:
> It might be the case that __cfg80211_disconnected() has already
> cleaned up wdev->current_bss() for us. The old code didn't catch
> that situation and didn't warn needlessly.

Care to explain how that can happen?

> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
>=20
> ---
>=20
> For more info, see mail "cfg80211 / libertas: an unusual race"
> in the linux-wireless mailing list.

Oh ok, I suppose that explains it?

johannes

--=-20pHizOLwsMa5AcazcSQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK2D2fAAoJEODzc/N7+QmaQvEQAJlaFSjth8XpDK0rylxImmn0
NYK8LzEi/mda3XJttsWtRafVMFokhEE2lZ/5PQMBJh7FxLmYXF8sJ3gfj9IwERNo
VU/AR+JQqAFl/ubUgDNxxnwCUgr58x9x4Cl87X06rjfFULCC020G76fPA2OkLxzW
2kqHrQMflUC770MpY03UvKdzwYUFqY3BbxprVwIVIEwtIIkjxBvWkgw19rpAZu+3
JWJsJOu94chn1WzGXEaF7efaN1CXPYEqY7vkVQpWMrSPRo7KZsMqMWF+cOfXwALf
b/wS+tYYcKj42haVD8UrzYmkybCqRGxmnRAo4a1k0H0KUUARi55y2wkM6WUlaLVg
V17U7pqrTIt3ep/9Cme5SK+WiuENW/wl/hdzL/xncmkAS/TQurXBM+o+wzJ2NJUL
imtrJVHIEZk+GEJPpwQ+cj5hlmTOYpyDlZduU4cE9+D/s/5XZAEBSR66ovHm2Bkn
Lwo3a6kh1TLhCd0VqBdhxFFBRhkDCSIUH+6WY7ChT2cJ0Zyaj7iJGKN97/fmwB/Q
r0s4YKN+KagFxHfWT8TPoeEMj4kXln+jVmY1GCuswhCGZ7D3+UgamlDma0/3Tl0H
YYIvDtktX20ifKhLP+L95O8XpYPPr6n1XDd2rYpxt5bCAHcUU7wCiObd7Vqaq/nn
mugsbXvVOnvWMjBO70OL
=fQeP
-----END PGP SIGNATURE-----

--=-20pHizOLwsMa5AcazcSQ--

