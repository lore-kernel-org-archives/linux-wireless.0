Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYLWVzk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 16:55:40 -0500
Subject: Re: [PATCH v6 0/3] mac80211 dynamic power save
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@nokia.com>
Cc: linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
In-Reply-To: <20081218213306.7248.64398.stgit@tikku> (sfid-20081218_223647_038092_06E155B0)
References: <20081218213306.7248.64398.stgit@tikku>
	 (sfid-20081218_223647_038092_06E155B0)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-3s3V3MoOfznGsAA7KGWB"
Date: Tue, 23 Dec 2008 22:55:46 +0100
Message-Id: <1230069346.31228.51.camel@johannes> (sfid-20081223_225552_829916_AF09261B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-3s3V3MoOfznGsAA7KGWB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-18 at 23:35 +0200, Kalle Valo wrote:
> Here is v5 of my dynamic powersave patches. I have tested them with
> stlc45xx on Nokia N810.

> Power save related features which I'll implement later:
> o disable power save when software scanning
> o move dynamic_ps_timeout to hw.conf so that drivers can use it in
>   case they need to
> o beacon period (wakeup period) to the drivers, can be set from user
>   space but otherwise is bss's DTIM value

Now that these are in, and more things for user interface are on the
way, we should probably think about implementing the policy in
userspace. Should that be part of NM? It could take into account things
like the system power state (AC/battery) for the decision, at least by
default?

johannes

--=-3s3V3MoOfznGsAA7KGWB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJUV5dAAoJEKVg1VMiehFYTEMP/jCnZm5Symh3YXF21DGau09R
5P1X9blLwxYByX2aVQkyadM1v7OHcoG5e80CJGNODBpVjTT+AriTzPZ0HidYjUmU
FhTYKorGV+jIIMEj03JiRzAIe927bPyFwW+A81ZUSUVspqT37vL1mhpLnHyKA8Iw
5y5lzBp/UozFex+AieZd8Ib+YTiT1md0xBY+uCXSBPtj6gKYmEqFvrwjguztnxab
ZMq6SoNV7CcIodG5MeBxcUrGgqFk5Tr8/BsnDqbj4KHLioKjx2yUvpsAx3eOnEUx
8gypXX+qRR94J5TlQ9qxAcBSqjUgebDFYau3O588HwQeXBAcjsO3NGBJAvlujRB7
6VQ/n/4W+JgXlDNM/bPfo6TPqwTyxV6NRE/7SPte508qJYC7VxAVNxvZJm0GsdW/
Tek2EaJZsQKAkykpnQ8Nprc1/tKknsFEJgyklOPFirdtydkfzVxbm4+SJzBs8PfB
obVtve3bvM4biGCHapnlm+RaMpeSGsfV/WJLrCgVMTqWdSjVh7iapkxxac9YOPKW
Ij6QGApSP7DzWveyJwc1Q4uoIpZH3IoJpD1PdP1NQ4tJZe+yNWVxqtF2oDgrcC3y
aIaMu2MT3IqVwxGEyVY4JObeg8KTm5IyYkb+uDtWlvINsGvbYX7rviS7sbOtHzBn
8iSebMnbgyxm//JEjHZY
=3SWO
-----END PGP SIGNATURE-----

--=-3s3V3MoOfznGsAA7KGWB--

