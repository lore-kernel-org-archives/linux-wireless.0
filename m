Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44053 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbXH3MGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 08:06:01 -0400
Subject: Re: mac80211, iwlwifi and packet injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: ian <ischram@telenet.be>,
	Robert =?ISO-8859-1?Q?F=FChricht?=
	<the_master_of_disaster@gmx.at>, linux-wireless@vger.kernel.org,
	Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <46D5CE9B.8080401@warmcat.com>
References: <20070829161655.7f68542c@doppelhertz>
	 <46D5B8B9.8000803@telenet.be>  <46D5CE9B.8080401@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6eIOaEx5Yxu7zqaphG0s"
Date: Thu, 30 Aug 2007 14:07:03 +0200
Message-Id: <1188475623.2963.22.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6eIOaEx5Yxu7zqaphG0s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-29 at 20:52 +0100, Andy Green wrote:

> No, there's no general problem.  I just cooked current wireless-dev
> everything and am running it on this Compaq nx7400 with a 3945 chip, it
> has just sent 100,000 packetspams while pinging warmcat.com over an
> associated connection, the injections verified on another box with a zd12=
11.

Right here is the difference, Robert didn't have a normal STA interface
up at the same time. FWIW, the NULL mac address thing is about to change
for the filter flags once a few people review that patch.

johannes

--=-6eIOaEx5Yxu7zqaphG0s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG1rLn/ETPhpq3jKURAppoAKCBr5575Oi87KXBi7jRy7VsrceaAgCfSxtO
C35TWZxIB9ADpeogerThq+A=
=IT/Q
-----END PGP SIGNATURE-----

--=-6eIOaEx5Yxu7zqaphG0s--

