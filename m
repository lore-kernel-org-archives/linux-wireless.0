Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759857AbZAPJRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2009 04:17:16 -0500
Subject: Re: [PATCH 01/13] cfg80211: print correct intersected regulatory
	domain
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
References: <1232064746-17134-1-git-send-email-lrodriguez@atheros.com>
	 <1232064746-17134-2-git-send-email-lrodriguez@atheros.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eWmKCTLEITQVtLkheF2p"
Date: Fri, 16 Jan 2009 10:16:43 +0100
Message-Id: <1232097403.3854.13.camel@johannes> (sfid-20090116_101726_635665_42085D17)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eWmKCTLEITQVtLkheF2p
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-15 at 16:12 -0800, Luis R. Rodriguez wrote:
> When CONFIG_CFG80211_REG_DEBUG is enabled and an intersection
> occurs we are printing the regulatory domain passed by CRDA
> and indicating its the intersected regulatory domain. Lets fix
> this and print the intersection as originally intended.
>=20
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Acked-by: Johannes Berg <johannes@sipsolutions.net>

> ---
>  net/wireless/reg.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index b34fd84..ec8b3d9 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1332,7 +1332,7 @@ static void reg_country_ie_process_debug(
>  	if (intersected_rd) {
>  		printk(KERN_DEBUG "cfg80211: We intersect both of these "
>  			"and get:\n");
> -		print_regdomain_info(rd);
> +		print_regdomain_info(intersected_rd);
>  		return;
>  	}
>  	printk(KERN_DEBUG "cfg80211: Intersection between both failed\n");

--=-eWmKCTLEITQVtLkheF2p
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJcFB5AAoJEKVg1VMiehFYH2AP/iUY++sGySl/BFrJnqeb3ml9
jjFb9B+EBSBTEAXjfKXZY8N7Lo9S3aTDWG1LJSKgIecbwQVOb2+Ov3G+hY0BtZOp
g5tEppOsqtuDxcrHS/cvNoDIjuJsNeuiVyPmuM+6avMCYGN2yM1Vl0UjDc+iw4yw
hU75ZdKyiqdK440c5KAiS4wFcH2fQY7d6GpzL3ST328qOC444wcsN80aqrW2xFuj
ParFMSxDIXBIME/2tWHWWPG4fbDID3jRxHfUMfAUZDt/amSFaQeK5ZSD7bqpqJxf
wVeyS/rTCMBn2fop5fHIoQclhHyDvObRxaJMknnxVe3w4axPGehR+C5VUUaNI/CT
QJr3GV1YqBdU5lj20wdtRnwHNYwpASnH3wQtffJY700MMcFnBPUPrRuqp+zaUiSm
DlA9UAkcRTNcP1A+f/qYiGMheh42MkYQUVnjBRD7lGK0V/Yt8Qtk2LwP1t6hDrbM
K4mGza2HBboJvZGjxTk6OqMUHXkM5MhHg0Oq9kZzn7UFnBi8pCANGoeRAKI3CwYT
E+p2rX7bUrBqAq4YkMVnp0bXHXmWyQunDpyskdQMtdtxGXImaalS0Y/13XOkZo9w
4DwlRFSQlBZ3Ya0IWA4us60Ui66gqsd2ujClYs0qS1CGchTnA8M7wqnL4IBrGI6d
kbm8vyZC13p06SfWKHZW
=EHVv
-----END PGP SIGNATURE-----

--=-eWmKCTLEITQVtLkheF2p--

