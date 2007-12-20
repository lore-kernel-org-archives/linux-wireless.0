Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33229 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbXLTKnW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2007 05:43:22 -0500
Subject: Re: [PATCH 0/8 v2] mac80211/iwlwifi: integrate IEEE802.11n A-MPDU
	Rx MLME
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
References: <11981435524069-git-send-email-ron.rindjunsky@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OdeCKBDsIC0rPv1GfcuR"
Date: Thu, 20 Dec 2007 11:43:17 +0100
Message-Id: <1198147397.16241.28.camel@johannes.berg> (sfid-20071220_104329_971214_B117E003)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OdeCKBDsIC0rPv1GfcuR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2007-12-20 at 11:39 +0200, Ron Rindjunsky wrote:
> This series of patches contains implementation for the IEEE802.11n=20
> aggregated MPDUs (A-MPDU) MLME. The series handles Rx A-MPDU (recipient p=
arty).

Thanks. I'll re-review once you've commented on my last mail from this
morning.

johannes

--=-OdeCKBDsIC0rPv1GfcuR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2pHQ6Vg1VMiehFYAQLENQ/9GrCwwYe26A7v/VevA/n5piQxBEETmSB/
+awHpEj6MMv3C/eTwLLUelOi3Kg6+Mg8EdUFQvAYDV3EBWKLucRxuh2kdtxv94Tz
um5Du49A5v+w9/FfPqoqjPFggLxwT87cVm6NVtzwYRb/TYEFzbfbbk4QDY6+4ZG5
VYFc/6o+i6SdBchna2KljUhMk390C9ay2uOYIsuwhYiLtw7Za8WmnWY0GjMrEl8t
rUOW0v5DSk8Mt9ltwx0OVSP66Eujk5bom3tLg0QGyC+pHvpUY0FZpWhNFlSZWO+r
GmfyHDi4cyEbTuOXS50ubdHchUziba/8p/iZ69nb4fONNmbBYDJgVdlVISq4FErq
bkdVRgO047cDA99r0ovl1ZKa7sVDhO52aXJSumSOY4FZzXGc10BtH4v5T+RpcJlD
vhVqunmNIW0DEvuunAHn3BCbr8D69ajVb6Id/4ABd1NyXkVwjYWmTFbXKgVLKSDw
vyN7yDOTFACJcQlMBEEokMF7FzJI7RU4kaOY2xu6KdwHYDrHE7c1Du9G31B2w2BV
KkaEbnd71blbl2YCdPfaz0RyAQXs1EHzeSzBWtgd8vtHqNd1zAfmGpbhjGSMYR1F
NzA3GqJON8Rf3IZ8PIacRiyJxLvn913P/azYtYl4Q4eheh+pM9/6A5tqsmmIze/T
fVlFWsLw03g=
=UM/c
-----END PGP SIGNATURE-----

--=-OdeCKBDsIC0rPv1GfcuR--

