Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60536 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbYJNSSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 14:18:12 -0400
Subject: Re: [PATCH] ieee80211: make it depend on drivers that use it
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1224004808-20992-1-git-send-email-linville@tuxdriver.com> (sfid-20081014_200836_442263_957993D0)
References: <>  <1224004808-20992-1-git-send-email-linville@tuxdriver.com>
	 (sfid-20081014_200836_442263_957993D0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PibZ5anVVmUofi7gyk0A"
Date: Tue, 14 Oct 2008 20:17:37 +0200
Message-Id: <1224008257.3027.2.camel@johannes.berg> (sfid-20081014_201816_232125_EBB1C0FB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PibZ5anVVmUofi7gyk0A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-14 at 13:20 -0400, John W. Linville wrote:
> Make IEEE80211 depend on IPW2100, IPW2200, or HOSTAP, which all select
> it.  This removes the need for users to select it manually.
>=20
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  net/ieee80211/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> diff --git a/net/ieee80211/Kconfig b/net/ieee80211/Kconfig
> index 94ed7d3..44831db 100644
> --- a/net/ieee80211/Kconfig
> +++ b/net/ieee80211/Kconfig
> @@ -1,5 +1,6 @@
>  config IEEE80211
>  	tristate "Generic IEEE 802.11 Networking Stack (DEPRECATED)"
> +	depends on (IPW2100 || IPW2200 || HOSTAP)
>  	---help---
>  	This option enables the hardware independent IEEE 802.11
>  	networking stack.  This component is deprecated in favor of the

Users will still have to select the crypto options manually I think.

johannes

--=-PibZ5anVVmUofi7gyk0A
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9OI9AAoJEKVg1VMiehFYV58P/0KmbV1DtTuw7lSvkcM2t6uy
Y3E7eYNnaomNNY+cNa+NdNx7LbCI+G7xDfhP23DVC307nyAflJxFr9JHQZqv/GYk
d+s2FMX2Ej2i3sRCFwA2IWf5XISv108b9ahKNRei+Re+ra4kV6XUyDeDcMdUeHD2
sZ1OprJP1htTjRZ0zQAPF3vodM6kGO7pax6EJUa+apkohF84iFz1z59W4bnbCC0z
i+g+uELjOATqLYaU4Bzqfw65II55u2bUmCE+A+y9zHPJF0cVQ3LX/9NN96xhOEz+
2q3vINjGRnUKcDmUfMKdhCrooL0K6HdPDhksc4dPlhRrklqKE9xKX9YuZAcw4fJA
oW91EKfQeAVxlsPH5oKROHwOtC3I7w+T78YJGzKau3LCzR/j+/Ih7DYRgjyB4klZ
bk2v1SS5VFfo2NlOe8TwOomGDhgBMV7kiGo7UCuDxbnc0/qkRVUTyS6UK/qzrTfa
d/8i+6UBKy1shTuA1VemGsfh/0YhDY7p/u/mGy6BB6Ze+Cyl5u+GjN/+lV22a+xh
qQAi825yHLA0bm3JvAd84WRFHDbggWZsYPsZeULz8NQNC4JoCpTISFTlsut09cR0
TFg6fxc0pZ0jzWpa19fTo3Kc6858gIkOwSOW9Ykv5SQRLM/KElvyDFlR0i/t3UGn
uSZgNoSSylU6FV2s8OTM
=oV21
-----END PGP SIGNATURE-----

--=-PibZ5anVVmUofi7gyk0A--

