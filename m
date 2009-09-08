Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43319 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbZIHJSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2009 05:18:41 -0400
Subject: Re: Possible WEP encryption error with wpa_supplicant -Dnl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <200909081016.37204.hs4233@mail.mn-solutions.de>
References: <200909081016.37204.hs4233@mail.mn-solutions.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-8PEucHqCtLmUx/AAghBj"
Date: Tue, 08 Sep 2009 11:18:40 +0200
Message-Id: <1252401520.1175.48.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8PEucHqCtLmUx/AAghBj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-08 at 10:16 +0200, Holger Schurig wrote:
> Here are some details on my ping problem: I seem to be associated
> successfully to an Cisco 1231 AP, but no pings are going through
> if I use nl80211.

Yeah, WEP with nl80211 is known broken. I have a patch, but Jouni didn't
like it and I haven't gotten around to fixing it up.

johannes

--=-8PEucHqCtLmUx/AAghBj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKpiFsAAoJEODzc/N7+QmaMBAP/1MCAYSU894s1sDDxlgosTqE
hsxnN+vOjsWCZEtpSKciId0MLBG5CQVTCVOiVA4vJALTC45Kxfeezj7phPRtRds5
5MYujTQaVhy86WyYlrSXcjhc9eZVch/mMm9mjD3rWbIOmXtfFjnd0f36uC58OKbR
A8gL56jLnAzY+ymJMzseN5SpqcCvHHD81x56gyevGR4HZ+bzLkVkV7G3/BYI0zWz
3bHPVoTwhMIz1R75i3rSjfZUSEZr0unhBfANgSz5z5kR6RM3mlnF284QcW5acc+K
aR7KyL6oTPN5pu0yQZpFG+lK65fcsl/PP3JxBxZ1pdlRAMIVwqPr05e7Eux0/oqV
uGqBKuAynazrF8T6VoGJUNYzpgLY95an406XUl8gjbSkqLPfoK8Nxl8ZduhJjyJS
UCXAXkCp9VW6K/udE00TLoMnxKbJvyi5JTf0wF3x+72VD4j0O66ceZi4EzeckCFU
1QX3KwbomVENCyFCDSAS84APE1an0or2NCWLoUS2AA88op7Rj8XomliWlz/wDQO7
ErP7TvzWPLdACN02C5m2EKRLHKtILb6It9z4/6N2sptFL/Q8qAGbPoMzDh711Rgk
Fz20DCIyAv97LPg4UH10IYvC58x0LUE94PkSYgjPJ6Am7c5OVVW64eckUG/L2SEe
828YRYwesBcYlGhxSuAC
=v7fk
-----END PGP SIGNATURE-----

--=-8PEucHqCtLmUx/AAghBj--

