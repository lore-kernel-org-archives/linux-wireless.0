Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35434 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbXB1Ra0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 12:30:26 -0500
Subject: Re: [PATCH 2/28] rt2x00: Add debugfs support
From: Johannes Berg <johannes@sipsolutions.net>
To: Robin Cornelius <robin.cornelius@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <c4db5c50702280921i6f0689adm197b5fcb19f1852f@mail.gmail.com>
References: <200702281507.13953.IvDoorn@gmail.com>
	 <200702281752.36875.IvDoorn@gmail.com>
	 <1172681674.5015.43.camel@johannes.berg>
	 <200702281809.15486.IvDoorn@gmail.com>
	 <c4db5c50702280921i6f0689adm197b5fcb19f1852f@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+t0i9uYeIzAx8VmLNsJh"
Date: Wed, 28 Feb 2007 18:30:02 +0100
Message-Id: <1172683803.5015.58.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+t0i9uYeIzAx8VmLNsJh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Robin,

> d80211 and cfg80211 will compile against a 2.6.20 kernel (i believe
> 2.6.18 or better will do).

Cool.

> I have achieved this starting with the d80211 and cfg80211 code from
> wireless-dev.git, and applying some of the intel patches from the
> d80211 subsystem package and a couple of other pointer cast fixes. I
> have not made a patch set yet as I am still experimenting.

Yeah, mac80211 should work pretty much.

> The problem i am up against is now i must disable the existing
> wireless extensions in the kernel and this can only be done with a
> kernel rebuild. I have not tried this yet as I am not sure there is a
> lot of point continuing on this route as its not possible to
> completely out of kernel build the cfg80211 modules, which was the
> target for my experimentation.

Right. I was thinking that it ought to be possible to create a stripped
cfg80211 that doesn't include wext compat (which is possible now) and
compile that against old kernels. That way, until mac80211 is converted
to use more cfg80211 operations, it should continue to work fine.

johannes

--=-+t0i9uYeIzAx8VmLNsJh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF5bwa/ETPhpq3jKURAk7gAJsH2ZPUB7tPBH4dtwkBWEl+gxKPwQCgt/BK
6ACR+O3L4i0pcxEBE9K0wGk=
=jvlf
-----END PGP SIGNATURE-----

--=-+t0i9uYeIzAx8VmLNsJh--

