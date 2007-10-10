Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751275AbXJJRmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 13:42:07 -0400
Subject: Re: mac80211/iwlwifi + hidden ssids
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, dragoran <drago01@gmail.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20071010152027.GF5962@tuxdriver.com> (sfid-20071010_163901_037577_F3E11A0F)
References: <470C9F28.1070803@gmail.com>
	 <20071010130653.GB5962@tuxdriver.com>
	 <1192026847.9739.4.camel@localhost.localdomain>
	 <f6ca9fed0710100757gbcd364esdd94f114cfe1019@mail.gmail.com>
	 <1192028866.9739.32.camel@localhost.localdomain>
	 <20071010152027.GF5962@tuxdriver.com>
	 (sfid-20071010_163901_037577_F3E11A0F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nGtk5e/XtPrEY9OxlI5j"
Date: Wed, 10 Oct 2007 19:41:52 +0200
Message-Id: <1192038112.4770.0.camel@johannes.berg> (sfid-20071010_184210_445849_F8B8E38D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-nGtk5e/XtPrEY9OxlI5j
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-10 at 11:20 -0400, John W. Linville wrote:
> On Wed, Oct 10, 2007 at 11:07:46AM -0400, Dan Williams wrote:
> > On Wed, 2007-10-10 at 16:57 +0200, dragoran wrote:
>=20
> > > btw shouldn't all mac80211 drivers either work or not work because th=
e
> > > code for this is in mac80211 and not in the drivers?
> >=20
> > Yeah, pretty much; but each driver/firmware may handle hidden ssids
> > slightly differently.  mac80211 should bring some sanity to this area,
> > but I wouldn't discount variation between even mac80211 based drivers.
>=20
> Hmmm...doesn't the iwlwifi firmware intercede in scanning?

Yes, but we tell it which SSID to scan for. Not that we know whether it
cares...

johannes

--=-nGtk5e/XtPrEY9OxlI5j
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARw0O36Vg1VMiehFYAQJtRw//f5nJDjXVQn7j1Un0Dme62C2wA1lmDuoH
VfZXngtVp4kPx4pi/LUoR0vsmjJaArcSHPUquNddOgghVj5/48yZVP0LurW68qgi
8QqZ0YlcWtrxkzRQr7e2GFVhnQZtqG2pWPdh4jlV3QN7RYIxnWal+1HS2j4G2r1L
ugt5cC1tHbbTIFJZn7D/Ne7bC/S6QkhR1aPk+XpCNI9sF7jTjAlNhKQoojvmkLdK
FW3OALildGer46q9ev7sI5X5mTQa3ynCVEtlTtcgohhCrqJjv0QK4BXFbKWSyvy8
ryiHoBF5pZTYUMQvqnnjkZFrqf/2U0xyIsTIyWzs4xlVwKSBLUOkRWpbj7bNyoVf
V7/RFvGdHNjhclU8cxB/du4tbMRvUmH5v6SZjyRBhfxic3kfJ/XKA5S0bSobo14C
+bJ0D0LYktuDYVyo1l+WGIEKiVdfJl57CJVJFIRTONkVd2HlbfDzvJLlyH24iSyg
6sQWbZKJo5eoBypQJM4b8TPIP0/z+geptGIBd3soVuKscvNm4zkN76LlUt50fQjU
MRCUEW7Wa7IT2Pzq+b/pgVWvAQbz/ChX/TskVcaC9wb6fpwyc4YDVmwovxKx4tzc
Su0x1iqZYJx8FOe9Iald1LQiX72PX2b38iSTj6pExep7X+s6vXpH8zilABqdv7RE
T0yZJsWtHNo=
=D4CC
-----END PGP SIGNATURE-----

--=-nGtk5e/XtPrEY9OxlI5j--

