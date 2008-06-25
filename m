Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42136 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYFYRI3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 13:08:29 -0400
Subject: Re: [RFC] rtl8187: Realtek 8187B wireless support with product
	id0x8197/0x8189
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry.Finger@lwfinger.net
Cc: linville@tuxdriver.com, hintak_leung@yahoo.co.uk,
	linux-wireless@vger.kernel.org
In-Reply-To: <4862796a.pmrQX9GXIZ1wDm2k%Larry.Finger@lwfinger.net> (sfid-20080625_185832_411910_F133FFF7)
References: <4862796a.pmrQX9GXIZ1wDm2k%Larry.Finger@lwfinger.net>
	 (sfid-20080625_185832_411910_F133FFF7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Y3vfHKtG54PXbBS6aD8K"
Date: Wed, 25 Jun 2008 19:07:16 +0200
Message-Id: <1214413636.21847.41.camel@johannes.berg> (sfid-20080625_190832_840698_430EE38C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Y3vfHKtG54PXbBS6aD8K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> - control->queue, which the herton's change used, for switching between 4
> tramission queue at end point 6,7,5,4, has disappeared. I hard-coded 6 in
> this version, (see commemt #37 for background), but what's the correct
> way to do this in current wireless-2.6 code?

We switched to using multiqueue netdevs so you have to use
skb_get_queue_mapping() now.

johannes

--=-Y3vfHKtG54PXbBS6aD8K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIYntAAAoJEKVg1VMiehFYBGkP/3LUPdDThwFE83jXL9ZhwftZ
lcpr+T/GE5Afs0jh6kdItyUqNb8bcyKNAq9uGxv/UuPVVgD/9GS6hOT/KzpqCIr/
v8e0xJG5VIOdlG+LCTLKVxkycntrUScgLZMQA6NPAI28YcwjHFIS91Pxa3i1sgI7
ydbwKYi/GULXLPnhz+JPtz95eLd5g1syjvsBbd8pKt/XTeKHxJijaIKV8nWn6+Cp
VqUe+IbplPlD6Oibxg+2e2uz7muIYDzRGvWOU+q9NjkZPTUBs40Nj7ws/goYJGJD
Zv/eSSF6GyyPkPnDXBhRzq8/90ZI2nE8OXgea2+cg1OEXNQZpx1qtaLSRX+M1smc
G52mwpgmKCsGeVs+GXvFFVQhOpzsVxeVTkHqrWo7rX3cDaYiufEG2VPHeb7Xk0y5
YE7TYwR1nvmbzJcYH6hU8oPtI73w6hW1B2TrVjtb2b+86f2JbCzIj6KMwTx/Hf49
0nngLu9KgmXMh0IvsioGwRvZZwcRQCb5B/MmMDvWFk7Bfm40poaAAxPE2VR9P0du
vyR1+TNjC1+Jw7nyypyeRAaULP8578450FOhP5m665M+Fs19IMsJcmKsSSwuz1Fw
rGlTjRYhF31/82qIm3/GDG6vPWh4nGxOB70wJnGvqoSLWByIH4se06sQmU9zZHuf
l6vRAT7h6nqPQkJtAjGb
=xutw
-----END PGP SIGNATURE-----

--=-Y3vfHKtG54PXbBS6aD8K--

