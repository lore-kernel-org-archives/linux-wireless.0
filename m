Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48466 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbXJLL6J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2007 07:58:09 -0400
Subject: Re: atheros hardware needs padding for QoS data
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <bruno@thinktube.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200710121946.30024.bruno@thinktube.com> (sfid-20071012_114641_137646_A74F979B)
References: <200710121946.30024.bruno@thinktube.com>
	 (sfid-20071012_114641_137646_A74F979B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1KGnsh1JxZ6f1e23lXt7"
Date: Fri, 12 Oct 2007 13:58:17 +0200
Message-Id: <1192190297.4770.48.camel@johannes.berg> (sfid-20071012_125812_431606_A374717B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1KGnsh1JxZ6f1e23lXt7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-12 at 19:46 +0900, bruno randolf wrote:

> i didn't see how mac80211 would allow to solve this elegantly at this tim=
e.=20
> are there any other drivers with a similar kind of padding requirement? h=
ow=20
> could that be implemented cleanly?

b43 also has padding added on RX which we simply remove with a memmove()

johannes

--=-1KGnsh1JxZ6f1e23lXt7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARw9hWKVg1VMiehFYAQL7kBAAia14uj36D9M0jdCQeILLW9iCXB8r4nzH
jqYbjpFkbSPs0tvbosPtHITz4k5Rj2KCOS6sBEr8Cub3hnrh+pf3m90vyELyNvsX
m+vcDqg2HAl7t1Bq16crAtopOF3ouH7BeVsWHSzedQZFuMB1gDjtdwJFlQm6opLC
1cDybAyBp+NT8+l6PDVTlfEluZrQZsfnQhEYEwk2R6wXmbr1TNKRMcab1o8G09pU
6pv2mMMlnHY+W9asNEU7J8gx6AjhoJmNxOmY5hQILdC6xH+fIdOe4l1Kvwu+LKQv
NzevL1G/lIIJttJAZgLG7CzGNdPf7pByvRwJamO3i32tkizJDw3j30f//Wez9Ay/
x0q2OhmAYE97Fb0nZxXMYwXRthQbtfhi59sIwhXnle+j5J2LJo33zHjCMpHf62x6
vRDtimwrJTuUINZrigEPGmAoUPPXmg7yRpTfuux4OxDGB7hZVXo7/B4d/KCJjMLP
9Ci5D/hcJ+0Lw1va+im/u9TZ2lUXIl4FYyaIJs+2fohBSRQguVDyI8WA4eazSTsZ
xzP19tNcrj2kA7iNJ7weCmpMSIwMNuN+P8Po8WM3Nn4XVu1A06CK1am91DMqP/I5
CmMn+YEalSteYqZ1r8Cz7BE9qkA4srs2JqvOg4tvInrw1J4FybiAXBiHw65xq5ab
ynmveJVBcwc=
=tYg3
-----END PGP SIGNATURE-----

--=-1KGnsh1JxZ6f1e23lXt7--

