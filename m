Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:18778 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab2ITOdL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 10:33:11 -0400
Message-ID: <1348151876.2388.24.camel@sauron.fi.intel.com> (sfid-20120920_163315_421413_05851776)
Subject: Re: regression: tethering fails in 3.5 with iwlwifi
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Thu, 20 Sep 2012 17:37:56 +0300
In-Reply-To: <1348151149.31352.109.camel@edumazet-glaptop>
References: <1347361823.26457.3.camel@sauron.fi.intel.com>
	 <1DC40B07CD6EC041A66726C271A73AE6195AE9C8@IRSMSX102.ger.corp.intel.com>
	 <1347631355.5263.19.camel@sauron.fi.intel.com>
	 <1347640763.5263.24.camel@sauron.fi.intel.com>
	 <1347892887.7112.9.camel@sauron.fi.intel.com>
	 <1348142775.2388.10.camel@sauron.fi.intel.com>
	 <1348144524.4161.26.camel@jlt4.sipsolutions.net>
	 <CANn89iJkXrZPB14KU8xA-Dn8_n=H3J4-R60BTZFV+STF9_ASdA@mail.gmail.com>
	 <CANn89iKStHAwVZtpgQMzEpByGYG2FKpjSQsJFT-9qQmjw+KJ8g@mail.gmail.com>
	 <1348145936.2388.18.camel@sauron.fi.intel.com>
	 <CANn89i+9Th=xVgDgoy7tHwKtLNpOC8rgJkA09nQ1Yf0zvqBw6w@mail.gmail.com>
	 <1348147353.2388.19.camel@sauron.fi.intel.com>
	 <1348151149.31352.109.camel@edumazet-glaptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Vk1cqqf8/EUKfz9Kx+Eq"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Vk1cqqf8/EUKfz9Kx+Eq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-09-20 at 16:25 +0200, Eric Dumazet wrote:
> Please remove this hack and try the following bugfix in raw handler
>=20
> icmp_filter() should not modify skb, or else its caller should not
> assume ip_hdr() is unchanged.

Did not help :(

--=20
Best Regards,
Artem Bityutskiy

--=-Vk1cqqf8/EUKfz9Kx+Eq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQWypEAAoJECmIfjd9wqK0spgP/REAEjNAWwZR5ozsaS+w+S0r
UhSA+iPMSbnolsU+wDLoK0yPP5Hj/ynsCC/aSJJLXGkJ9VRWwLU2W9NnoXwY6LaX
qzb0hqknqcs0vF0MR1rDy/I1Lge09h88IA4E8osX4koBOn7HwjVNce3VBcwCt9M4
Q/zdpqWzznTXktIQYW75b2JYzycKXli1KAi2XMY8/FqC3FpxxEMUvffwdIrRkGDp
R3Y/lwIDEroSYrEjNlrUwRPxHMbz0T+ndN51I8FpPK4bxa3j3v+/sKdy9AKCbM/R
9dfDunBFzuDt4Mm+sRV+7Dijs9X/JJcBiJEh6MhuTe5IDjMVWPYUYb0y12/5TZaf
8623qhzhHgoR5V8SX4c26S7U3SDOBDg7eQt0p4L0QI0r8RYkhmiBGjazlGe6X2Ur
rqV8bqj0bAGT8/Y0MD+k62eMs73PBK5ezP6bwrtVTSD1iZLStIj8WdjCbo9UkViI
t46pOeqDp4vYykmEMm/1MAO6/2PNkOE/LLYP2J+h1hs4vZIw6DHhVDL2D1DybDSd
7+NXjlBC7MqJvYODNERG5Xf/4rv+aOqdnFd1Y7niTm2UcD062ktCrBgS+OPJChRm
RFpqo9RxeEM7GJfEqy9hIEFMxJWUw7OTL/ncxY0HCjihWTTAMKRexyI3aEU4zXfW
eCzRUwu2WiWt1Nv8YjAD
=sH14
-----END PGP SIGNATURE-----

--=-Vk1cqqf8/EUKfz9Kx+Eq--

