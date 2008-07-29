Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44711 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbYG2NqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 09:46:14 -0400
Subject: Re: iwlwifi aggregation info
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240807290643l4192ca62ia4db9966501caf0b@mail.gmail.com> (sfid-20080729_154316_855359_4C222F99)
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217331408.10489.26.camel@johannes.berg>
	 <1ba2fa240807290525o41832ccei92ff554bef876b37@mail.gmail.com>
	 <1217334452.10489.42.camel@johannes.berg>
	 <1ba2fa240807290535h3ebd4121h399b8a8cd1d8b276@mail.gmail.com>
	 <1217336023.10489.51.camel@johannes.berg>
	 <1ba2fa240807290604y47edafe1k7cf93831c31b6112@mail.gmail.com>
	 <1217336870.10489.55.camel@johannes.berg>
	 <1ba2fa240807290618j67db294w524f3885f0e94c7b@mail.gmail.com>
	 <1217337819.10489.57.camel@johannes.berg>
	 <1ba2fa240807290643l4192ca62ia4db9966501caf0b@mail.gmail.com>
	 (sfid-20080729_154316_855359_4C222F99)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dBKy0le3eLoPpKpns2Sj"
Date: Tue, 29 Jul 2008 15:46:10 +0200
Message-Id: <1217339170.10489.62.camel@johannes.berg> (sfid-20080729_154617_605768_057D3635)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dBKy0le3eLoPpKpns2Sj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 16:43 +0300, Tomas Winkler wrote:

> No the mistake is on your side. FIFO is not relevant here. What is
> important is whether HW queue is full or not.
> Except the AC Back off scheduling done by FIFO there is BA protocol
> which my stall HW queue. It doesn't mean that other packets with the
> same FIFO should be stalled. You need additional SW queue that can be
> stopped.

HW queues are irrelevant, you're the only vendor that implements it with
HW queues. If you think they're required for correct operation, clearly
you're wrong.

I'm just trying to fix the bugs and find a way to do this with hardware
that doesn't have extra HW queues.

johannes

--=-dBKy0le3eLoPpKpns2Sj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjx8fAAoJEKVg1VMiehFYqm4P/1MbU5VUg+EFD0AOnMcKL96t
mEKKa/SXYgUg/u2G6q7JHnuXjX88r46gbrVpUvU4GZVICOtgrHl0DSJUN5BoKq/H
3fu7lGKAKTTy+HYM8a6XMWlDMz/ILA+/+DbQtE5YdKIW6T7Vb1ZwbXaucnIylRzo
s30ybBop8MyEMjOAzxRXi8tpA7AAvPCF6HiaUwMuZxapGFlGg/ox+79/FtxRzFXe
kWJr9GF1llcQue6DBKpZ1P4wAPekBJNexOMqs5Mu3cEFRjdD3Z8w+hdkPCLtyv78
AwsPJ3IHeMTXD1ArsPwqBh4lHWiY5TzbyqTCwgsKkkLlIvFgQCMNDrajUwRPNxed
h9c6+YE13lJk4stuZ5yJRcPW9IMkZ6tH9kMJzngjITiFz4Dy7Yy9KOxXWps8TYuI
9Tz6WNNSPzVkS7D94b6mjhqPxVBg462/DNJcTHBY+JIu8EdYWDnfs8yqLYR7Pc0p
uPdLCXOpvCVZLG83gMDlX2EihW12VBTX97KU4mn+1lx+vuFlL1/E9lhvfqRsNXq6
irFXKHj+2XDHUxjWiG4g7J39/SbO4vDzDFbI403MemYxFbiJzp2PkOEGuRO5NVEA
we/Mk12n3cbJmNZkA0eYV+/Bp6kVzybTczWbRBzGQWaD/njLDR69ZPxs/EwMC5LR
U2+LZAsVkMoeylu2a/x4
=ai6Y
-----END PGP SIGNATURE-----

--=-dBKy0le3eLoPpKpns2Sj--

