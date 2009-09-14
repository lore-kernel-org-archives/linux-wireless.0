Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59541 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbZINRku (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 13:40:50 -0400
Subject: Re: Kernel oops with 2.6.31-wl
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4AAE4DAA.1010505@lwfinger.net>
References: <4AAE4DAA.1010505@lwfinger.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+yacj0XCo8MKjEvmtMNk"
Date: Mon, 14 Sep 2009 10:40:17 -0700
Message-Id: <1252950017.23427.49.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+yacj0XCo8MKjEvmtMNk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-09-14 at 09:05 -0500, Larry Finger wrote:
> Using the kernel v2.6.31-38241-g2d3a51e, I get the following kernel
> oops when unloading b43:

> RIP: 0010:[<ffffffffa02a3a3e>]  [<ffffffffa02a3a3e>]
> b43_op_config+0x10c/0x36f [b43]

Seems like a b43 problem to me.

johannes

--=-+yacj0XCo8MKjEvmtMNk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKrn/9AAoJEODzc/N7+QmaOFEQALsEAwyLw9ylJXDMgtF/kNI7
mCKbqtLAxMXa69ztEw9iV9X5AzEG5EK6VbplgVHfFrzuG8dq8cAHB2YFY9G5CEJ9
ovOT4f/8ohztKiK3ChfB+IfoP/sW0p7TSyiZS8dImmW4bJl3melogILicKR3bnBX
p7hdJngLlTTMsV4HsvfchClO+3i451OKpxzWOrnIIb3zL/MhwQmuSRoa7BMoLoad
9KeB+fqHB1y07zpqxiLFawY+7Tu+QQGtRMZLoR+R37IHeVHU98mnvgDsFlfXzxdC
HPsiIIDmn3iE1aKtzJ2VLZrW0nAluBfZL8k9WJOIB/7J28kyriOqSYq03Zdg4ZJZ
3ko+PmskmRdW1JglB/Mf7hXewJtHDVZ32SNwQXII+2Lq2FFFLqoh9CcmL7DfSfg3
3ZvLKFy0FNqLkjCX89bAlGgKPc8NIbTVUSSzahZb7nYN+j9hEBfQFI8VLDpCf0qE
mXHGooxHrNyR3acRqQnZ4CgS5JrsbWyKL9iv8cSWGbvhO33kKcP/dvk6yz8/0f+x
b8dsBo3tyMqU0rIQ/8mHrWRSKME79wx8YGVP/29PMNs288JbOW3SvYGa5MgLcMcy
5PZuKsU8Yope+3mrwAJ4au5clBgXuwK0LK+8nhVAtfGAkoW3wKb1Y3XN89yOpAeu
6Pp/l+SsS/yqQnovep1w
=+Aie
-----END PGP SIGNATURE-----

--=-+yacj0XCo8MKjEvmtMNk--

