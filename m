Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54979 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbXJNJrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Oct 2007 05:47:53 -0400
Subject: Re: b43: regression on bcm4318
From: Johannes Berg <johannes@sipsolutions.net>
To: Vitaly Bordug <vitb@kernel.crashing.org>
Cc: Michael Buesch <mb@bu3sch.de>, bcm43xx-dev@lists.berlios.de,
	"John W. Linville" <linville@redhat.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20071013181431.13bf50a3@kernel.crashing.org> (sfid-20071013_151459_365523_50FF43F1)
References: <20071013121730.1eef0d93@kernel.crashing.org>
	 <200710131024.48113.mb@bu3sch.de>
	 <20071013181431.13bf50a3@kernel.crashing.org>
	 (sfid-20071013_151459_365523_50FF43F1)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HWdN1yfofUvODygi7w4P"
Date: Sun, 14 Oct 2007 11:48:02 +0200
Message-Id: <1192355282.4770.104.camel@johannes.berg> (sfid-20071014_104755_406975_64027A7D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-HWdN1yfofUvODygi7w4P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-10-13 at 18:14 +0400, Vitaly Bordug wrote:

> Another question: is this driver known to work okay in ad-hoc or master m=
ode? I gave it a try and there is no
> driver-side whine, but it does not seem to work either. I see couple of p=
ackages turnaround, sometimes even
> dhcp server is able to feed IP via wlan (host is acting as kinda AP), but=
 nothing after that.

b43 works in master mode with all my hostapd enablement patches
(johannes.sipsolutions.net/patches/{hostap,kernel}

johannes

--=-HWdN1yfofUvODygi7w4P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARxHl0aVg1VMiehFYAQL/DA/+O6mTu5y/KsphKUAAuCUc3Ry3DE4eeWXF
rEyLUfLd6lLZfYfghBRCckiJW48Iw9GiOXE2nU/vbvuTKkCY0oV9++d3jpdhCJMs
8KeoM3/3LIBOlElCqW/JuloQ0gcFmDOzn0lYtu9d6Xl05HXqav5i/0QdxakG0JGo
kuXcq2R9zD9urx2xJYVMwRhcNWTSmBuCUCpBEnT1UUj1vXtumZqhMIZSsxmA7Gyv
lumpy18REvXN3xs3eWPirGVHXcn53Wq/w2im2ooJvUzcs//bcU5Zj8WhC8I7eiJq
Cp/GsPsDx3nZEyE4iq2jLTTZrm1MfZEQpwH8Arz95wDFVmqFAAA1BMNROSVu+S7y
tL2xCoeN+dEWAvFwkzTaFSLv/BCtue99qnoltYHKkkmZfviBCLz3UeJKzKfE/NnF
7qjKl/XxZF3TH6JkxfiiJbjarEsip/pvaZerQAkOrkC/f2S9fluEBn95I0VkP+dM
SMjfXmrnAKp4Ssz7IlvOQo+riXqhP1yAlbtV9r0tcP27NN8BUA5EzHA+89qD6QhT
wNAae/d9fYfzGw+yWJ0LuiiBuIwypi08wNC24hfEc1eXK5pKMc1VPRA+/Ov3AI+0
6Yw4xktls9VjFTjMhy6tsN35J5geQexL0APAxa4832G1qZwB003uFbbWriGNjdv+
rS7OVImjkQg=
=XVw5
-----END PGP SIGNATURE-----

--=-HWdN1yfofUvODygi7w4P--

