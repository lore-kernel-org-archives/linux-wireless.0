Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789Ab0AFVv0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 16:51:26 -0500
Subject: Re: [PATCH 2.6.33] mac80211: fix skb buffering issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Backlund <tmb@mandriva.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4B450004.9050601@mandriva.org>
References: <1262710858.28653.5.camel@johannes.local>
	 <4B450004.9050601@mandriva.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KcKtDCFzM9l+gzFTfJp2"
Date: Wed, 06 Jan 2010 22:51:24 +0100
Message-ID: <1262814684.4437.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KcKtDCFzM9l+gzFTfJp2
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-01-06 at 23:26 +0200, Thomas Backlund wrote:

> With this patch applied to 2.6.33-rc3 kernel crashes at boot...
>=20
> I have a iwl4965 connecting to a wpa2-psk encrypted network, arch is=20
> x86_64, distro Mandriva Linux and the kernel has preempt enabled.
>=20
> Am I only missing some patches, or did I hit a real bug ?

It'd help if you said what crashes and how since nobody else seems to be
having that particular problem with this patch.

johannes

--=-KcKtDCFzM9l+gzFTfJp2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLRQXZAAoJEODzc/N7+Qma2+8P/ROYHdQ7/g1YVaD7zeAwLSIm
pcdb3fGuLD9E9d+UlwmbFW3/C5QhqbrslKf5fHreXxsfZ98UYt4fjZ6XACJsW10a
zoZrO/vsYF3TY9jRRvkgzUE+aUmr8ZqOvVOxodKHlcIaDLOIzqziwL2bKft7386U
8W2dTnBhC++0gRdkN3vf5WSvtu1zvCQF5WOPRpyGhhmPVLN6B4T5K8fMhjxdAZK3
Qo2nVA71B/C8Uir7QRtDP1mJGatJ/LVPjYoBZUslNpFqpm/nF5fDvaiKctXXdXOU
cGvjH+4ELl/YTXOTkq8WVwKL1JZKDxSG/o34j6zmf/3c76pFAsuTrl4EenthzAry
7x5cffE3/im2y61pEbQ4ht/4rGxJv//oG42ucEMy2LFMeh3EIE8C9aA6IxS+dOZq
JU6I5PWiveYuyjAfwHJLK8e8m6eGcU7TyeKpII8afGJUeRHGQ8wb2t+NUgpm2FNo
USznLF7Hi7oVlnqFiYIzD/rh41TzKQ8pvxK2Nf3pWDdjjdeQ/m11xLmuvc0Jjoi/
/6EOCbHsE4bnpAhsh5Rr1VI3Ll4ifQe7gjy2fnBFtE0OjBAcZB1o//woSAG3o4xK
169/uV3fX1GMHr0i0alK8xNGaUV739l+UScuT80gJ+KDjO2rHz3wyjSqqvAECn0l
HTOsQ/XbhIKIHYj6OihF
=nOiS
-----END PGP SIGNATURE-----

--=-KcKtDCFzM9l+gzFTfJp2--

