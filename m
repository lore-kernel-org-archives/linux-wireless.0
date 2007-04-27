Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755980AbXD0PW5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 11:22:57 -0400
Subject: Re: [PATCH 09/13] mac80211: remove hw_scan callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Dan Williams <dcbw@redhat.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	James Ketrenos <jketreno@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <463213D7.9070604@warmcat.com>
References: <20070423184811.7029.24949.stgit@magic.sourmilk.net>
	 <200704251634.16604.flamingice@sourmilk.net>
	 <46312067.9090005@linux.intel.com>
	 <200704262023.52833.flamingice@sourmilk.net>
	 <1177684132.21025.36.camel@localhost.localdomain>
	 <20070427164208.25434f11@griffin.suse.cz>
	 <1177685793.21025.52.camel@localhost.localdomain>
	 <463213D7.9070604@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hp1PP36wU+T47Bj7VBgx"
Date: Fri, 27 Apr 2007 17:22:43 +0200
Message-Id: <1177687364.3565.36.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hp1PP36wU+T47Bj7VBgx
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-27 at 16:16 +0100, Andy Green wrote:

> Yeah but this isn't "in hardware" -- it's in firmware: software that
> runs of a different, vendor-specific, CPU.

[...]

Guys, this discussion is deteriorating rapidly!

The diff to rip out the hw_scan callback is tiny, and since it'd need to
be worked on anyway to add notification when scanning is done, IMHO it
is little more work to remove the scan now and add it back in one patch
including the notification. That just pushes the problem back to those
people who want/need it and then they can decide if it's worth the
effort and if they can show that it brings enough advantages.

The current cfg80211 scanning API is pretty much modeled on the 802.11
MLME interface and as such should be easy to push through to the
firmware if necessary, even through mac80211.

johannes

--=-hp1PP36wU+T47Bj7VBgx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMhVD/ETPhpq3jKURAgJKAJ9h4SfW9zBf3vhtqM2dByEO79FLoACguBl9
af6yATiYntncepcVtooMtMI=
=QXr3
-----END PGP SIGNATURE-----

--=-hp1PP36wU+T47Bj7VBgx--

