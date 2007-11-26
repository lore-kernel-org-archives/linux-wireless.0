Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60227 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853AbXKZRBf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 12:01:35 -0500
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
From: Johannes Berg <johannes@sipsolutions.net>
To: drago01 <drago01@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <474AF99C.1000806@gmail.com> (sfid-20071126_165146_643243_B8D34510)
References: <47494851.4070504@gmail.com>
	 <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com>
	 <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com>
	 (sfid-20071126_145009_936981_8E94FA2D) <1196092359.4149.278.camel@johannes.berg>
	 <474AF99C.1000806@gmail.com> (sfid-20071126_165146_643243_B8D34510)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-kVArED5Noyfl8cJqjLDF"
Date: Mon, 26 Nov 2007 18:01:26 +0100
Message-Id: <1196096486.4149.313.camel@johannes.berg> (sfid-20071126_170204_853343_8C3B3702)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-kVArED5Noyfl8cJqjLDF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> looking at the code seems not:
> ---
>     if (ieee80211_wep_decrypt_data(local->wep_rx_tfm, rc4key, klen,
>                        skb->data + hdrlen + WEP_IV_LEN,
>                        len)) {
>         printk(KERN_DEBUG "WEP decrypt failed (ICV)\n");
>         ret =3D -1;
>     }
> ---

Huh I thought they were. Of course they need to be rate limited then.
Can you send a patch?

johannes

--=-kVArED5Noyfl8cJqjLDF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0r75KVg1VMiehFYAQJTtg/+OImObw6WZJniSJFddda8izPbetjQPYoD
poXIGlVQasjA+nhAjPG5G80HDlFghh691F0+sjRKEiwokM05qtMZ5d7OvCaGygo9
r1HdQ0oj6f/z/mVRkyeCoYBHIlQlQvDmRjErffBTC69LC1KR7ZRRW2WKkrZIorPd
LUMyay1BLmaGJeeKQ+gB0HMSit5ScITsB4j9Rs0GsXT8MqMKcaAW9Dai5+YcfKDV
2H9qUYMQChU/7IqgReAzaprPrNeXQbwWkzo0srzcIDGoaJYKo9CE9RxkMGRnB0BP
9rnj2x5VTROya7Ph7f//Mhn1Cgn4xVEicJM6A162U2AzhP+usj31Uc6MYMxm3jts
iwWjcWa3UW1ZxF4cLuvvPKpcOciyyO6Tiy2uO5EoFUU8Y9WB4uqrT8QTEAe0551T
ptGFrtOvjdjOSy2Ida83b09C/vqZy3fSI5x68q++dPMQjiIi0wkN6Y8TTlU4bJ2j
HBqijwJrnh04BfGmKOF8CTS69rrgVBgcd4EIO++8xo/7PeRHp5KpyoNoZ43QXiVJ
gZqLG4zVsqxlVifU8UK60pCJclPypl19bX7FqpVJLycwRCU/O4Mh+hqlNc+JeUau
Rdk5KY9YDU5B+PMKn5KALOM2vOHOvXSqm3eY9CiIVgLh7pQiHvGgWNJXocqKV/Ah
mdrsKX8Ofms=
=851+
-----END PGP SIGNATURE-----

--=-kVArED5Noyfl8cJqjLDF--

