Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51228 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbXJJJBq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 05:01:46 -0400
Subject: Re: [RFC PATCH 2/2] mac80211: store SSID in sta_bss_list
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1191973799635-git-send-email-linville@tuxdriver.com> (sfid-20071010_010921_998777_FA0E0694)
References: <11919737992212-git-send-email-linville@tuxdriver.com>
	 <1191973799635-git-send-email-linville@tuxdriver.com>
	 (sfid-20071010_010921_998777_FA0E0694)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sfTAZWCO7Uk6i4h61lrj"
Date: Wed, 10 Oct 2007 11:02:39 +0200
Message-Id: <1192006959.12541.2.camel@johannes.berg> (sfid-20071010_100148_255607_05560A3C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sfTAZWCO7Uk6i4h61lrj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-09 at 19:49 -0400, John W. Linville wrote:
> From: John W. Linville <linville@tuxdriver.com>
>=20
> Some AP equipment "in the wild" services multiple SSIDs using the
> same BSSID.  This patch changes the key of sta_bss_list to include
> the SSID as well as the BSSID and the channel so as to prevent one
> SSID from eclipsing another SSID with the same BSSID.

There's a TODO comment at the top of the file for this which you can
remove :)

johannes

--=-sfTAZWCO7Uk6i4h61lrj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwyVLqVg1VMiehFYAQJuhxAAu5Vj+nyFnE402VVt8cbAvYYUbuht8+lO
3PgkAQqftHs3C8bgcIxbjgxDsOmUNFHwW0n18sM779wCjr/jhPqHFXrR+4Ii7S+5
8vQkT7ur2bD2VP2yjsVi8Cj0xoMqFceAPyyQ4Peu/rhy2mR+XtHbxdQti/crOuJ3
8oFpE0wofQ+1EGfHN7igen68aB/teEjQSwY4GpydUXRsFtt3992QTOii43X650rs
STWhSq76IlZ1hLUfgKHAmPbQvUWN2EVwB4WwwgHd+3itDn8EEha43eTbQZVoDH64
SPYrVz5JhHKGN3fFaoYYsr/AGuWEF97Ue0xOQcQq/q/cXgyKImZVSteLc0/GYTyK
3QdWZ+FilAVMW/ZWKJANSqYj/ohAyIwkBrzkENWAx/4qVn3YOUS/PQGgJyI+Zxjh
tO28B02AQcYi9DP8PnQmKybD0RBy1Hc9rpCpqVN3BeGA9Kg+JWgIycdaqB2gHMBz
3ZjJuZbde5ucXoffj0VRCYMAs1uDNv6F3RGy+xV08+Fs5SVoqwdo2O+upZHPeA7z
JhcNKKhMSVRsUEDBIz5wUJcRJ4vIYYxTEHYXRSHroVuNt/a2fxtljaYweVWDPBEQ
zrXDH2d0lvhHZGnHNGY71Jxe7yJbwQqvHn39cGOy5UijsmJHGCVg7LAqbrHTa6UF
w/4nvN25cPM=
=9iZh
-----END PGP SIGNATURE-----

--=-sfTAZWCO7Uk6i4h61lrj--

