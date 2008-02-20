Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60385 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbYBTSbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:31:38 -0500
Subject: ath5k vs. sparse
From: Johannes Berg <johannes@sipsolutions.net>
To: bruno randolf <br1@einfach.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-h6M8ynzf5YQQS78hy72Y"
Date: Wed, 20 Feb 2008 12:01:58 +0100
Message-Id: <1203505318.17534.19.camel@johannes.berg> (sfid-20080220_183140_693561_F192F0EB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-h6M8ynzf5YQQS78hy72Y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

You really should run sparse too. Even a locking bug when "error in
processing rx descriptor" happens.

drivers/net/wireless/ath5k/base.c:1717:11: warning: restricted degrades to =
integer
drivers/net/wireless/ath5k/base.c:1719:11: warning: restricted degrades to =
integer
drivers/net/wireless/ath5k/base.c:1721:20: warning: restricted degrades to =
integer
drivers/net/wireless/ath5k/base.c:1730:19: warning: incorrect type in argum=
ent 2 (different base types)
drivers/net/wireless/ath5k/base.c:1730:19:    expected unsigned long long [=
unsigned] [usertype] bc_tsf
drivers/net/wireless/ath5k/base.c:1730:19:    got restricted unsigned long =
long [usertype] timestamp
drivers/net/wireless/ath5k/base.c:1739:1: warning: context imbalance in 'at=
h5k_tasklet_rx' - different lock contexts for basic block
drivers/net/wireless/ath5k/hw.c:534:11: warning: incorrect type in assignme=
nt (different base types)
drivers/net/wireless/ath5k/hw.c:534:11:    expected unsigned short [unsigne=
d] [usertype] tx_time
drivers/net/wireless/ath5k/hw.c:534:11:    got restricted unsigned short=20
drivers/net/wireless/ath5k/hw.c:3715:10: warning: cast truncates bits from =
constant value (ffffffea becomes 0)

johannes

--=-h6M8ynzf5YQQS78hy72Y
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR7wIpaVg1VMiehFYAQLkYw//fAKbd+gh0e8G09TLNG/s/QlxJT1sKoK/
OWqmSPpxgWzMwnMO8kMJN0Ol0U0uhPBnYNX08QFyqUvlkPVIQf7zShOAMa7qA5XB
UmSoPGmy9m6+r720ynBPjXaeB8e/cbqn158hCQ8iRvNTaPNpO+v+nidP0L0XDOK4
qlCx9coghcGiqhOEbblK4ftJf65cRd3RPps6JrH+fQpi7LjO6QHlLrfi8PE4RvHw
LPCrwDZz+mVimCUOsGmgiy5XiYbhqqUl+fFGbrHKABFGaKwtgBtB/BOOqv51wOx8
cLAOdHhZNygjPsS4KpFSggz2rkggfN6IOJ1biEB2G+78GcrjGUgJ8QshoS9S1HjW
jli8JBHV5M1WMB3dJLhys7nus4VfipRXWb6g2H7FSmmO+xNqr8ZLgHB4lUNcG6HE
LBgb671iy4xf7cSH58fk/2rIqAYa9xeOgTwy6M4dJBrbl6e09nkC0YsCM7+v71XJ
/ghKa60Ln1RtcUaKYUJciw2tSK0qJdNYgPcRHULy86mr1u0sWvnM21hR0Q2jdHnd
HFo/KhQHxXS1Ss/+MAvX2wYU0ns450ic3nU7rMk14v0LLRHnFXUh7x79BQBnOhPI
qMVmngXHQguImK/K5iughuDpW3UuxYGHaxCiQvJWkjWMaFLtpPE7ZDDEnJUmzwoi
I3KRHzwBMtA=
=9mV9
-----END PGP SIGNATURE-----

--=-h6M8ynzf5YQQS78hy72Y--

