Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44075 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965961AbXBOPFf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Feb 2007 10:05:35 -0500
Subject: Re: nl80211 userspace
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20070215141944.GA3310@tuxdriver.com>
References: <1171479846.3709.3.camel@johannes.berg>
	 <40f31dec0702150017x3ecfca57ucded8f1d88bbb121@mail.gmail.com>
	 <20070215141944.GA3310@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1BXg6PWNDmNXTjUZEyYf"
Date: Thu, 15 Feb 2007 16:05:29 +0100
Message-Id: <1171551930.5220.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1BXg6PWNDmNXTjUZEyYf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-02-15 at 09:19 -0500, John W. Linville wrote:

> P.S.  Michael is, of course, right that the tool for users probably
> should not rely on python (or perl, et al).  FWIW, I got the
> impression that Johannes's tool was meant to use in the short-run
> for developers...?

Yes. The advantage is that you don't even need to recompile it for new
commands. And hey, maybe we can hack it up to generate the C code for
the real tool :P

johannes

--=-1BXg6PWNDmNXTjUZEyYf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1Ha5/ETPhpq3jKURAvP9AJ9R+UmtVKKV4XuzKNG2YrHjX8/ffACfXCZi
PmUuHUTlDVJ3lWRDw48SudM=
=32GK
-----END PGP SIGNATURE-----

--=-1BXg6PWNDmNXTjUZEyYf--

