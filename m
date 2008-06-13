Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37303 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922AbYFMH5f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 03:57:35 -0400
Subject: Re: [PATCH 1/3] iwlwifi: adding channels to sysfs
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
In-Reply-To: <1213343095-8133-2-git-send-email-yi.zhu@intel.com> (sfid-20080613_094711_143440_9808BC8B)
References: <1213343095-8133-1-git-send-email-yi.zhu@intel.com>
	 <1213343095-8133-2-git-send-email-yi.zhu@intel.com>
	 (sfid-20080613_094711_143440_9808BC8B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-87WSRr4SI9IhU7X8xiLK"
Date: Fri, 13 Jun 2008 09:56:53 +0200
Message-Id: <1213343813.3860.0.camel@johannes.berg> (sfid-20080613_095738_723149_6EA31056)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-87WSRr4SI9IhU7X8xiLK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-06-13 at 15:44 +0800, Zhu Yi wrote:
> From: Ester Kummer <ester.kummer@intel.com>
>=20
> This patch returns channel list to sysfs.
>=20
> Signed-off-by: Ester Kummer <ester.kummer@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl4965-base.c |   58 +++++++++++++++++++++=
+++++-
>  1 files changed, 56 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wi=
reless/iwlwifi/iwl4965-base.c
> index 81a1c22..c179b21 100644
> --- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
> @@ -4122,8 +4122,62 @@ static DEVICE_ATTR(power_level, S_IWUSR | S_IRUSR,=
 show_power_level,
>  static ssize_t show_channels(struct device *d,
>  			     struct device_attribute *attr, char *buf)
>  {
> -	/* all this shit doesn't belong into sysfs anyway */
> -	return 0;

Hehe. Do you really have to? You can query this information with
nl80211. I don't know why you need all that sysfs stuff anyway.

johannes

--=-87WSRr4SI9IhU7X8xiLK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUihAAAoJEKVg1VMiehFYqmAP/RmnmFJQLZ4qYreUWyVqbFyK
M8A8QA4ByToSZVaxad1MAZaDps5aQZs3aqN5XZFIZt/Yl0HmeYCDeqhqctukPeKQ
7W3vYLoO6uL/l3diJZigvDMiuPpzRDmkdsRLayzvow30nkS6qRIkzqGhh/tQBBW6
x6C5IHmBOu+650yZU7lqS9pPcbybs3k1EbrdTEKg8V56yXsCC70kKLdKz8fOH5np
HykWsvc0nM2Z73M+efd1bdf25kR/1DZ49O2W67yvpE3OMFI9LW7zfAWlZeJdVROI
yxKogz3kClFST1qrqn+FWApVK/lux5M6mUagDZIxC+YQx5pIBdIXyld1oIDwYCtS
vQg6JGq4my883YTZ/l9EBabFhqcRT+nvKK1pUFbuUYZIwH/OKO4CJaYWBS2l1Jfa
bjmzFTM01zBlk7VxABeD1/JQRzAYTXMwrST1bj9bEwYxeNQbLQMsDRyeKrtBGRM4
paI6i5kyeQP8PwLqlEsWIjoLXokYvc9NBgL1LrUwCatnpi8xqJlD7yuPMrq3xaBZ
LrLTAtjCzX44j4Om26M2FumJegiBcWua2lkAjL8S+YlFklFGGAWwvE9Kv3G6koe0
WW88hDdk8if/9WTp8bI2flrJ+k81uFyxFHKjtXoRaNFS762oSLFp6ecnHjxoK7Y5
0WrzKcEggTU5kGUAeE+z
=cTGb
-----END PGP SIGNATURE-----

--=-87WSRr4SI9IhU7X8xiLK--

