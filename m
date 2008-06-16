Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35962 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbYFPMxT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 08:53:19 -0400
Subject: Re: [PATCH 2/2 V2] mac80211: 11h - Handling measurement request
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Assaf Krauss <assaf.krauss@intel.com>
In-Reply-To: <1213615217-10777-1-git-send-email-tomas.winkler@intel.com>
References: <1213615217-10777-1-git-send-email-tomas.winkler@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PviqQf0cb6UJtw8Q4IvW"
Date: Mon, 16 Jun 2008 14:52:40 +0200
Message-Id: <1213620760.3803.30.camel@johannes.berg> (sfid-20080616_145322_683722_73E07D56)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PviqQf0cb6UJtw8Q4IvW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-06-16 at 14:20 +0300, Tomas Winkler wrote:
> From: Assaf Krauss <assaf.krauss@intel.com>
>=20
> This patch handles the 11h measurement request information element.
> This is minimal requested implementation - refuse measurement.
>=20
> Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>

Looks fine to me.

Acked-by: Johannes Berg <johannes@sipsolutions.net>


> +/* measurement */
> +#define IEEE80211_SPCT_MSR_RPRT_MODE_LATE	(1<<0)
> +#define IEEE80211_SPCT_MSR_RPRT_MODE_INCAPABLE	(1<<1)
> +#define IEEE80211_SPCT_MSR_RPRT_MODE_RFEUSED	(1<<2)
                                        ^^^^^^^ typo

> +	msr_report->u.action.u.measurement.msr_elem.mode |=3D
> +			IEEE80211_SPCT_MSR_RPRT_MODE_RFEUSED;

search & replace? :)

johannes

--=-PviqQf0cb6UJtw8Q4IvW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIVmIUAAoJEKVg1VMiehFYaMcP/itEnxbCIVn+uSZGvMi3ba+5
IaroFFOMSDZwS0kABweR8rUh6nIM6ejHL6yyHNdLIRfsZKI8GpiFAvMcSGqi2XwV
XNS3NcP9N7gTPgmbXienWyyUBLP3SGSzcvIh7P6M7kPfUFaIxUf6GWGbkhRlIHAs
K2ufBM2krYuteTV9MXJAbIbr+UbUzQw63IXNO36bsW/1IOrDsGUqUQz8BqZ4a8BV
y9CIeWpAAJIcgS7W3SIMzkz3Sz1+aBeXs1DejgzkvueOHh2hCU82W4CCfAuw6eXX
nswUBImogLbLxGA8omq4mGSlueEDFx8Oze7o2vT/Sj4QBZxFz1qRXeF/SR40vp0C
sNJei5pjI9APe/phVyPTNcGPJejd/TM7Fwm0Qs9/GhFo/D0neV+LjdaiLa1FTyqq
zdYVGJKeYzQxGpGBWqTliWInWqbI2zfd6+fri1uUlLZYVUHdI+uv8tfPPPRt/sXz
vNyJUKx8f43+ewqunChOExuxEyHbzLhzwRsLt6wsGOBpsYLZy03PF2tK/27vaYrD
XRKG8hrg8SFUDvamTxTsPeU3G6ZFYewYwz2wYl6SJZ9EWCJdnZFx2E0TWx94xt9q
pGMqofCFEGKIYrCbOmxq63PfeKO/40O1KLFhCZYnymszkqXNVawo6lCDEnV7r34v
n3YPg6BnF3xpTSmgMyvU
=1O6l
-----END PGP SIGNATURE-----

--=-PviqQf0cb6UJtw8Q4IvW--

