Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35324 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156AbXH1ItQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Aug 2007 04:49:16 -0400
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>,
	Jeff Garzik <jgarzik@pobox.com>
In-Reply-To: <1188285945.13078.242.camel@debian.sh.intel.com>
References: <1188192012.13078.177.camel@debian.sh.intel.com>
	 <20070827131026.GA21137@infradead.org>
	 <1188285945.13078.242.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YO/j2gePxx7KTQywPwXW"
Date: Tue, 28 Aug 2007 10:50:15 +0200
Message-Id: <1188291015.7837.67.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YO/j2gePxx7KTQywPwXW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-08-28 at 15:25 +0800, Zhu Yi wrote:

> I know the method is not common used in the Linux drivers, but this is
> decided by the hardware layout. For 3945 and 4965, 90% of the
> hardware/firmware layout are the same and only 10% are different. This
> makes it possible to support two slightly differs hardwares in one
> driver. If the hardwares differ a lot (i.e 2100 and 2200), I won't even
> think about to do it in this way.

To be fair, that's not what you do, you're building two drivers from one
source rather than have a single driver that supports both. I'm fairly
certain Christoph wouldn't object to the latter.

johannes

--=-YO/j2gePxx7KTQywPwXW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0+HH/ETPhpq3jKURAsAzAJ9RJmZ9qR+rG2CRKDf6JrVdfONcmACdGSQP
/APJiWSXo2tFl1F3i1FHQBU=
=+hB2
-----END PGP SIGNATURE-----

--=-YO/j2gePxx7KTQywPwXW--

