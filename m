Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbYILHu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2008 03:50:27 -0400
Subject: Re: Crash with 2.6.27-rc6 with iwlwifi
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <holtmann@linux.intel.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1221185432.6695.0.camel@californication> (sfid-20080912_041007_653566_F8146EC3)
References: <E3A88D93-F0D2-476E-B162-08687FC602E3@linux.intel.com>
	 <1221123779.2513.88.camel@debian.sh.intel.com>
	 <1221184060.11498.3.camel@californication>
	 <1221185432.6695.0.camel@californication>
	 (sfid-20080912_041007_653566_F8146EC3)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gxYnUcUeel+t3X25jK5C"
Date: Fri, 12 Sep 2008 09:49:48 +0200
Message-Id: <1221205789.11204.4.camel@johannes.berg> (sfid-20080912_095030_848979_3AFDB965)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-gxYnUcUeel+t3X25jK5C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-09-12 at 04:10 +0200, Marcel Holtmann wrote:

> I take this back. It took a couple of hours, but it crashed again.

That's kinda weird, for me it crashes instantly on the first packet. The
oops still looks similar though.

johannes

--=-gxYnUcUeel+t3X25jK5C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyh8ZAAoJEKVg1VMiehFY8GQP/iAZp9vheUp2x70NSuPN9vWq
oM69p7pv1yG4P+q4p/xaO7xGVtilSWSCuAZn6SgkAJ7ddFur9dcq+6BG7D+zaFPL
SDkRw9+3pANOHZVyn7I0cMVB8jLQQUF5DKzLRVgUFPQzGx31/+Tq/ogIhX30OgPT
LIbKdOehZCNnrkwbd9/0SgRdhQJU/IU4kN7YHL/6iG6yca0ri2vfu7RsnaNEouD+
cq3w1NsWMeNW++QVnKFowFv4cjHisgzM+bNtB8dd9I0Ddmr1L774NW9OQolQDQsH
EQvMtBcv+9tWLpeG2Gf9OYg5OVGSvO8PsyUBMYAEBnHMDDCHdS9/KreBO1s8J8jm
BiesHFqXhj1gUB+Typs31KPWJv/d8/2OPiAMWmHxkuLifmGrYiIdec512kxiI8C4
FW1nSl0liS63W6M8GA7BqVRZLKuI/hCFKv8HTb6fdVlLv/rvShzt3/XFPTZIxBlN
WKZe5Oa+SrCkb6n6wYT0A1zSG9RMnitYW/Lu7tcwdR9T9CCL0t1Ow/CJnm7wpZFC
5rQbXuXMt6+Sx0WDI3N6pDDw9HlxCbE9uQ0EgM1WGPtqs7v6jDKZiDJrLlXxBZ1F
3fYX+rjoq/CnWl78ChaHwhCPBwao1ry3sRnAKJMt7mQzumnxEHtVjezRPiHbyG3s
G0g8ZaP6+xJkd9zc21a2
=d2V7
-----END PGP SIGNATURE-----

--=-gxYnUcUeel+t3X25jK5C--

