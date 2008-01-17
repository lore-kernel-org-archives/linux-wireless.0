Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:50246 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbYAQPkn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2008 10:40:43 -0500
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
From: Johannes Berg <johannes@sipsolutions.net>
To: drago01 <drago01@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <478F766B.6030504@gmail.com> (sfid-20080117_153744_575943_20B7663F)
References: <47494851.4070504@gmail.com>
	 <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com>
	 <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com>
	 <20071127033408.GB5698@jm.kir.nu> <474D75D9.7070908@gmail.com>
	 <1196268612.6058.157.camel@johannes.berg>
	 <f6ca9fed0801110052ja95e86s9f1842846f0dd8fc@mail.gmail.com>
	 <1200068256.3861.172.camel@johannes.berg>
	 <f6ca9fed0801160208x40acfb91p8446298fda9e7726@mail.gmail.com>
	 <1200508694.8708.24.camel@johannes.berg>  <478F766B.6030504@gmail.com>
	 (sfid-20080117_153744_575943_20B7663F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x5dafRaWlArqW97urdUk"
Date: Thu, 17 Jan 2008 16:40:26 +0100
Message-Id: <1200584426.8007.53.camel@johannes.berg> (sfid-20080117_154048_506005_5D249BFC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-x5dafRaWlArqW97urdUk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Unfortunately no. I remember you sending a patch "adding proper monitor=20
> mode to iwl4965" .. has this ever been ported to iwl3945 ?

Yes, but it doesn't show the FCS since I didn't know whether it would be
present in the frame when it's received from the card.
=20
> Can do this (next week)

[...]

> I cannot say for sure now but last time I looked at the wpa_supplicant=20
> -ddd output while this was happening nothing was printed at all. But I=20
> will do this again and let you know.

Thanks.

johannes

--=-x5dafRaWlArqW97urdUk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR4926aVg1VMiehFYAQLTSBAAv3NnJ+PzYeINfstxYzlYKpIRzLp1C+5j
dD1ZEwZ8nbBZnFY9z1PczZ6knhaNHkjE7+Q1FEd+rSswg7Drk5Vfb1/wo006HMls
AZzfS7eqVrZexsuv88ZXRlo8RYA6HNphYwTKEEYln7XGEMnnR436KxKLYjH4/5C9
2CUVazwL+/rg8IX6GhnvervsMIY9IwPKyuzxUQ3fQHdHYZCzSqQvrhD0Zw+jZyew
yx2wVqJWX6XJ990ghYvv3dUpy3Q/FXelfPUyuS9osDFb0bcOVQ2lKoKSYmXcIsC3
HyQPeW99npJAXaW0qw+Hn2Q0hWC7SPAajaCb9TepZXhFZbdQlBKDFdmn1zPYtKGW
Meso+2Usdw4Xu0gh/Wufs9gQYde14G1TOKMheqRA6wJbOx46mQ4Ao93j4zSSKBbx
gkeCPSD3/BPmXD6eu1HGxY7RNYhlD67t6zSeHYGkUiAECJaYlJZsGdDuXotfegza
aGi2/of4W2Xnb2koKpFP7u6QOY7yRNX+X/mrUc4DyWfQezaBfr0oRPc/YtKS2LUd
cJF4E4gVxc9RIKCmziX77rlYDhzEf32/WpTQYPwuXWZ1koYZDsuzrq2joESYlD5+
pMqYGGMhH6QdUxEXMWi4i3CnHC0i57EsCurAcaYBo4iEMmVyERZc8v1aX8jqYqaY
/k2GzRSkbjM=
=vMH6
-----END PGP SIGNATURE-----

--=-x5dafRaWlArqW97urdUk--

