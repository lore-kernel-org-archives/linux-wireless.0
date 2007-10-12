Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:41021 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbXJLTSX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 15:18:23 -0400
Subject: Re: rt2500pci 2.0.9 not working
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcus Better <marcus@better.se>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <47460.80.169.182.16.1192179845.squirrel@www.dactylis.com>
References: <fdqhn4$qab$1@sea.gmane.org>
	 <55623.80.169.182.16.1192093534.squirrel@www.dactylis.com>
	 <1192094159.4770.21.camel@johannes.berg>
	 <200710112005.56101.IvDoorn@gmail.com>
	 <47460.80.169.182.16.1192179845.squirrel@www.dactylis.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OZXKc7bCi/xZhCBQfWOf"
Date: Fri, 12 Oct 2007 21:18:33 +0200
Message-Id: <1192216713.4770.58.camel@johannes.berg> (sfid-20071012_201826_454397_3502935A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OZXKc7bCi/xZhCBQfWOf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-12 at 11:04 +0200, Marcus Better wrote:

> Oct 12 10:47:23 better kernel: selected mode 2

That's G. What do you get without this patch but with my 'break' patch?

> Oct 12 10:47:23 better kernel: select channel -539241232

That's weird. Humm. What exactly are you printing there and is it really
a pointer 0xdfdbd4f0?

johannes

--=-OZXKc7bCi/xZhCBQfWOf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARw/IiKVg1VMiehFYAQKEkA/9FghqA7FzRc1jV3uw1eKbDug1Z8rqA57H
lbCUv/DaYnAG5N5MruqODQTNGwRLlb6XXiiOwpnkwTaIHnQ4ZXz+xQUEMum7OvWR
dQnxdDbjAbVQdjMr8mKf1WENYRf2+GgsYwNappwdc93QUOqRJPtcgoQrQp3jg+ko
Tppj2gfs+33TRtIPLeAS3fw8Jv3of+RhpdSh2eQM+IxO3U1JuBW/bFfwVorOVPu6
/ghsp7zV+vkwhBfzxkpnT7j6lfNWdlpFXbikpNtC4nAF6x8mWQGphfpMGRJ9RAx2
WxcLEl9/lSeFu7oo6t5mZ/CsVgFI4uEX5MAQz2y37ZNI6sYjRaW9iMddTMAB3pDo
0XVP7tfppu1VE1Sr5+DSrzF/5p96oDCGJRtx6E81yNJw8fhGvPm3DbciYCzZwbzR
MBCPpD5OkXRrvlVMj7blBUdW4DjVe3ra6BPr2yMUjxtJk/h7cV7H+WckvlQWPi7v
ng40wudjnOc7+04P3buR0tFdHJ1akPO1LTSFdjQ8aieHgPz+nH8MqrDm3Ist6lZp
wkNP3pftWyY+kZSvICkvhksPbXoKnAN1XMgmnVBtJWY+TaPCKUznodxmVXDxzLtK
3ggaCK/ONDnzQa2qUlv9Srnm8ZCaHoll+d2nAiVbJK6uT8jxsjX13xHGGLMSZEFA
KD1WwL/5Ya8=
=WN3F
-----END PGP SIGNATURE-----

--=-OZXKc7bCi/xZhCBQfWOf--

