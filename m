Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946091AbXBPUQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 15:16:36 -0500
Subject: Re: [PATCH 10/10] cfg/nl80211: remove legacy network id
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Jiri Benc <jbenc@suse.cz>
In-Reply-To: <1171653136.4153.42.camel@localhost.localdomain>
References: <20070215144241.847938000@sipsolutions.net>
	 <20070215144300.830181000@sipsolutions.net>
	 <1171653136.4153.42.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6nNMHoQHeOiPhxORSaT3"
Date: Fri, 16 Feb 2007 21:16:29 +0100
Message-Id: <1171656989.3575.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-6nNMHoQHeOiPhxORSaT3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-16 at 14:12 -0500, Dan Williams wrote:

> Don't we still need the WEXT compat bits for nwid?  Or are we just axing
> it entirely?  What legacy drivers actually use this that are still in
> the kernel?

Well, I was thinking that we'll probably never get around to converting
those legacy drivers that use nwid to cfg80211. And when/if we do we can
add it back.

johannes

--=-6nNMHoQHeOiPhxORSaT3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF1hEd/ETPhpq3jKURAkdhAJ9S5JJx8+NSdmaVJvc/OBPyr5NMpACgjCum
EX5WadrUjUXx60N5AjuCFEg=
=5vhH
-----END PGP SIGNATURE-----

--=-6nNMHoQHeOiPhxORSaT3--

