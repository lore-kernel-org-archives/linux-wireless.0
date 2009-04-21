Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58708 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346AbZDUI5h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 04:57:37 -0400
Subject: Re: [PATCH] cfg80211: mark all WEXT handlers _GPL
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1240302714.354.130.camel@debian>
References: <1240246179.4632.6.camel@johannes.local>
	 <1240276136.354.107.camel@debian> <1240302453.17388.5.camel@johannes.local>
	 <1240302714.354.130.camel@debian>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uopftA27u+vAvBFjrLWq"
Date: Tue, 21 Apr 2009 10:57:02 +0200
Message-Id: <1240304222.17388.10.camel@johannes.local> (sfid-20090421_105759_155392_7E221471)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-uopftA27u+vAvBFjrLWq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-21 at 16:31 +0800, Zhu Yi wrote:
> On Tue, 2009-04-21 at 16:27 +0800, Johannes Berg wrote:
> > On Tue, 2009-04-21 at 09:08 +0800, Zhu Yi wrote:
> > > On Tue, 2009-04-21 at 00:49 +0800, Johannes Berg wrote:
> > > > The fact that these are exported is a technical detail
> > > > of the conversion period -- we don't want anybody to
> > > > start relying on these. Ultimately we want things to
> > > > use cfg80211 only, and once everything that is in wext
> > > > is converted to cfg80211 drivers will not need to touch
> > > > wext _at all_.
> > >=20
> > > Johannes, why don't you want them to be used by others, say some full=
mac
> > > drivers? These functions can be used as glue from wext to cfg80211 in
> > > the conversion period. After cfg80211 is ultimately used, they can be
> > > removed all together of course.
> >=20
> > I don't expect any binary drivers to start using them anyway, but on th=
e
> > odd chance that somebody was considering that ... I just don't want any
> > arguments at the conversion point that "we still need these symbols
> > because we released a driver that uses them" which would mean we
> > couldn't actually convert properly.
>=20
> Fair enough, no binary drivers. I don't have any problem with your
> patch. Just the comment "we don't want anybody to start relying on
> these" makes me confuse.

Sorry, my mistake, that should have read "don't want any binary
drivers". Everyone is free to use them of course, but I want the option
to remove them easily and without Ubuntu (...) complaining that it broke
their latest wireless drivers.

johannes

--=-uopftA27u+vAvBFjrLWq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ7YpbAAoJEKVg1VMiehFYhv0QAK59qpTRuJf/zrq61rJGagRQ
kxup8qsmkfpsON6uz3J0axB6yeqoKGSzGhtja2gJ1s056eO3Kmmg7vBpiaFu8+Yf
FbGVkVo9SVlp76+xv3RWjrbI1kkb1Zw4H+031NqUBF5Y5KpaQmdMBJab1Vwq6VKe
l4ctC/pAs9NhEJpisdDJHWvVz4a47j41JieHW+tNRLvB9Mpco+Sk+TMIXAZ3p7Gk
/Dq4QiK6eKgx6R1gDzqn2oVX41wj0xdLKvs61j7e7f6miIWcC+JYojRSjUOA+GfA
aiCtJEAcVYIHvfWU7D9Yi/rHYrTaxM07WatdEnpou1XecuM/0wpoxYJoEYKgaTRe
KivTz0+0tf9ZNN9hTFVkV62Vw61lirWqipfCLlKP4tDWXXbKMeS4AhzgCptn9R8y
pu5XoZZq8Z+U49Xi2tDnJQtFHzHi2DlXB0wnev6apZslZZXCr2gEhEXHq4JsTD/y
+NVhQJMQVNp75ILP9Pu4jnpCDcSVmp2SaGN4ochRaFkR/dvD3JvXV0PYT3yArucr
+rvT5ZrlN7DfUX0S3CMSa6ihGikfXrFvxWgvBay6GkMwZKEwYGezv24Y4qFAi9I3
Q4dEZRii11FykvLCwwRKK7YHSrNYCoz+Z3aERWsv+h3Ve/xF9qoFPkT/oPcBRWWS
kLRQxYrY3KIrInUl7iCb
=EzhV
-----END PGP SIGNATURE-----

--=-uopftA27u+vAvBFjrLWq--

