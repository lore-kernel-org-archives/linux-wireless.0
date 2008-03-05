Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32781 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbYCEM2Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 07:28:16 -0500
Subject: Re: [PATCH 05/11] mac80211: adding mac80211_tx_control_flags andHT
	flags
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <c85cb4470803050359x398a685ekb1b94de6cf65ad62@mail.gmail.com> (sfid-20080305_115922_154008_41AFB4E5)
References: <1204682972-26004-1-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-5-git-send-email-reinette.chatre@intel.com>
	 <1204682972-26004-6-git-send-email-reinette.chatre@intel.com>
	 <1204710116.25502.48.camel@johannes.berg>
	 <c85cb4470803050200w6d981525w11688f0921867d5a@mail.gmail.com>
	 <1204711417.25502.59.camel@johannes.berg>
	 <C07C4589BE74A34981C3C3525EE1F8010378F341@hasmsx412.ger.corp.intel.com>
	 <1204713755.25502.62.camel@johannes.berg>
	 <c85cb4470803050301p63b3568epe989ef042f9b11f5@mail.gmail.com>
	 <1204715685.25502.66.camel@johannes.berg>
	 <c85cb4470803050359x398a685ekb1b94de6cf65ad62@mail.gmail.com>
	 (sfid-20080305_115922_154008_41AFB4E5)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-UUAzuRKwdT928sVd3pIE"
Date: Wed, 05 Mar 2008 13:27:59 +0100
Message-Id: <1204720079.25502.73.camel@johannes.berg> (sfid-20080305_122819_856833_0BFB1078)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-UUAzuRKwdT928sVd3pIE
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Ahh! Ok, thanks for the explanation. Is antenna_sel_tx really the right
> > thing though? Tomas mentioned that you can have three antennas and only
> > two chains so should that rather be a chain selection?
>=20
> yes, this is correct from low level driver's perspective, but i think
> that from rate scaling perspective keeping the antenna term is clearer
> then a chain.

As long as it doesn't confuse those familiar with the spec I guess
that's fine :)

> > > It may be good to add this to the file's documentation.
> >
> > Indeed. Or to a DOC: section somewhere so it can be added to an 11n
> > chapter of the mac80211 book (since the patch is merged I'm
> > automatically generating it nightly at
> > http://linuxwireless.org/mac80211book/)
> >
>=20
> I'll make a patch with the explanation

Thanks

johannes

--=-UUAzuRKwdT928sVd3pIE
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR86RzqVg1VMiehFYAQLuZw//T/hDPAXBpCzX8XKOf1ZA/enGhj2zqgbR
aJGaq8cybeLy3BvkNzsvtewxLjQBXVxCsOpAzbvOrgA+8JhUesCGKn7isOzXN3jU
Et/+FfrIIXZfaEYLM9DF8jUB5FRaFvKe/PnTWSSN6gZk6wuWPW0Zy5cWv5IxnQXI
sH+wTPR5JPHj3GbDRc/FosQm9PFGcFvefBo+0qPFsKAt4LMyj8qFAadx2yAcMi6e
ob+J3ETa//pyvKKSUXw/YpGKQ57KvURwH2FX8gRWP+eOYMulQTbSGWlBsJpTmS8M
V39ZzqaU5TPyfmnuYyUZDt8TLGhHtcX7J6pr/s44LF8UUWjDy4wUIYr/MPpEVvEA
Ad5hZq5dQNpqyvqSH1f0IoH13Mey9xuhhrloUqQoHRwDgvBqR/R+Xpq4WlF6swFJ
I/Rg39yFHmcb7+tNKG/p/TAWZAK6rP6JEjNXcQiWR1oEN4JgKkPpKLgBVAAAjEtL
tTnYPO79vFUV/JT2s7/eRem35cZfpn76V/dzy8GOWYlVVOjYFbIlMTNIf/mOblki
4hOS0O41whLJOpemXp8FMa7RNQpEJhrsXG+v/B5psM+mIjijqypKYDSbZo9NZUb4
FNQXKR+O99rpD8UyO3/FbSH9MAnyd/PoR5eJRkyDaCSsdtl8UjGKBn/+RxBtKYlM
Az7N+Z3wQ/g=
=MQvK
-----END PGP SIGNATURE-----

--=-UUAzuRKwdT928sVd3pIE--

