Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44251 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbXKLQgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Nov 2007 11:36:23 -0500
Subject: RE: [PATCH 07/14] mac80211: adding 802.11n configuration flows
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	"Winkler, Tomas" <tomas.winkler@intel.com>, flamingice@sourmilk.net
In-Reply-To: <1879838866982C46A9CB3D56BA49ADEB04008799@hasmsx411.ger.corp.intel.com>
References: <1879838866982C46A9CB3D56BA49ADEB04008799@hasmsx411.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-I9g9mFv/Lpu6f7rlsBQr"
Date: Mon, 12 Nov 2007 17:37:40 +0100
Message-Id: <1194885460.5229.53.camel@johannes.berg> (sfid-20071112_163628_201204_E1738D70)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-I9g9mFv/Lpu6f7rlsBQr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> Now, I began to work on a solution for this problem (please refer to my
> RFC "mac80211: [RFC] adding bss_config to low level driver ops"), in
> which I wanted to unite all IE changes into one callback.=20

Oh right, I completely forgot about that, sorry. I should take another
look, or would you like to repost that?

> If Michael is
> already working on a more general solution for all "config" callbacks I
> would be happy to contribute to his effort, or even continue my RFC to a
> more solid patch, but until this will occur I just used similar approach
> to already existing callbacks.

I don't really know if he's working on it and I guess that if he is he'd
take your work as a base.

johannes

--=-I9g9mFv/Lpu6f7rlsBQr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARziBU6Vg1VMiehFYAQKx/BAAnAHmgNtCnNrk7DMd83/l4uSoMZNl5R42
XyL1cnEk77qlbojXFutYxCbfvB9JjEpfFiS+AqkfPWbCp8m1TuGPw6Q1zBIaBWDL
ORO6szHxJjMVbNqKDODjmLM8GNpQSITNWGlgIQpDeagJJlpBto4xe4vC4m0NNbXQ
G675RKR+6sVH+yx3ZAdjEoHoycrJYQ2PDjBryUuAWOsxLRjMWu/zLAZRuaf6bzJM
AXblo6lXtKV90lC2IcLOOKgM6luHXo5Zb12OW5Z+VQPWKW0mL8eUSz1cyHI40bfJ
W5zWlyrJcOdndVle0LfSTOTuFirqp6Xmh5ZJqxDgnXqSjliVDv36xDNg2aQ0hHHm
fQ0zhzVHpXlUkcM61zd1jxkpYi+tzcN2rsSS+N6BwqO4YmAc/zDRrBhMhR5Cpkgz
ZeNBk5YU5pbT0/sgPSJ72sD5r2IXbyL6GL81Y3guIELpjrG6moMqQV1SHHCT1Dvd
yJS8nAHaf+khSNC3H3CW+GA6ZV+NH3GCvYPfW6x0G4fG/6A6dJGUqDfEmX3HgJCQ
m3vdCF++1/WoJLck6h2MeHaOy48BMAjJpDxEYcN327t96XRfWekjnTXrDoipLteW
nbMiCVr3I8Ep1O1M9hfXVTRLZ0X+I+hWk+StaFDYpELTL4VyuSv07zfDGDaCEm3h
hMzQQ0vRn2w=
=0UFN
-----END PGP SIGNATURE-----

--=-I9g9mFv/Lpu6f7rlsBQr--

