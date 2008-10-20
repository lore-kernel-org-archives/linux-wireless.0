Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49478 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbYJTGuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 02:50:40 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810192346q5e0eadbcm26febe45392a2172@mail.gmail.com> (sfid-20081020_084638_110948_D3E45D2B)
References: <20081015112517.GF6509@tesla>
	 <1ba2fa240810151757r11060dfble6b58c76a7d0d8d1@mail.gmail.com>
	 <20081015185636.GH15902@tesla>
	 <1224126030.24677.78.camel@debian.sh.intel.com>
	 <20081016113848.GB5899@tesla>
	 <1224471102.24677.124.camel@debian.sh.intel.com>
	 <43e72e890810192040w567fa4f6j1bf40e80084a857e@mail.gmail.com>
	 <1224479933.24677.148.camel@debian.sh.intel.com>
	 <43e72e890810192333r7b3f6a0m56d499d0aed9240e@mail.gmail.com>
	 <1224484685.18024.5.camel@johannes.berg>
	 <43e72e890810192346q5e0eadbcm26febe45392a2172@mail.gmail.com>
	 (sfid-20081020_084638_110948_D3E45D2B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AnGBE/2rVlPATBgMutyB"
Date: Mon, 20 Oct 2008 08:50:31 +0200
Message-Id: <1224485431.18024.12.camel@johannes.berg> (sfid-20081020_085042_471447_851AD2E6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AnGBE/2rVlPATBgMutyB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-19 at 23:46 -0700, Luis R. Rodriguez wrote:

> Sure but an issue here is that if we do deal with band-specific
> regulatory domain definitions we change the regulatory behavior from
> being "disallow everything first" to "allow everything first, disable
> everything in the band for which we encounter a rule in except what
> the rule allows".
>=20
> Since the regulatory definitions in db.txt are in KHz we are allowing
> it to grow as more technology pops up with support for more bands. I
> think the first approach was better. The current suggestion of only
> applying rules if a band reg definition is present is only to deal
> with a rare case. I think its better we try to handle that instead and
> keep our existing behaviour.

Ack on both points, which is why I said "If we're going to [...]". I
don't think I've seen a convincing use case for this other than test
environments, in which you can very well just use crda.

johannes

--=-AnGBE/2rVlPATBgMutyB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/CoyAAoJEKVg1VMiehFYKCsP/i/81Na7S9v/oUccE4KWK71p
hc4bAcuD68cytDdh5sZ4vY/5Er4meojFT6byHAd+Mb70WrSXegXXqYUopqnysdH6
p3DRxQyA7zt8n1pL832CSC+HoYmo/X+B11jUfYCjw4erWLdxj4BKY+S54GnW1CZk
unasfHGq50YAnffP5yyo9otYEZcJOv4mA5mHdFozjkcqCBJxilkCOx64ugHTtNv1
6yjNWjugKSLbLzUwMwcid5fgufWv+Yavs3oaSD5sAEJ14CMungsr4TW8tQUJn5ZR
w1oGdjtUseqAvUOI/mDlQvvmWNyupohhJG5ArqiofF1WPAfe7BAotef3ufF4lA51
DfZKKj2gktBjVv6lDmBzk0IEYOVVROP1Cy0MhJsidyt6uh6ZPctdAWtCkVveZy+K
YwNP9KJcj+07QxMX7QQGTECt9dL5YusKrkYnKdMT8zdkmjVtkmViZcR0pRNZVspK
3aUX+1GJa/JQBOqSoMXEUYoYCQD1WHUMANSUnZ0GFtZXjF4Mdstofe1BPJv8niPg
sFA+IQEWPP9aT4fQB41wYEZOlQiyzzZfpglflTpxho7r7lFz1o2my9Opd1YqIVuG
rfDgKgLLJOV42cIM3s1e/bO/8uTHeAlEQvzq9tYMxSbaZS3bz+aJkKov0Z+TRunF
IpMKxv03atAuvbje7Zbo
=O8mf
-----END PGP SIGNATURE-----

--=-AnGBE/2rVlPATBgMutyB--

