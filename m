Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55573 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYIHHpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 03:45:06 -0400
Subject: Re: [RFC PATCH 0/3] mac80211 dissasociation
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com> (sfid-20080908_011410_000288_CE56DC5D)
References: <1220739259-16918-1-git-send-email-tomas.winkler@intel.com>
	 <1220794765.31304.8.camel@johannes.berg>
	 <1ba2fa240809070724n362d5850t653ca5746b87eb48@mail.gmail.com>
	 <1220798432.31304.13.camel@johannes.berg>
	 <1ba2fa240809070750k1683f410icf2a82be0f533b4f@mail.gmail.com>
	 <1ba2fa240809071614v66235658w1768e31d31c2d0f8@mail.gmail.com>
	 (sfid-20080908_011410_000288_CE56DC5D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9qaFW8ayiIjSgkz9EQ05"
Date: Mon, 08 Sep 2008 09:44:57 +0200
Message-Id: <1220859897.31304.16.camel@johannes.berg> (sfid-20080908_094511_348750_5E83C6EC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9qaFW8ayiIjSgkz9EQ05
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-09-08 at 02:14 +0300, Tomas Winkler wrote:

> In general it works but I didn't test all the corner cases yet. Not
> sure this is related but.
> why I'm hitting unathorized prot messag for subif_start_xmit.
> Shouldn't carrier_off(stada->dev) stop the queue?  I haven't seen this
> before.

In client mode? Then something is really gone wrong, APs always have the
WLAN_STA_AUTHORIZED bit set once we get an assoc response.

johannes

--=-9qaFW8ayiIjSgkz9EQ05
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIxNf1AAoJEKVg1VMiehFYHg4QAKvh4Ixod1IKAj8sNTqNi5WQ
QGc1BLqz7aVtjdkxb2P6p27YmBnUbVuUS/ogmQOFQJy00TrkgEGpe/wwpgjGwiuF
asOSIPdIEu8GVbfX2YcyTdsqcdq2aMdL5MwmKsTKsf+tVMxQZIbCVefxXcYXElpu
jefQFsdlWQZ3nGf9cQJkdvmMvD/6/Q/P+XkWLEU7D3dbNeXT8C9CX1XzNTYCqE7I
HIpa36aM3Uz7Tk9jkDejfUMAqBkZcp6Psdjln3xV69HtaiVlr0FyvmmwsP/Q+2MO
4weKEBFoKXy82UtINydCCa/vhQEwBK9PMMM1Sh3Dvs4JTd8LcQFqLnKCRHPfr/dU
NUsUYZeBx45j2BQYp45zC0IOuMnIAUQquCScwR3N1Sl8ubrAkgwSj1GaoxMYvjp2
WnbaOrBYOFyoeGuCTyUpHrKasC20mH2oT3LX60EmBC4hm/NtLxFnnVhWbxSD8kji
YIg9HuItlV8dC0exJ69iDaFpNTQTcAT/BX4RlZrpGmljM/nRigMedGeAtU/1vKlf
tj5Q0DZpBRZXMM2Y+EabuyMrhFE+5xJqHLUx6GBon2Z+DOd5d61iR6zpo2OrxTxe
oshpD0whuM6lRH4mkzP/kHoQlkVis45eMDMvpBS56ytcAjqyg6wp5VAIppvNAMS6
V7y+wut9D0WvGQx9nl0L
=TDqO
-----END PGP SIGNATURE-----

--=-9qaFW8ayiIjSgkz9EQ05--

