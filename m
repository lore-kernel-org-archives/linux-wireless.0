Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXKOQs0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2007 11:48:26 -0500
Subject: Re: [PATCH 02/15] mac80211: adding 802.11n definitions in
	ieee80211.h
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com
In-Reply-To: <11950542003481-git-send-email-ron.rindjunsky@intel.com>
References: <11950541913679-git-send-email-ron.rindjunsky@intel.com>
	 <11950542003481-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TA1nbC8XZ9F1HrBSJq3N"
Date: Thu, 15 Nov 2007 14:36:00 +0100
Message-Id: <1195133760.13846.58.camel@johannes.berg> (sfid-20071115_164832_927050_A04CE9C1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-TA1nbC8XZ9F1HrBSJq3N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> As 802.11n depends on and extends the 802.11e standard in several issues,
> there are also several definitions that belong to 802.11e.

Btw. It appears that Broadcom implements at least block ack in non-HT
STAs (they also implement aggregation but that isn't specified before
802.11n afaik). Is there any sense in supporting that?

johannes

--=-TA1nbC8XZ9F1HrBSJq3N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzxLP6Vg1VMiehFYAQKJ9w//QNfStv49WMz2UyJlY3trMo472e3vRcVz
TMFUfDhXWORNez3M1dDnzx3Q2FnqL8ry15wPZ0Z63zhRDc58ozRt9mJjqU+DbCig
SItPqJu4b5+FW5ngsKMY+mCRhkXK1T7JJrW5vd1+Kjn9i7W5oxp7fy8LjDcTpVor
nAKqD0A4Yv4ijw6Fa6BRe9Z8XMDM5xw5wDOMsbsQfwaMNZcUpj5PiNPQrQoNCony
Z8HTzCjldl3O0/dmLI1phCzgfAEoLoXEqTDg12Yi90cCRu0Ebb6+657cvEe5W0zS
mM9DftFJe+K3GaV1ysQ8Tfb0RO1zTkHtlmmcsR98rOz0qZtsRZTLJrgep9UogehR
KQRwCXc6tl5LH2KuDpz6DPSmUHyqyoZgmuAqQOtb2JkURgdJ1x7FlYpVJvU8Hlrw
Ow8qCfWcPo1JeoGNt8EbMa6jH8ZmOxczUhCvcUMgsFNDYX0smn2z9cag9sQtNgy6
4eudFsy257Aic/gBUwaci34LpTpqB5gO1qxcFV/ySfd3NOTHZWtJGSEo7ValgA+c
vKQccvYzAvbivutQIIMSIhTLEkSoUvPuq5gUB7NwXYTyL/tR1qYSUoZc1t1ucVmg
23rTGXJi9pEk0qlK5eXGTt4w3V9w+IbIAlWUyLI5+3tGXbk6osOBcA0IdEvrqKBP
WqoZNjsW7ng=
=Go9g
-----END PGP SIGNATURE-----

--=-TA1nbC8XZ9F1HrBSJq3N--

