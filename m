Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51493 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbZAMWyZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jan 2009 17:54:25 -0500
Subject: Re: [PATCH 07/12] cfg80211: allow driver read access to
	cfg80211_regdomain
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090113225112.GT4416@tesla>
References: <1231876675-20518-1-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-2-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-3-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-4-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-5-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-6-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-7-git-send-email-lrodriguez@atheros.com>
	 <1231876675-20518-8-git-send-email-lrodriguez@atheros.com>
	 <1231886819.3728.2.camel@johannes>  <20090113225112.GT4416@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ClW0EpFqI2tL3MwY+aIu"
Date: Tue, 13 Jan 2009 23:53:58 +0100
Message-Id: <1231887238.3728.8.camel@johannes> (sfid-20090113_235429_541751_6ADF6279)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ClW0EpFqI2tL3MwY+aIu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-13 at 14:51 -0800, Luis R. Rodriguez wrote:
> On Tue, Jan 13, 2009 at 02:46:59PM -0800, Johannes Berg wrote:
> > On Tue, 2009-01-13 at 11:57 -0800, Luis R. Rodriguez wrote:
> > > A driver's reg_notfier() may want to inspect the currently set
> > > regulatory domain.
> >=20
> > > +const struct ieee80211_regdomain *cfg80211_regdomain;
> > > +EXPORT_SYMBOL(cfg80211_regdomain);
> >=20
> > Can't we just pass it to the notifier instead of exporting it?
>=20
> I as thinking about that too, sure, either or is fine. Any preference?

I prefer not exporting it. That makes it more local, and saves the
export. Not that I see why we need it at all? You're not using it, so
let's not do anything with it until we need it.

johannes

--=-ClW0EpFqI2tL3MwY+aIu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJbRuDAAoJEKVg1VMiehFYGMAQAJjPypgtXtNnIO/N3IqUm0i7
vcUOrlbVe9HglDm1vxGKtT8ifWwJX5GQRCQQotyZZOax/1JLtZCcKxUYF7wttw2J
9W6/A72icgRL0YkiLfBSYaT7LrpxNJUypvFYId3uWvA74HnQOGWdytqHKeivOC+W
S15GhGQPOteUTsM7OEt+K5n3EkK7xJrRvTeIce+4SmXhOhidY3GUXbv5QtvfqT4k
xRx/7Gahj3vJDm6OBB3p+Eb5V7qcOu6YC1Wxd8T1w2kXmaH4DDw63jyhJ76Vu23Q
s+d/y5taDFYG2ml51XCFP9XaC5OLgUKRn9yz2H84q00Z1+10rGv4H40aeVYIbSss
x89kgmlZLuqdxhBHuw5mMBlo6ff8EB+hj84JMGBFNv0jW1GbBiUWnPvhfCTwCt1L
74SG3BJu4v3hRY5VjJKdakKrpHdlV1KcEfXt94LZL9nub03B4itVnlFTWcWwosHs
46enaGlvR5uONJ40kFWjKd+yfKwNU9wJ0jBGU7E00DwyGf1HWP60dnTC22jYp5kc
BNHfzbev9VsGZaaojj8nkq2Nsh5LRre7srpHMnC23vmtwgrW7e38aLVbJqmjr+q1
LxWpmMKEtCHmpyPKRTWlGQw/uzW2+wKEpye86s6sz7qNN5JXeyVxo5aTV5E2SkZX
yuzzqxkJiWu6ssrgSNth
=VUqY
-----END PGP SIGNATURE-----

--=-ClW0EpFqI2tL3MwY+aIu--

