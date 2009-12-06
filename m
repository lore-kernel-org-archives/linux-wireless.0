Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42165 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933277AbZLFKrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 05:47:17 -0500
Subject: RE: [PATCH v3 0/2] mac80211: add U-APSD client support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jason Young <a.young.jason@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <16a81f890912031225g888490y2e8ff92557a322b7@mail.gmail.com>
References: <16a81f890912031225g888490y2e8ff92557a322b7@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Tp7qfjNg3Ltv5gBwc5uv"
Date: Sun, 06 Dec 2009 11:47:22 +0100
Message-ID: <1260096442.3461.3.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-Tp7qfjNg3Ltv5gBwc5uv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-12-03 at 12:25 -0800, Jason Young wrote:

> The bit values for IEEE80211_WMM_IE_STA_SP_XXX are not correct.  The Max =
SP
> Length subfield settings table in 7.3.1.17 has the least significant bit =
listed
> first.
>=20
> #define IEEE80211_WMM_IE_STA_SP_ALL  (0<<5)
> #define IEEE80211_WMM_IE_STA_SP_2     (1<<5)  /* or (BIT(5)) */
> #define IEEE80211_WMM_IE_STA_SP_4     (2<<5)  /* or (BIT(6)) */
> #define IEEE80211_WMM_IE_STA_SP_6     (3<<5)  /* or (BIT(5) | BIT(6)) */

Can somebody clarify for me which part of this stuff is WMM, and which
is "real" 802.11 QoS?

johannes

--=-Tp7qfjNg3Ltv5gBwc5uv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLG4u2AAoJEODzc/N7+Qmaq14QANJBoz8ChjV7TzwxnIJBwTT2
rICgCyiGdIjLHF4sZUSvTGq+AHqciVKNS/yLIf+RmeP8JZSSYPTxAULilZtZ0nh2
0BSi0S/2vi1awcX14j9Zj3fMpGisQrH+rH+ZND7ZBXRCUc8uDqWSUwhLzPNUt+Xd
tbk14y4u9DG57V97WpJA+SCiRhRLqVzjEoqk5F0d3E4a3H4/BeBZBuykY5CymyyP
kaOncDsFO4s7frarZWaltp76lrNHTCPcUKz+q7oNhL/hdQw9VOHeCXI7JEOEKSqR
f68LQnmT9577Z7oOSibDJo2RP6735OrN4deR1KP1ol6SE60explQckVR2ZMOAScj
zQHYSXaznwL7aNmLC27W9gR9jLhuQb6eSm0KCpqj7dunNPC/h7q/SzpkxIbqjcoL
cC4SOSMyKuNpknCA+BmdJCcKn1J+Av/yFlB/WZhINLP0nxtCcjVP9CkKNxa7DkSZ
yZpG/Vk0LiRK0NyeMlw7TwTtwPFd2s/kaTmWkZUXPzwvQwonNNnfGJUF48irjMxa
kRLM+BQMOKFYGZqdaTmep7O62gq/IauTVoTWVSWIVw6a+avF+p+qdSczHS+lJ6qD
NEb7Jol+jNaPT16kfRvK2irhco2WgkfcfMjuvKpP83Y8NJVNxPOdYKctgErrFc7y
xYZUCmjN3bhYB8hUlKRz
=ZC55
-----END PGP SIGNATURE-----

--=-Tp7qfjNg3Ltv5gBwc5uv--

