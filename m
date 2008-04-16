Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:56243 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007AbYDPCXU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Apr 2008 22:23:20 -0400
Message-ID: <480561DE.7020205@atheros.com> (sfid-20080416_032328_485113_154B7FFD)
Date: Tue, 15 Apr 2008 19:18:06 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
MIME-Version: 1.0
To: <ath5k-devel@lists.ath5k.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Atheros kernel support, joining the company
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig3855A978AD66761DB7381C29"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------enig3855A978AD66761DB7381C29
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable


Fellow ath5k hackers,

Good news. I write to you to inform you that I have decided to join
Atheros as a full time employee, as a Software Engineer, to help them
with their goals and mission to get every device of Atheros supported
upstream in the Linux kernel. I realize there are a lot of challenges
ahead but I am well aware of the how the community works and the
benefits of working with it and am confident we will find ways to
strengthen the relationship between Atheros and the community. I also
realize there are a lot of pending questions and perhaps even more now.
Please rest assured we are doing what we can to work together as soon as
possible.

I will keep maintaining compat-wireless and prism54 but I didn't get to
finish the Marvell TopDog driver port from net80211 to mac80211. Hope
someone is willing to take that over as I will be pretty busy with other
work now.

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/mrvl_cb82.git

I do plan on keeping on pushing the Central Regulatory Domain Agent work
I had started. The db schema and a port of ar5k regulatory information
to it can now be found here:

http://winlab.rutgers.edu/~mcgrof/crda/

In the coming weeks I hope to finish the integration now that a db is
available and hope to also update the db with more up to date values.

   Luis



--------------enig3855A978AD66761DB7381C29
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIBWHhat1JN+IKUl4RAqZIAJ41YAzWBMzE0ilNm917N0p4IwXsMgCdETSQ
39IlGIhzAqC5B+f2B0LpygA=
=Rtp+
-----END PGP SIGNATURE-----

--------------enig3855A978AD66761DB7381C29--
