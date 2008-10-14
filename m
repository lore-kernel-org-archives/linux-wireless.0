Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYJNV5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 17:57:41 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Zhu Yi <yi.zhu@intel.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081014215050.GG3349@tuxdriver.com>
References: <1223608949.2510.1061.camel@debian.sh.intel.com>
	 <43e72e890810100949i78c1d813x1b66c6bc0239ef28@mail.gmail.com>
	 <1223967581.2570.144.camel@debian.sh.intel.com>
	 <43e72e890810140004k6bfa72edsf39acbafcf317fa6@mail.gmail.com>
	 <1223969808.2570.153.camel@debian.sh.intel.com>
	 <43e72e890810140204ne135e72kefe379dd3d26f7bc@mail.gmail.com>
	 <20081014203510.GD3349@tuxdriver.com>
	 <1224018957.3027.9.camel@johannes.berg>
	 <20081014211912.GF3349@tuxdriver.com>
	 <1224019662.3027.13.camel@johannes.berg>
	 <20081014215050.GG3349@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZyZZ918/akh2pLvn94df"
Date: Tue, 14 Oct 2008 23:57:02 +0200
Message-Id: <1224021422.3027.15.camel@johannes.berg> (sfid-20081014_235744_460591_235D7614)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ZyZZ918/akh2pLvn94df
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-14 at 17:50 -0400, John W. Linville wrote:
> On Tue, Oct 14, 2008 at 11:27:42PM +0200, Johannes Berg wrote:
> > On Tue, 2008-10-14 at 17:19 -0400, John W. Linville wrote:
>=20
> > > Should there be an "I make no representation of authority" flag in
> > > the regulatory maps?
> >=20
> > The only reasonable solution I can come up with is have it make separat=
e
> > hints for 2.4 and 5 GHz and then a single-band card won't say anything
> > about 5 GHz so the dual-band gets to set that part. But OTOH I don't se=
e
> > a reasonable use-case for this whole thing so far---we really only adde=
d
> > this after discussions with Marcel at OLS so embedded systems can
> > function w/o crda, but who would build an embedded system with two
> > different cards like that?
>=20
> And couldn't such a person also do the equivalent of the OLD_REGULATORY
> stuff that we have now?

Could even just write a trivial app that once during boot requests a
setting from the kernel and then sets it.

Kinda like
iw reg set XY
and the resulting crda call rolled in one.

johannes

--=-ZyZZ918/akh2pLvn94df
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9RWqAAoJEKVg1VMiehFY/+AQAKbS7TaD1B8Fz8cwrA9PwZvp
jNjPZ3aKzOUMr2N3lFS6sONOhLHO+fjwnX4oFF4GNnddeu9YwMcQFVqUjC8FbWhz
Jdy2zu4V8Zmgfyy8U6bUQBGQSzOc3gzBkBH0t+SC3xtXH4w01nIdftxx2Lp5WipI
UvODi495xwqgfFcJjcQQ1Ido0/gQr0tG5kREeI6vmrckambt+Y6o3QkvgwGxbJg+
mswyANtXXxWzyJJYlYOqvbzGqlUc1zefFB0lF2CR3Rf036z2ltGHpDIwkwKNp/BP
y9CYQ2750fzKOmfbK/PUb0fqZVEKhBW8AZpU6Og1Uo1h76UyNueCtdTnV0q9uNOW
aumWPLmi9OkrSEo/Pit4lA7NG+CGM0kHokUEEVVyvFdfRyVEHfDXbbptb/EvmUMZ
5m67kpMeY4AJKATCExJOw5YUCFVT7WQBHhPLhTXXgbC7GK1mCEdMZ7q6XRuYkqwo
2OXBmSZrTdp0gOOcPsPkboyK8fyNM74t4IjtcgAKsZUpP1DB/gbnjlwGsffqsGg2
xCC3EEOOVlCQbKEXUDODx4G+qD8UV5TG6LRrxYA2ySfoTa6uCgADW2UPi4jZlB1n
87bRIA1U+gK51ESwz5M5HlhkU4TfK84v4gES37Dw6m3YDUapBiXSt8Wej9ByVKcv
y3xeUhB2gpJXzvw6Pffx
=ryud
-----END PGP SIGNATURE-----

--=-ZyZZ918/akh2pLvn94df--

