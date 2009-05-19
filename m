Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45379 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbZESIQ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 04:16:27 -0400
Subject: Re: DHCP broken when using A-band only
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1242701451.3147.2.camel@localhost.localdomain>
References: <1242701451.3147.2.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oPwkmDApBO4hzYU7r7Dq"
Date: Tue, 19 May 2009 10:16:23 +0200
Message-Id: <1242720983.29049.16.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-oPwkmDApBO4hzYU7r7Dq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-05-18 at 19:50 -0700, Marcel Holtmann wrote:
> Hi Johannes,

Heh. Hi Marcel :)

> so I am running the latest wireless-testing.git tree based on 2.6.30-rc6
> and when connecting to my A-band only configured AP, I don't get any
> packets through. Even DHCP fails. The only thing I see in dmesg is
>=20
> [ 3221.246392] wlan0: dropped frame to 00:1f:f3:xx:xx:xx (unauthorized po=
rt)
>=20
> The wireless-testing.git tree based on 2.6.30-rc5 was working fine with
> that access point. I was actually happily using the A-band since it is
> less busy here. Any ideas why this might broke?

Not at all, sorry. Were there any driver changes? There shouldn't be
many changes at all maybe you could bisect?

johannes

--=-oPwkmDApBO4hzYU7r7Dq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKEmrUAAoJEODzc/N7+QmaYzwQAMFPvrvLpK0YGk9jNPYvKqIC
6glIKk2UJJZGnFpHvlN64YjRfbYzOwm9wNKeZistQqFwgT+jltPPCvHq35XLJPmj
Bk450leFsMan7foA1TfTGQ9e/kFP8XnHvcZoCBBr9dRUmOczkuaGmwMNzO0Piq68
n509RmrlISFRnvJbqGSiWo5WHe9IEpeJsmnAIR8cwB2LGzvPxpsT1Zzi+PgOVx7/
4Ikji5zoz11N5HS8GmgN+J7mH7nHrC7KenvWMMxlW3szRA5eQ1wj4KxYc8xTwxZL
fh7hd0vD+I/HZMKjRbJHSUR2Nl9XSPiAvfb4L0RjKvB6e+FznDfdIph4Y7ZHJyYY
8mTBaAzYh6qbwQiTcRsOKqSOj5h/m79BQbrjOKVWh6dRjkeqTAcVDxbdkP0aL/TD
NBxeYdvS/7Ev2FzPptT8KNCq3cvdKO3g+bEFPLneKbsLwKUE/Zrh/G0ywMBGuxSK
gJPS9B2r1TLs3n9iPCiOmfb2JbZkD1ef6pxY1LL/xMH6SsLK+B1QqUrquC0jIMl6
QD5BSk2BoSiU93VBhoX4TvPG+AG/6cNADyE+WQon58OVtYUHmYnHMplOrslqSwlS
XaUR2fHXCX2c5XnnKezQGVex4ic3L+qLmdo3tiXCKzH9SVWzl61i53Fa3LAtwy5c
3L370fKLb6YgXwp7eEsH
=XxLO
-----END PGP SIGNATURE-----

--=-oPwkmDApBO4hzYU7r7Dq--

