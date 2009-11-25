Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbZKYQhP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Nov 2009 11:37:15 -0500
Subject: Re: RFC: mac80211: add ethtool support
From: Johannes Berg <johannes@sipsolutions.net>
To: Patrick McHardy <kaber@trash.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4B0D5C8F.3040005@trash.net>
References: <4B0D58EA.8060304@trash.net>
	 <1259166692.32372.13.camel@johannes.local>  <4B0D5C8F.3040005@trash.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/ZAAkAYzo9owvK9KBQh7"
Date: Wed, 25 Nov 2009 17:36:50 +0100
Message-ID: <1259167010.32372.14.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/ZAAkAYzo9owvK9KBQh7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-11-25 at 17:34 +0100, Patrick McHardy wrote:
> Johannes Berg wrote:
> > On Wed, 2009-11-25 at 17:18 +0100, Patrick McHardy wrote:
> >>     mac80211: add ethtool support
> >>    =20
> >>     Add ethtool support and add a drvname field to struct ieee80211_op=
s, which is
> >>     used for ethtool driver information. This is useful with multiple =
different
> >>     wireless cards to find out which device is using which driver.
> >>    =20
> >=20
> > I thought we _had_ ethtool support via cfg80211?!
>=20
> Mhh good point :) For some reason it didn't show any information, but
> that might have been a mistake on my part. I'll give it another shot :)

It probably won't show the driver name because we haven't pushed that
through in any way?

johannes

--=-/ZAAkAYzo9owvK9KBQh7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLDV0eAAoJEODzc/N7+QmaxMIP/jFlpp+Cs9mHsWqna+pnlSya
HxFbNqGlj076KPJZ5E/6N1ULrTuG20W0A/+atDVdC4lAatAooJj8cXy7lSdBPd1z
jz+sdV2MTTBEx7QgTn5McXDut95W3g3uKgmA4E710R2LqIb+aq9uXleJh66F3T6z
0/1EXQfkFPycKDG6drifv5/dLvohoR/VuGpmSPoKbTWzr6xwlnRfFpYxTjofCF3L
i50wg/JEYzvvFffi+7id3AaH3DY1gs3xar6an8AvlAefEgCO/7iMAhwO1ZlNrxKr
mQrt4DXxb91cTqBNCsRWoEh2Nn4JEJ8rA0KvrPdpW7brQl9H+skAaVZvXiyxHszD
lOm5BJOm3XN17LbR75uGNcW/Ml/AEk8Abq0MTGDI2UhSk/uJIbzEgrP3iKWX2oMh
s98c6AXB5sRXkVoDZl6AaNosqNBcD3LHsnn0kqFq9Qfw6x1FJt/hjCNe75yRocnT
HYGvxpfiBCNAlvZZwYtCsQSbDcvb9kaHbkFxoBcpbAjR4sgSv+/jPEDVS96nSZvs
ed8Gkq+s6gueOeDgka50HUrfkuQu8aMXF1ABgPO/6UVUNK/FI6rmbimtipwj/DNU
i5BhexUIlR3H0o/5E5/jH0JEzqNyCFuqsPc6+vesu8FCTWlCHyIjVa/acbxwWjCV
tTdi/x9FRC49cl65moej
=CCYc
-----END PGP SIGNATURE-----

--=-/ZAAkAYzo9owvK9KBQh7--

