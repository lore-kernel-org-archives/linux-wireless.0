Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35204 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872AbXHCJnA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 05:43:00 -0400
Subject: RE: [ipw3945-devel] chaning mode only when interface down?
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	network manager <networkmanager-list@gnome.org>,
	ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1186080675.9527.10.camel@xo-13-A4-25.localdomain>
References: <C07C4589BE74A34981C3C3525EE1F801024CF2CB@hasmsx412.ger.corp.intel.com>
	 <1186058047.24230.38.camel@johannes.berg>
	 <1186080675.9527.10.camel@xo-13-A4-25.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9ZcEdeiMcMw13N9BG3EW"
Date: Fri, 03 Aug 2007 11:42:57 +0200
Message-Id: <1186134177.4647.19.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-9ZcEdeiMcMw13N9BG3EW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 14:51 -0400, Dan Williams wrote:

> Well, to be honest none of the drivers before mac80211 required you to
> down the device to change modes.  But they were mostly fullmac, or
> half-mac like ipw2x00.  Since mac80211 has only just become useful in
> the past couple of months for most people, it's not really fair to
> expect versions of NM that were out before mac80211 landed to play nice
> with what mac80211 expects, which is different from what other drivers
> implement.

True.

> Not to say NM shouldn't be fixed for this.  The other problem is that
> there's really not a good way to determine whether the driver is
> actually _ready_ after down it and bringing it back up.  You basically
> have to spin & block until the interface gets IFF_UP set on it again,
> and even then that's not entirely reliable.

Not sure I understand? Drivers can fully well block the userspace task
that is doing the IFF_UP until they're read? bcm43xx does that.

johannes

--=-9ZcEdeiMcMw13N9BG3EW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsvih/ETPhpq3jKURAnd3AJ0b1+ZmIj2DvxF38U+SrtAAMcbbiwCdE0yV
omyl0C6VmKq3hHeT11cXrZc=
=Agz+
-----END PGP SIGNATURE-----

--=-9ZcEdeiMcMw13N9BG3EW--

