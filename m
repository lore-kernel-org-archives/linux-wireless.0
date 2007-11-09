Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbXKIUTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 15:19:03 -0500
Subject: Re: [PATCH 10/14] iwlwifi: 802.11n handling probe request HT IE
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomas.winkler@intel.com, flamingice@sourmilk.net
In-Reply-To: <1194595332620-git-send-email-ron.rindjunsky@intel.com>
References: <1194595326527-git-send-email-ron.rindjunsky@intel.com>
	 <11945953311871-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312850-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312367-git-send-email-ron.rindjunsky@intel.com>
	 <1194595331658-git-send-email-ron.rindjunsky@intel.com>
	 <11945953312456-git-send-email-ron.rindjunsky@intel.com>
	 <11945953313491-git-send-email-ron.rindjunsky@intel.com>
	 <11945953313626-git-send-email-ron.rindjunsky@intel.com>
	 <11945953311042-git-send-email-ron.rindjunsky@intel.com>
	 <1194595331715-git-send-email-ron.rindjunsky@intel.com>
	 <1194595332620-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3NC8kQqk4u9lDuQHdIFJ"
Date: Fri, 09 Nov 2007 17:52:28 +0100
Message-Id: <1194627148.4793.150.camel@johannes.berg> (sfid-20071109_201906_289420_39FE691D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3NC8kQqk4u9lDuQHdIFJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-11-09 at 10:02 +0200, Ron Rindjunsky wrote:
> This patch conforms the probe request's HT IE with the
> new structures used in iwlwifi HT.

Maybe the mac80211 hardware scan API should be changed to pass in the
probe request frame? That way, the driver wouldn't need to do all the
"directed vs. undirected scan", HT IE stuff etc.

johannes

--=-3NC8kQqk4u9lDuQHdIFJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzSQTKVg1VMiehFYAQKtghAAibqeZ8+S4JlZudt6i/F5yJIHLpuSoTxI
e7LEkh5WvE8MF56M1H/zezmEjMtQFdcgZDOu9opcQzORLwgz6nVLOaooX8zCirav
Qr2RlNpJFCj3ET8EGRSu45TTzU5p7mH7gvpH4KsjW3CRIQDVSvFzjxR5UJUsoHwn
jZOTopV5JtKyh/Cf4ID9esgeDxZYTMl/fI8C7Z79cGnIMXvZuyGq/KEgU7OirMWe
Qgj5xOI25mCkHLES9FWhw7gZASW/vxPxh2kDTt2dcP2SOLOo+gEbj8rFDTUQfezs
9XPy1GyA6Mf9C1PPcKzi0K0oVn69xX4ly1H+DadXdcjEmm0j14PyEnxxD80fIUsg
KM8YJf+WDnSxJj2h8MZtSCMBCGraowvWWcp+Ct4q4Fe2iw1pUaVv9JkIi7/xLP0h
JoFdVl+y5LVyPS03RquzlOOb4C6t2vayYNwkC1jYLKLrqV1muL3tBuEHN9BWvoLj
EfKCw4oJPPuny8pa/AlcSu20rgeF8NZj9+my1eZOZcCI9DMw6zQHfTdMb3HGrcOS
+UHsj5lamAQ7cQCq1nB1/9xSQXfmKMdQFQrvCxiizdeX3EQNpNN/J4kAVeZzekPh
PUx+OMPHf9M4XQawxW+xRhCeWNplc9sJdgo3g8pnEqtoF6UCFN2DLHvICTl2dCAb
bRzvYHIKJfU=
=5TwU
-----END PGP SIGNATURE-----

--=-3NC8kQqk4u9lDuQHdIFJ--

