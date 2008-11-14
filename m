Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55034 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbYKNV4f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Nov 2008 16:56:35 -0500
Subject: Re: Master mode in iw
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	Mark Ryden <markryde@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910811140635v2c967406p439779c82866f455@mail.gmail.com> (sfid-20081114_153554_950885_42ADE9B7)
References: <dac45060811130246n41c9983fx2f06f85946b20c1c@mail.gmail.com>
	 <87ej1f6ggq.fsf@nokia.com>
	 <dac45060811130349k3153fcd6i9e6f35f9df3f52ef@mail.gmail.com>
	 <87wsf74z6f.fsf@nokia.com> <1226578011.5105.8.camel@johannes.berg>
	 <87fxlu4rdx.fsf@nokia.com>
	 <69e28c910811140539p57fa13dej4c13aa0d09c76f95@mail.gmail.com>
	 <20081114141912.GB3443@tuxdriver.com>
	 <69e28c910811140635v2c967406p439779c82866f455@mail.gmail.com>
	 (sfid-20081114_153554_950885_42ADE9B7)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Mon6GnGeluDal11AFjZP"
Date: Fri, 14 Nov 2008 22:56:24 +0100
Message-Id: <1226699784.4120.24.camel@johannes.berg> (sfid-20081114_225639_529569_067960B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Mon6GnGeluDal11AFjZP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-14 at 15:35 +0100, Stefanik G=C3=A1bor wrote:

> But is cfg80211 supposed to be used for completely-fullmac cards that
> do AP in hardware?

I very much hope that such cards will never exist, or at least will have
a mode where everything is done by the host software in which case the
driver will be using that mode. Everything else is plain stupid anyway,
with all the new amendments coming out all the time.

johannes

--=-Mon6GnGeluDal11AFjZP
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJHfQFAAoJEKVg1VMiehFYNUwQALdlV4Npox55e5RuCdpLL8/t
zM2z/aA8JzhX9bLATe7ZGRxMNGgpQuEDwdYCV5BvMlwk4fKWyb7l1BbMTzQvg1Es
ndbRfwtKTGT3lNKymi9xR8lpGtaCwn5cfHYzj27NIEyOamxu3mZu0m3gZ7ZgDYtQ
T/wdLxUFJxSYf/0+Cm2EgMzmo7+86TfEdtB7MRqehd1rWR+NeP2bNnlUZ4vFH8zk
brTkzu2/E6RJMzZoRlBlUZaQx+wAGwKV++QYY5Wa62H2KECnvUnny6wC/XsDxBfy
LlZ+Sk9jWN2ez414VmizKzdZsmdy3rwz0cwLLTQ2wpsZBtzjTxvS/HnYLwAzznHJ
+xxOYfzmnux+I4fVVD1Wy+jpppxDQ54OTFR7yrTLeEAEB5Pa41VduHvm/4Bi7TZG
eDIIpbkg3Wqt1rNNkbF6ux/frkfXzEUwWN/5DShBWzJNL4WY8uP0Bk7CZLtJiwUH
2KSx74604bh65r1id9vfNWBkrDYVFCGv22HNb6eTSaVkko1n5aNQXM3+2jpmoQvC
FDGYm+7JFU6SSayI/rQEt9nL9tBvU0iP7M/O2OiiVD6S3z9hzi1FLpIuf1VbROGq
Kh2u53lRufjYQYrFIoqy9LbVDmg+E+Vjy6y77VqnizfQcKj9G/kq6+cceWhdxcVL
tbSQnAcyWL23iyERWX6Q
=DGAP
-----END PGP SIGNATURE-----

--=-Mon6GnGeluDal11AFjZP--

