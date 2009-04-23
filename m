Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:56439 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZDWRnl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Apr 2009 13:43:41 -0400
Subject: Re: [PATCH 3/5] iwlwifi: Fix handling of retry count of NO_ACK
 frames in  iwl-{3945|agn}-rs
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: John Linville <linville@tuxdriver.com>, Zhu Yi <yi.zhu@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
In-Reply-To: <69e28c910904231036l5fb331d5u81bcbe92b7f40179@mail.gmail.com> (sfid-20090423_193653_487405_479A8CA1)
References: <69e28c910904231036l5fb331d5u81bcbe92b7f40179@mail.gmail.com>
	 (sfid-20090423_193653_487405_479A8CA1)
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-BxV43H1Z6y4FGe4jSqDN"
Date: Thu, 23 Apr 2009 19:42:41 +0200
Message-Id: <1240508561.30082.260.camel@johannes.local> (sfid-20090423_194345_137249_95044315)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-BxV43H1Z6y4FGe4jSqDN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-23 at 19:36 +0200, G=C3=A1bor Stefanik wrote:
> Make PID

>  iwl-3945-rs.c |    7 ++++---
>  iwl-agn-rs.c  |   14 +++++++-------
>  2 files changed, 11 insertions(+), 10 deletions(-)

Ummm.

johannes

--=-BxV43H1Z6y4FGe4jSqDN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ8KiLAAoJEKVg1VMiehFYjfkP+wUq39+jvqaYOGcTSxG5tHYm
P4YxvHm7mRwr7OtizVl/QW8NrVMdQbLPPjqQSt5uFXpxnMq3+LPK/9+7pJbX3uF9
lhQx8CGPvnfoS0lJnN9e7sUQaTbI3dwV4Fg8C5wettMwvuxLcy/U6kOS3m/jUTr4
fUWj15/hX0UBn7JnqpvVFSJonAvQBrEzvUNk7EddC+pK3ERizhv+blPD7qFm/GSo
zDXlXiruAxcboPIyMpzIry45CXgaPOWW4BVXrBbfS5xPdiXxBaa0iZ2cFC/MzW9L
/CdYkZuniuZGGcK/KdnJxTlW0hkGYIwsiepRFBIYndOwB/6FvLJ01tL/iUD7X8nI
0iBFhfh2FyX847g9IQUb+SpkxwrRZNMhAIQYh/CokXbGvw3S5CfJYAqC/TT8dUjI
VJqhx2Px/uGEj8T0aXEf6oeoT8rq6Qh0snUzOLHyJ4QFZbgIiI0DCLBdculOnLj5
LMSBcYy3+zej4A0DUA5/4CfckuvO2DU74Z+yqdMLxPhBIws0bw76FiVps09yM4FF
42gKUsTjkDKoJ0EMN0REGQqPL/cf1EUkUwJMzJS2NGQc1AShm1Hgk03IPXbRzDyQ
raYvILOutCm8R719X2BnH/IzNBXEG0UzAWzw6WLJEmy2JxFUxOgn2f5oatpEL3/a
ZYNO+93jZ973nZZuepb/
=tA0t
-----END PGP SIGNATURE-----

--=-BxV43H1Z6y4FGe4jSqDN--

