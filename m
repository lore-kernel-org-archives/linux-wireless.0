Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39709 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbXHBMpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 08:45:24 -0400
Subject: RE: [ipw3945-devel] chaning mode only when interface down?
From: Johannes Berg <johannes@sipsolutions.net>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: dragoran <drago01@gmail.com>, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	network manager <networkmanager-list@gnome.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <C07C4589BE74A34981C3C3525EE1F801024CF30B@hasmsx412.ger.corp.intel.com>
References: <C07C4589BE74A34981C3C3525EE1F801024CF30B@hasmsx412.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-plj5/w6ER6iCR3FW9S9v"
Date: Thu, 02 Aug 2007 14:46:43 +0200
Message-Id: <1186058803.24230.42.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-plj5/w6ER6iCR3FW9S9v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 15:41 +0300, Winkler, Tomas wrote:

> I'm really not an expert on the configuration but I think at least the
> transition from STA to IBSS mode and back should be smooth without
> reloading the driver. What you do if the driver is compiled to kernel
> will we reboot?

Oh you don't have to reload the driver, you only have to down the
interface. If you have to reload it that's a driver bug, but the fact
that you have to down the interface is a mac80211 "limitation"

johannes

--=-plj5/w6ER6iCR3FW9S9v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsdIz/ETPhpq3jKURAkMdAKCdctUIcueYVRde6kF1bABAFZyBSACeLuMj
q2RWeGu3Scl5F4rTiSnddNU=
=HD77
-----END PGP SIGNATURE-----

--=-plj5/w6ER6iCR3FW9S9v--

