Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40679 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422881AbXCWNot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 09:44:49 -0400
Subject: Re: [PATCH] fix information leak in wireless extensions on 64-bit  platforms
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: stable@kernel.org, linux-wireless <linux-wireless@vger.kernel.org>,
	Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <1174640787.3588.65.camel@johannes.berg>
References: <1174640787.3588.65.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mH8m0eX8qc1SOy5ymS+y"
Date: Fri, 23 Mar 2007 14:42:42 +0100
Message-Id: <1174657362.3366.6.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-mH8m0eX8qc1SOy5ymS+y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-23 at 14:40 +0100, Johannes Berg wrote:
> Wireless extensions on 64-bit platforms leak information from the kernel
> stack due to padding in structs that is copied. This affects any
> wireless event stream including scan results and so hence is available
> to unprivileged users.

Ignore this patch, I see Jean just posted one as well :)

johannes

--=-mH8m0eX8qc1SOy5ymS+y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGA9lS/ETPhpq3jKURAjs1AJ9BT4+AR3kbLMovz825P7asZq1YSgCfdgrG
N9SunpmGnhFhwtLeDLAGdGk=
=7S6v
-----END PGP SIGNATURE-----

--=-mH8m0eX8qc1SOy5ymS+y--

