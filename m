Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49196 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbYLALRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 06:17:41 -0500
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@googlemail.com>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200811291150.16702.hrogge@googlemail.com> (sfid-20081129_115023_268131_EB6EA5BB)
References: <200811252131.30161.hrogge@googlemail.com>
	 <1227646037.4613.46.camel@johannes.berg>
	 <EA31B699-C803-460C-8D90-9E946CC97A33@linux.intel.com>
	 <200811291150.16702.hrogge@googlemail.com>
	 (sfid-20081129_115023_268131_EB6EA5BB)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nXE20Hqb5m/KLjTMP4dg"
Date: Mon, 01 Dec 2008 12:17:36 +0100
Message-Id: <1228130256.3478.5.camel@johannes.berg> (sfid-20081201_121749_005247_7AD8F66E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nXE20Hqb5m/KLjTMP4dg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-29 at 11:50 +0100, Henning Rogge wrote:

> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
> index e08c8bc..a9639fa 100644
> --- a/include/linux/nl80211.h
> +++ b/include/linux/nl80211.h
> @@ -413,6 +413,8 @@ enum nl80211_sta_info {
>  	NL80211_STA_INFO_LLID,
>  	NL80211_STA_INFO_PLID,
>  	NL80211_STA_INFO_PLINK_STATE,
> +	NL80211_STA_INFO_SIGNAL,
> +	NL80211_STA_INFO_BANDWITH,

Even if you corrected the spelling to "bandwidth" you'd (a) be missing
documentation and (b) be using an entirely wrong term for what you're
doing.

johannes

--=-nXE20Hqb5m/KLjTMP4dg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJM8fMAAoJEKVg1VMiehFYOEAP/0rQUKb1D15NDY6JRYZvs1Q7
0/Zw1U4MtEcGA5EFwumlEkadH1N0pO4gRg/L8ryEtovnOgr20wbu24OPTy+ciOAB
TxA+KJk6tY7vrOC6Uue2KJb4GUqDUfuk2WGjKq88okJqMB0wBJqycJ+PAzY+pjqo
t5u3pMX7B+E7cfvIUSX6wNl6ZeNLrBq8GYU4DXx7gajGeTb89WoJnug51TuGKnu5
zSa8022nzpBJYMhhUYjl96hG5igD8zJGUEyqz0dpqPvbQ/67XetzvMWRsNaS6csC
IQutDytYfUD1MGOFGKHE9C0LZb51LIekFCTCvDFeqAPW3ZenVmx51tiZwnP1gd4v
3pSZTYvceo720PDQbm23hSkEp8PDiFnaTauXaRTZhKHClq6cOGB28anVUYjXg5sJ
lD/iFK8r7V/ktmzD4uN6fobFdGjZUkKs/sxgDIaqT/uwzSDv6pQaJNtOyoaWsZjM
38vFhwtssAMALxJDcjYcPW5KtAySVo6Z0ak3KUjnbY7WbJm5a1TNLS2jr/PR1dao
52Lpq6X6PL6lfLJp0PTrAEwO6Gg0+D0LTEPwyRdwMJxiT85O3HU7h5OncA4QyMJz
0wawhR9aZnm3BQd9O5tP8+iCsb2m+lfiU8UoqVdPEW387OTU3M74QI9EQQgL+8a6
Azwag8rT9eEBBG0iNpSx
=J+U2
-----END PGP SIGNATURE-----

--=-nXE20Hqb5m/KLjTMP4dg--

