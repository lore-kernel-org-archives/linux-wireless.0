Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbXIJLIm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 07:08:42 -0400
Subject: Re: zd-mac80211: Fix TX status reports.
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ulrich Kunitz <kune@deine-taler.de>, Daniel Drake <dsd@gentoo.org>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200709101258.39619.mb@bu3sch.de>
References: <200709082341.31720.mb@bu3sch.de>
	 <200709091259.00237.mb@bu3sch.de> <1189421542.4506.46.camel@johannes.berg>
	 <200709101258.39619.mb@bu3sch.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NPvZryeYwwQ4Nxk1z3PV"
Date: Mon, 10 Sep 2007 13:10:11 +0200
Message-Id: <1189422611.4506.58.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-NPvZryeYwwQ4Nxk1z3PV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-09-10 at 12:58 +0200, Michael Buesch wrote:

> I think the ack callback is pretty reliable, so that should be OK.
> It looks for the ACK in software.

Right. But Uli mentioned that it can become out of sync. Is there no
indication about how many times a packet was transmitted before it was
acked?

johannes

--=-NPvZryeYwwQ4Nxk1z3PV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5SYT/ETPhpq3jKURAtgNAJ4nqqLblNxbgHLuGm6A0ZqPkBXtOwCeKIAV
Di/lqTiKG9M12RpbGMNrrH0=
=YX2f
-----END PGP SIGNATURE-----

--=-NPvZryeYwwQ4Nxk1z3PV--

