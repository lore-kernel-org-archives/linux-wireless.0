Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41850 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524AbZAFNAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 08:00:21 -0500
Subject: Re: drivers returning wrong results from their _tx op
From: Johannes Berg <johannes@sipsolutions.net>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	Daniel Drake <dsd@gentoo.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Javier Cardona <javier@cozybit.com>, Chr <chunkeey@web.de>
In-Reply-To: <b6c5339f0901051424q12d8fc14o8f20b62cfacc4e6e@mail.gmail.com> (sfid-20090105_232440_694283_0A261787)
References: <1231193264.3697.41.camel@johannes>
	 <b6c5339f0901051424q12d8fc14o8f20b62cfacc4e6e@mail.gmail.com>
	 (sfid-20090105_232440_694283_0A261787)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qGV/zK5Pt9ykJzPmfN7p"
Date: Tue, 06 Jan 2009 14:00:59 +0100
Message-Id: <1231246859.3503.0.camel@johannes> (sfid-20090106_140027_227151_BAFA5595)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qGV/zK5Pt9ykJzPmfN7p
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-05 at 17:24 -0500, Bob Copeland wrote:
> On Mon, Jan 5, 2009 at 5:07 PM, Johannes Berg <johannes@sipsolutions.net>=
 wrote:
> > spatch:
> >
> > @ r1 @
> > identifier _tx, _ops;
>=20
> spatch is very neat...

Yes, indeed, it is, I've used it a few times already :)

> > First off: all those should return NETDEV_TX_OK/BUSY.
> > ath5k: returns 0/-1
>=20
> Can the kerneldoc for mac80211 ops structure document it?

I guess it should, want to send a patch?

> I'll send a patch for ath5k unless someone beats me to it.

Thanks.

johannes

--=-qGV/zK5Pt9ykJzPmfN7p
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJY1YIAAoJEKVg1VMiehFYWP8P/2yGfneXLTPlDwGBunaj1tW9
+gtAEEcZ0XrP2WPaxTm+pom3y7T4FtcCLpMgN0zub4UNbI/qkn2eEokBGPGvThs0
AMmjCrRDO59KaBpgOJdpICPSsnFa7D4I01kF4k/3G3+Evy15c5ZILNkY17B0uCRo
0F9YmB3BQ/N1VqRe1Tq94FC4cU61L2TG/8H4sKTHwgItInSjju1irkhOt2pXUr71
BHQUQ1dDKZsWF9s4oWDLiTQ9Jb9YdSR1FUcIc5iXgUZmjCF/+sWUGib57AxlX6qC
JQfBUr/TC/5wymbOgrWo7FIABmrADwOF0T5UuJB9usZlbIrwMdXSfOq4iTQquSoy
4uahsMl40JxRHprgsJNYfAk0BpWCfCDz2Sec6+lE83/K7D7YGcfPr9gPgbA/sK4Y
tdz2l8G9lqNHJyKTWlk8e9H42xBLkvLyPxw9we0BPRD0Q4y81pqtuV/P+x9LKOvu
1NbZT14Hv4yGzhObup/Hb3/zQgeaISuGkSSbyqkuEiMcxXQLDEG3PXIEUoMJ7/wx
68izLp8jRWxwQB9LO5Hxh5F4SfOn2UHERxvJTlkOu7C1Uhl308W1x9BTAnnTwODv
J+zTXoNjZ6fmdQRDm3oUFJ+kKO8mPDbu+KVQhU3MmAWRIv9Suwusm4Yj7oDrF4gX
Vxo11vVtDBLa83rcTOo4
=TDRE
-----END PGP SIGNATURE-----

--=-qGV/zK5Pt9ykJzPmfN7p--

