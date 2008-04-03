Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56051 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755042AbYDCLti (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2008 07:49:38 -0400
Subject: Re: mac80211: possible circular locking dependency detected
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chatre, Reinette" <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1207218482.3636.19.camel@johannes.berg> (sfid-20080403_112812_982366_CC856F98)
References: <D936D925018D154694D8A362EEB0892004194DDE@orsmsx416.amr.corp.intel.com>
	 <1207218482.3636.19.camel@johannes.berg>
	 (sfid-20080403_112812_982366_CC856F98)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NBBIoamJp9XWBVaOp2vx"
Date: Thu, 03 Apr 2008 13:49:33 +0200
Message-Id: <1207223373.3636.48.camel@johannes.berg> (sfid-20080403_124940_803408_642A0255)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NBBIoamJp9XWBVaOp2vx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> Huh, yes, but why didn't this show up before? The bug has been there
> *forever* and my workqueue lockdep debugging has been in the kernel for
> a long time as well. Odd.

No, wait, that was wrong, I confused that with the schedule_work
workqueue.

johannes

--=-NBBIoamJp9XWBVaOp2vx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/TETKVg1VMiehFYAQI4eg//SzY+fY9H0YsKWvoQJPx2b2R4VzsZS1pY
zabQTr2brVjuE5Rfyjaw0FNY8yV/DTana6E+HwLEdmQhqdyLzz3q60gheXnlAgPt
7iZQU/cjcllzEMqjONKHdqk+T/SgfoFH30t0lBKftxWSBGLY1Xn/7bM5DOBHngKH
D36XUAyBDyfojAg4YW9vrAfIxECal4i/3dpb80yKNmD7W9AVGM+IilDOcjHY5peo
GNh5iKOlhbWjTKEQ4uy6oMdmDkJgWbduGaYB3NkyNNwKatfCvthQ4tD2vl9x3MpI
xeVSPfYOtBb64GRZYKqK6PcE62lV87TbWmpeQGsBUeY0EgghmXQcO344wBkw/spG
9x0861BdHicOoMbQ05Pf8vG+x+puYmT2A7J6X+y/+drt0y0H34tv6RZftqwGvGlz
ct7yVKNq5e5C5iqeF842gHXaMzHvOFO428GgioCX+oinPgPhGle4QZUWewgxsf5R
qx7rQgowf3J0UZgZ9qzdo20Bha/5LylQCSPIjDYnWIO9rjX/UHGtM5JP+d+xRy+t
qm8H5IFe3NWcUKA2J1Cr+YTuMKzA1Mavplqq8b4452kSsU4aC+I+NjaY5QNEKgfb
gFMPRAER7B5Mi80cY48y6dOU6YksJixY2O2HR2z9C/uLabu0Zh1djhav4FcRtIux
2fpfpuBRNd4=
=hTzh
-----END PGP SIGNATURE-----

--=-NBBIoamJp9XWBVaOp2vx--

