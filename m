Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33485 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757145AbXJDSFA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 14:05:00 -0400
Subject: Re: [PATCH] hostapd: adjust for changed nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20071004130825.GB6037@tuxdriver.com> (sfid-20071004_143906_155707_FC8C12EA)
References: <1191069453.22960.77.camel@johannes.berg>
	 <20071003030951.GH933@jm.kir.nu> <1191393995.4178.0.camel@johannes.berg>
	 <20071004040957.GM933@jm.kir.nu>  <20071004130825.GB6037@tuxdriver.com>
	 (sfid-20071004_143906_155707_FC8C12EA)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-R5g8mAkDahPhez/er8en"
Date: Thu, 04 Oct 2007 20:04:53 +0200
Message-Id: <1191521093.7367.1.camel@johannes.berg> (sfid-20071004_190512_503597_C8E4AC7B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-R5g8mAkDahPhez/er8en
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-10-04 at 09:08 -0400, John W. Linville wrote:

> Until Johannes starts hosting his mac80211-hostap tree, I think you
> can use wireless-2.6#mac80211-attic.  I've been trying to keep that
> available for those who need it in the meantime.  Fair warning,
> it is untested and may simply not work...

I actually sort of do have a tree, if you take my regular patches dir
you'll find a bunch of patches to "make hostapd work". They do, however,
require additional hostapd patches that are WIP, also in my patches dir
(click through from http://johannes.sipsolutions.net/patches/)

johannes

--=-R5g8mAkDahPhez/er8en
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARwUrRKVg1VMiehFYAQL7Fw/9EtEzxBxju5pegSS2lZIuaiB6Kxf4f/Yf
vehMzmR1r953/ZvWkzeb2idm2b3QpgaB99x4UORONC7D5FrmrN5+O27zlMEB/3Gb
hfEuFeDTz6Ozua0uXrZUzbCX9Vbf4R8Xp8D1PJPiE6i0kjPRbeSM2XbQ9lJWd8FX
621jQZPDqfwYccK7AKd4EAqOPLxyBZoQCZGUH5p0P+Fi5bAgbt57oA2hEpNbwx6c
NaLMe0rzOwaO7QQnXjO8x6LG4LyEamBlR0F64EFoA8g+fniZpUft764+UK9MRa1Q
C04p0g1tp26KyoQSaV4cMwtLZlCatxtBvAmCeCgAjmBa/Km6G0EexxDvlv1OSoNF
t8jN7rrxZegvaF8UmM0K5APxiGeyajfWJGzG8XsxOCsXvYh4oMlzPmtkp2KAVBIJ
1Tces6ubx81iOrnUOC+FlPMSMDHT+gYkJU232ZzEmd2911frv+GHGau9NiocYHJj
hDP9Mz9ZEshWRXcfnzLR5MjvOXhwHY7ZZcPjbc7nFBpsdUC3TCYmet5z/ARGO0Ej
Jl+58GdlJRVh8QgPWIN36ZVxlDKcyqPS/ag0VGl4Av+2qLEXZd7jIsZQIeAWbpHc
VlokC/LPPbTWX4z8kNGooLsxf5XP753Oi6wBVdC2NQ1pddofHE67vP+qtYm55jMR
HhBv+ia0gb0=
=pvOs
-----END PGP SIGNATURE-----

--=-R5g8mAkDahPhez/er8en--

