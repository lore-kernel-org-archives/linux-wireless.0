Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39242 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbXHBMcw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 08:32:52 -0400
Subject: RE: [ipw3945-devel] chaning mode only when interface down?
From: Johannes Berg <johannes@sipsolutions.net>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: dragoran <drago01@gmail.com>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	network manager <networkmanager-list@gnome.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <C07C4589BE74A34981C3C3525EE1F801024CF2CB@hasmsx412.ger.corp.intel.com>
References: <C07C4589BE74A34981C3C3525EE1F801024CF2CB@hasmsx412.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dnhPuSJkURBoNKXOBGW7"
Date: Thu, 02 Aug 2007 14:34:07 +0200
Message-Id: <1186058047.24230.38.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dnhPuSJkURBoNKXOBGW7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 15:17 +0300, Winkler, Tomas wrote:

> There is a definitely a known issue in the driver that we still need to
> resolve, but I agree with Johannes that there is a problem in design of
> the configuration as well.=20

Nono, you cannot solve it in the driver. The whole design of mac80211
mandates that assumption and I think it is a valid one to make. If
userspace breaks because of that it's their fault.

johannes

--=-dnhPuSJkURBoNKXOBGW7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsc8//ETPhpq3jKURAm7AAKCkXr9MhWgejn+PLMrFeB23VmFHTgCguTfD
1RvaHaIcoEn7w/feDCozK24=
=ZMm2
-----END PGP SIGNATURE-----

--=-dnhPuSJkURBoNKXOBGW7--

