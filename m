Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361AbXGFKoK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 06:44:10 -0400
Subject: Re: Multiple interfaces in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Jon Smirl <jonsmirl@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20070705135748.GA7272@tuxdriver.com>
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com>
	 <200707042305.40944.flamingice@sourmilk.net>
	 <1ba2fa240707050530q2d165232raa73455397546c62@mail.gmail.com>
	 <1183638845.3818.34.camel@johannes.berg>
	 <20070705135748.GA7272@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VGE6KgTzcGRNFWveAwbA"
Date: Fri, 06 Jul 2007 12:44:40 +0200
Message-Id: <1183718680.3818.98.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VGE6KgTzcGRNFWveAwbA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-05 at 09:57 -0400, John W. Linville wrote:

> Actually, the new multiqueue stuff should enable us to get rid of the
> master interface.  The queueing currently associated with the master
> interface should look like hardware queueing to the networking core.
> The fact that it is implemented in software is just an implementation
> detail.

I don't think so, it will allow us to have multiple queues per device
but not allow having a single qdisc see *all* traffic from all virtual
interfaces. But if you can make it work I'm all ears :)

johannes

--=-VGE6KgTzcGRNFWveAwbA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjh0Y/ETPhpq3jKURAkjXAJ9PYyBQ5ybnMwBTkTcWPGqsJ2ctBgCcDXFt
5dkhZ6rtsNjX9B/A4AdjjlY=
=4YOg
-----END PGP SIGNATURE-----

--=-VGE6KgTzcGRNFWveAwbA--

