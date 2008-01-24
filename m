Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbYAXO5E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 09:57:04 -0500
Subject: Re: [PATCH 05/12] mac80211: A-MPDU add debugfs support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <12009163391538-git-send-email-ron.rindjunsky@intel.com> (sfid-20080121_115442_600581_DD9FB5B9)
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
	 <12009163391538-git-send-email-ron.rindjunsky@intel.com>
	 (sfid-20080121_115442_600581_DD9FB5B9)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WIXByM0ZRCI1mmEvFt1M"
Date: Thu, 24 Jan 2008 10:45:52 +0100
Message-Id: <1201167952.3454.79.camel@johannes.berg> (sfid-20080124_145714_053028_2BE14770)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-WIXByM0ZRCI1mmEvFt1M
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	if ((tid_num >=3D 100) && (tid_num <=3D 115)) {
> +		/* toggle Rx aggregation command */

I think that's a bit odd, but I guess everything else is more work.

> +		printk(KERN_ERR "%s tried switching tid=3D%u %s\n", __func__,
> +				tid_num, state);

> +		printk(KERN_ERR "%s tried switching tid=3D%u %s, return=3D%d\n",
> +				__func__, tid_num, state, rs);

KERN_ERR is a bit excessive, don't you think?

johannes

--=-WIXByM0ZRCI1mmEvFt1M
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5heT6Vg1VMiehFYAQIJqBAAwaqjdD3t+RjZ3EPPu1gpgq/BMhzCs2Iu
x0MN6IXoai7+roobm38CfI2Ije92eoH8dlC50JJFS81kHFHBZXQj6HGtMIijM5zB
5bYLuWz2WNZB4SPMTuTiuZdqV9aaQ5TCWHdVHnB+FmevzKI4NNa47KLQEVdUjF6y
1jVlKdJvkogL2TMAfav8yGdZNEwm/SFlLkP98EycZZRgXJaCT+HOmFRh4s5IYH5M
hVwQnJvma8/NSBx8ryrcvdspYCPLGYaa+ukZwsYfnzBBclpyN2AtwMT5t6gD8zIw
B01NxQyt5IB0EpEih808oFhyNxfXBdzQEdHENmVglNsDwX18S0jUds6VpMkvaGAS
1eIjzIOY7D4QQJvui2bCwQ1jk64DJmHoSnbZRZGwJlgfbp4rYfrvjCYeaLrvxHzO
NwY2dbKh4eN1NRavfMTQEsU8OLAefrdlbC/IzYNhqVWDUA6B8SzhjB9rhh0MHQ4j
l8TwBlryPpK5NMzrR3yckkHvALGDjq7LkDtX192elLgJBBNsoUC0Nn9v7YQuq+b4
bgGm5luZ4ZQbqFL0+5govWBhJoH/fTgir45GwS/QvfaBPUifQauSP0sEQUsApSjY
+4MhxQ2N43rFgCjnzY6wFiux9Z5hnpTy/420cE53wF4eqkxzUg2t8+ctEUtbsZw5
CyjoBTCDrz8=
=te9l
-----END PGP SIGNATURE-----

--=-WIXByM0ZRCI1mmEvFt1M--

