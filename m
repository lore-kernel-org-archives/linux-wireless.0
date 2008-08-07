Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43820 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbYHGP1u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 11:27:50 -0400
Subject: Re: [PATCH] p54: Fix regression due to commit b19fa1f
From: Johannes Berg <johannes@sipsolutions.net>
To: Chr <chunkeey@web.de>
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <200808071727.19129.chunkeey@web.de>
References: <489af6ed.hkTX0XTOTIkENssK%Larry.Finger@lwfinger.net>
	 <1218115671.23048.174.camel@johannes.berg>
	 <200808071727.19129.chunkeey@web.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Un2FdFImVZxle/3aoBmU"
Date: Thu, 07 Aug 2008 17:27:14 +0200
Message-Id: <1218122834.3630.6.camel@johannes.berg> (sfid-20080807_172752_748261_FF120A19)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Un2FdFImVZxle/3aoBmU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 17:27 +0200, Chr wrote:
>=20
> +       u32:24;
> +       u32:32;
> +       u16:16;

That piece looks just wrong though. Bitfields, and in a hw struct?

johannes

--=-Un2FdFImVZxle/3aoBmU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJImxROAAoJEKVg1VMiehFYkK0P/3K5xpYSEyQjFio1YmQeStT+
FvjWHN/BxGhvQ0/bHMD8DE08SbUYtprx/FUdHztkcSXMek8IlO4XL+WS1Nw1pW1W
h+ac54Ha7OAIu22wXA7Rrzq5UmmMpz1OVylSBhjYQeBFbakot76+GFYsPxi361Jn
/4gGas2juwZMYc4UKw1ZBQqzB5zNKzvd9eYiw8UrfyDAr4KfwXlEGYpgvN69J0AD
1esvU6Fk9UGV4BWHNIIyAEpJNI6B/69/I3pnXlfY87IZmhmtoKxpL5Sp8hq0buEA
BYnGNBfQzp1bwrKeXNslQMlWFkdQi+6uecgYziXqzDfjwK9ekBqGyGouJPoxISJB
nbJRT8iAwBS+KVih/FBuOgDGVhjIcCWe0dC/igadZHkhy2GM9XQXE0Uct0UVvB9A
BPo19JvdfjnIb+VUNKSeVVUpzhxwgqwnEvlUdoc/bb4fEI+q3dI4HPtB11FBDZRu
n1l8iCSsmgq7fiP6Fmq9wrYjElWxfjM+CWBKtSpUXzR7ewWYDByGvRjj5pPDhOXA
3daHIrVqftgAfc90SbFeaxET1cguWzxBWIhtrXTEyEY+XXfy8KjPUb5UA8YLX6IH
3SSeYICoqtPa3jwjgmpTqz59kL6kDpEY/6BzbHdWHG/mFS2zZWOnFv5g/OPVb5Ib
h+r0+ZgNO++WiSMOcEKZ
=Muan
-----END PGP SIGNATURE-----

--=-Un2FdFImVZxle/3aoBmU--

