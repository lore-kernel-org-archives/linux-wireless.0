Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43033 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760897AbZARRPQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2009 12:15:16 -0500
Subject: Re: [PATCH 03/13] cfg80211: add wiphy_apply_custom_regulatory()
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20090118153134.GT29609@tesla>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-3-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-4-git-send-email-lrodriguez@atheros.com>
	 <1232097659.3854.20.camel@johannes> <20090116163646.GG29609@tesla>
	 <43e72e890901161413n3fdd7031lfdd0a363941b697d@mail.gmail.com>
	 <1232184649.3668.2.camel@johannes> <20090117220636.GO29609@tesla>
	 <1232268557.3877.12.camel@johannes>  <20090118153134.GT29609@tesla>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NXau7zqkPettJMH+Xf4c"
Date: Sun, 18 Jan 2009 18:15:10 +0100
Message-Id: <1232298910.3819.9.camel@johannes> (sfid-20090118_181520_626768_DD4EEEC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NXau7zqkPettJMH+Xf4c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-01-18 at 07:31 -0800, Luis R. Rodriguez wrote:
> On Sun, Jan 18, 2009 at 12:49:17AM -0800, Johannes Berg wrote:
> > On Sat, 2009-01-17 at 14:06 -0800, Luis R. Rodriguez wrote:
> >=20
> > > > > >> > +static int freq_reg_info(struct wiphy *wiphy, u32 center_fr=
eq, u32 *bandwidth,
> > > > > >> > +                    const struct ieee80211_reg_rule **reg_r=
ule)
> > > > > >> > +{
> > > > > >> > +   return freq_reg_info_regd(wiphy, center_freq,
> > > > > >> > +           bandwidth, reg_rule, NULL);
> > > > > >> > +}
> > > > > >>
> > > > > >> Are you not using this or am I just not seeing the user?
> > > > > >
> > > > > > Yeah -- good catch, its just cruft left over from my previous w=
ork.
> > > > >=20
> > > > > Actually  freq_reg_info_regd() is used by handle_channel_custom()=
,
> > > > > hence my comment on re-inventing the wheel. But yeah it used.
> > > >=20
> > > > Yeah but not freq_reg_info?
> > >=20
> > > That one is used by the reg_notifier() in ath9k to inspect the countr=
y IE
> > > regulatory domain processed.
> >=20
> > ?? It's static and not exported, so how can ath9k use it?
>=20
> Patch 04 in this series fixes that.

Oh, heh, ok.

johannes

--=-NXau7zqkPettJMH+Xf4c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJc2ObAAoJEKVg1VMiehFYkhoP/14DrB8LLofLyBThwg6pdCgB
xpYW/jOXxOibaRXowXWn6AFxCVJilPuE5elYMZvixME70T09A7m1AlGmU0n9E+FY
DTk1M+mP8XWnykWZSnZgRz8SlHJ/0PFb1c2HNepPZTzBpVcLX7bR9RgD6qGPQ1uD
cBMHKbbHKnhgFGQq/B8RxCOE52HzYdCeNVMLSCWxC95boK3eM5LsfjI5fSIj4jxj
vZGS45OC1Po6PCTOHnwDODTQMb91LWu92ALPVPNfEA0ZcsGP1qSejTYs33gRSkpv
gjvPgKhPA880D9Hb4r9WpHH+LgxbAw3r0qtmM13UaKyBJZ11s23l/hpgsXeR7HWN
60zBB6lYTExhSLK05amVPQ983312Jq1lm51QGYWis6G6H002uHByXyVuUey2fIBa
+0/AXhPho8P5ah7NuQcyBYIVHgbp3RPePUyj0W/nppp2/D8oEkAD+Ud0IRyyhyxH
t1mozbSU8Vs4D3gcqEmDEF3ztSOD8lfZxZQxUfZeyR7PJ1QZb2RCoXCsMj8Q4/ED
XQG/oRl+c3gRgW+ozpEy890ZS1CgoRYe34loH2a/ocfVr9fja6rlqtqXGo0YFZ92
t+0sKWyW1yaVIaej9ZroG2GBY8Jpvk/CmXxKv2hbHCsrijzrRH9r+43qIN9t1jTv
/Q2YoQUFpSWFT8PenvwL
=Hc8y
-----END PGP SIGNATURE-----

--=-NXau7zqkPettJMH+Xf4c--

