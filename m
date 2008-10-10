Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:48183 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757007AbYJJSh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Oct 2008 14:37:56 -0400
Subject: Re: [PATCH 2/8] mac80211: remove aggregation status write support
	from debugfs
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>
In-Reply-To: <43e72e890810101122o12440c60ic35b19b037bf95de@mail.gmail.com> (sfid-20081010_202214_739441_0C901985)
References: <20081007100428.868688000@sipsolutions.net>
	 <20081007100438.773792000@sipsolutions.net>
	 <1ba2fa240810071424s23bdbbb7kbaadf3678cd61a26@mail.gmail.com>
	 <1223452772.3618.20.camel@johannes.berg>
	 <43e72e890810101122o12440c60ic35b19b037bf95de@mail.gmail.com>
	 (sfid-20081010_202214_739441_0C901985)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WmuJahexzvruekek8E10"
Date: Fri, 10 Oct 2008 20:37:53 +0200
Message-Id: <1223663873.3748.34.camel@johannes.berg> (sfid-20081010_203800_553130_0CD21DA3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WmuJahexzvruekek8E10
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-10 at 11:22 -0700, Luis R. Rodriguez wrote:
> On Wed, Oct 8, 2008 at 12:59 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Tue, 2008-10-07 at 23:24 +0200, Tomas Winkler wrote:
> >> On Tue, Oct 7, 2008 at 12:04 PM, Johannes Berg
> >> <johannes@sipsolutions.net> wrote:
> >> > This code uses static variables and thus cannot be kept.
> >> NACK
> >> Need something to debug this stuff
> >
> > Tough luck. Go write proper support in nl80211 then.
>=20
> Someone has some patch to use nl80211 for this BTW. *cough*

Who what where? Andrey said he was going to work on it?

johannes

--=-WmuJahexzvruekek8E10
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI76D+AAoJEKVg1VMiehFYf3oP/1oKkrhjL/TnDQ8E2cLeUuPw
ffbi+U+j1Dq3xpI7mYFKGIXIGy0ca1ZOOzKWXpLFeluq90aQqOR8NfLuO+hYyNLb
HBKuniGIJYg9zq+LCIKadovLwkr0y0E7NNJYBX6p0qqs/EAupN2M0l9JYAY+MZBv
quGjz+BhoATnNOkMdLsL3KMGRwCJzR0PEvPGK3XGXROuOzy6h6A1kVq3gL9uYvDI
BUAFwVPeu2iT8lBSs1GMOQsrkQtqayTG7Gk3Iz4/H3XMXUQM+NKRe7lVENL/hgui
YiC4aB0Lx12J+qH4P2Mr3WaruMTlzxyUGhXt1WLtWPT5szZY7JroGy+DXU6bhIzz
fB5pMzJcGc00vjeeuTdTDkUqn+vsbdoaB5g06r69BDWDT8CjrVzV/8F3kyzD90Nh
ZDdRnl5GWrXYBlYcsKhdFxdJLLJQVUAR4t54FdOLGBTWB4OD9zi1h7kCRooMbdNu
CQt6EPIUKRBiyblQ1K8Vk2KAhnsvwXlF2/usYnPVojJOisTTeDLqUnHjZ/reocQw
23z2kebt5iMML6LK2+oPj2yPe71akhfAAQBrP/L70CEoSLMai3I4LtwDTfL4k9dk
jcCRrfqlBingZMLZiSyXPLcfNwIOZWV7hsPOHPNq64q4lwAMs9G0ZTWs6T9tUgtD
Gc+Q4yvnnZ8WR00jB1DD
=KBGJ
-----END PGP SIGNATURE-----

--=-WmuJahexzvruekek8E10--

