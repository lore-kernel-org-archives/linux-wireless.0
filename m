Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXGYIhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2007 04:37:40 -0400
Subject: Re: [patch 3/5] A-MSDU Rx aggregation support
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	mabbas <mabbas@linux.intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240707250106w43073bcbh1b4c7fa3d47fc3e2@mail.gmail.com>
References: <1174909200.1364.56.camel@dell-4965.jf.intel.com>
	 <1175111599.5151.123.camel@johannes.berg>
	 <46137FF2.6020203@linux.intel.com> <1182374019.3714.87.camel@johannes.berg>
	 <20070718000140.GA26907@tuxdriver.com>
	 <1184754598.4658.14.camel@johannes.berg>
	 <1ba2fa240707180622p791168eax4fae712641e24cc4@mail.gmail.com>
	 <1ba2fa240707180851y22ead404g1c87d73903e939e3@mail.gmail.com>
	 <1184777775.8125.0.camel@johannes.berg>
	 <1ba2fa240707250106w43073bcbh1b4c7fa3d47fc3e2@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PH9YmpwY7qtAVUZmYyL6"
Date: Wed, 25 Jul 2007 10:37:22 +0200
Message-Id: <1185352642.4006.2.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PH9YmpwY7qtAVUZmYyL6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-07-25 at 11:06 +0300, Tomas Winkler wrote:

> I've checked the Spec again and I was wrong. Theoretically,  A-MSDU
> packet can be a multicast packet so we get back to the problem you've
> pointed first.

You seem to know this much better than me, think you could fix it?

johannes

--=-PH9YmpwY7qtAVUZmYyL6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGpwvC/ETPhpq3jKURAi46AJ9HTfQctmgxtud/tvSUTU9TIOcTTQCbB//C
iOshFgsNf7BvVTzQuUaFIs4=
=+r0f
-----END PGP SIGNATURE-----

--=-PH9YmpwY7qtAVUZmYyL6--

