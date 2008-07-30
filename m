Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53851 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759834AbYG3Jx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 05:53:56 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
In-Reply-To: <1ba2fa240807290855p191eebesb1ecf2314031f688@mail.gmail.com> (sfid-20080729_175540_513294_CB416055)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217336023.10489.51.camel@johannes.berg>
	 <1ba2fa240807290604y47edafe1k7cf93831c31b6112@mail.gmail.com>
	 <1217336870.10489.55.camel@johannes.berg>
	 <1ba2fa240807290618j67db294w524f3885f0e94c7b@mail.gmail.com>
	 <1217337819.10489.57.camel@johannes.berg>
	 <1ba2fa240807290643l4192ca62ia4db9966501caf0b@mail.gmail.com>
	 <1217339170.10489.62.camel@johannes.berg>
	 <1ba2fa240807290706h70f89f68xf8fe7e672c0275ad@mail.gmail.com>
	 <1217341293.10489.73.camel@johannes.berg>
	 <1ba2fa240807290855p191eebesb1ecf2314031f688@mail.gmail.com>
	 (sfid-20080729_175540_513294_CB416055)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3H/2d7gMQb5adEgKyz3L"
Date: Wed, 30 Jul 2008 11:53:51 +0200
Message-Id: <1217411631.10489.103.camel@johannes.berg> (sfid-20080730_115403_722776_E5C8B817)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3H/2d7gMQb5adEgKyz3L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 18:55 +0300, Tomas Winkler wrote:

> So why do you need 4 HW queues for QoS, every vendor now implements it
> that way today. There is only one medium, you don't put 4 packets on
> the air at the same time.

The single medium part is true, but the scheduling decision is best made
at the air interface, otherwise you'd need to be able to kill the hw
fifo when a high-prio frame comes in to preempt other frames.

> Now imaging that withing single queue you
> have another priority level why it is wrong to add another queue for
> it?

What makes you think aggregation is another priority level though? I
don't see any evidence that it is, and everybody I've asked so far seems
to agree with me.

johannes

--=-3H/2d7gMQb5adEgKyz3L
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIkDosAAoJEKVg1VMiehFY7b4QAKTuoeg88AnNGeBY3h4h5M3h
t3hRZfmojViPlY9tiKA8i8inBDTVcYeZgjOrWk9h2N9bSyx1IBItS0jpqPKNMrUh
5SznPLuN+GIHqNk0kdStHf0DhhrLZ4Li5AbJOndE+myb44DmEVWAIwD4htLLdA/l
JKa4iy3PGs3IIeocbYWso9Vco+LlAE/oLl7Q8HE/DzE7AUVOKf9T3hKkaiV/VO4r
Qpducal0i/hNY1+WE51CEgtZhBN8AsKflPiPSFCfE8LnXPsPuBr0Lg/+Wrhm7dKf
SOINWqvQMwoF/7vlo0t8xqDKLqAe1EgrD78M/HzOXNpYYpBEaPN9DhQ/WeUytyKs
zBhREOGDMWeBXvczskf8Z96d7lKzONAV/0uOyMG4tdMxNG3Q3BVi1eD3q+uQQPBs
MeCQdjsk5jR6Dy5jETRwnGv+bY1kDX8gI2JrgoRNUt1u3+isZHkbRwk5UgRIuUjm
8zbDjmPIV1tORbBHSFVZDbFGFhAqiVzVxklXG9a9miG1G0eHUMXIyic7E0XrSWgQ
WBOh1faLcFzYfJYZIktPAVm+1CofO0J82VSnhXQU9VcY/OTAwnFRCtw3NBz26d5x
fTGxpLDLOfSdTdYWqDN7DSa2czmPFXVnT3vd/wvKxhkCMKO5/zbJ4iI3JixJFSIP
ccaBfhgfWxJ0R+yAvvZ8
=3mm4
-----END PGP SIGNATURE-----

--=-3H/2d7gMQb5adEgKyz3L--

