Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43410 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380AbYJ3OZI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 10:25:08 -0400
Subject: Re: [PATCH for 2.6.28] mac80211: fix basic rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1ba2fa240810300623o51dbd0a6p7a7bc89795dc5d35@mail.gmail.com> (sfid-20081030_142402_193289_29E9C9F2)
References: <1225300446.5439.27.camel@johannes.berg>
	 <1ba2fa240810300623o51dbd0a6p7a7bc89795dc5d35@mail.gmail.com>
	 (sfid-20081030_142402_193289_29E9C9F2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mKlAmFZDLfB0glgYdToS"
Date: Thu, 30 Oct 2008 15:24:52 +0100
Message-Id: <1225376692.3690.46.camel@johannes.berg> (sfid-20081030_152512_491957_E5083E8E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mKlAmFZDLfB0glgYdToS
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-30 at 15:23 +0200, Tomas Winkler wrote:
> On Wed, Oct 29, 2008 at 7:14 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > This fixes the basic rate bitmap calculation in mac80211.
> >
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > Cc: stable@kernel.org [2.6.25, 2.6.26, 2.6.27]
> > ---
> > Is this appropriate for stable? It's a trivial and obvious fix, and can
> > throw off the duration calculation, but it's likely nobody will ever
> > really notice...
>=20
> You would should fail association if one of the basic rates is not
> supported  by the station

No, this has nothing to do with association, it's just setting the
internal variable about which rates are basic in the BSS.

johannes

--=-mKlAmFZDLfB0glgYdToS
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJCcOxAAoJEKVg1VMiehFYO70P/2znqiOHry5pzudXBaLz3Kvp
IC09j9jHtbGNs2M7+JPL9OiEWTjTJAZSyCPzBBcIqyEkCk7zpZ6T1BtWDGl0Fa2i
eE3mDacrOX01hyiNC2a286BEp9g/tVoLoGuJp0rUC+x1J68oRx1OuM1FEeAyaLRm
93IX7b7JlGCS1BkJBfV2uARqT9qyn9ebB6z/NyUzVvFIHakn6AXgegC6sNFWeRsl
3a7gBuqtRZ05ZzHSX7oAeYYwMtbbbnFZRE4PfPSjkAnpEhfKY6XsIdkrg79ZuRLA
XKYlB0U8F4Zkb/+tGGGkfC62xzbsBcX4z1g15idk8WsFQklPFh5mnXL8Hvugi3Uk
hHrOveTs+rN5QukChLr6T0t/W0EnNrKAbx7vYzaBDJshvf2T25WeBzlVRv0IwA4d
D2izxJWu6TkXbFUSKojgbEmXj+DDLWK01B4f7qkCzOzpMAF/kOB+/goXKV6OkJiL
5vTEH1MY1REncM59CP8byqh6wQr1UDovSrOg2Y/HFOP4C8Hnx8+C6IPtYPLuFq2X
6Qzasc6Pvjo6ov2oV3H9zteLfBRBAgDJZuTsRhe2kCsZLQufz5kYIc86uzGsCmwL
jt+wbBkbmDT6+3qE1fjKRna5nQx4QICl4+qPKQ2VH5zugIxpZ+2GV6EB3m+OnxgW
T/qf9VoXow5Y1E0YBv9p
=ebZ1
-----END PGP SIGNATURE-----

--=-mKlAmFZDLfB0glgYdToS--

