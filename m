Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53753 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbYBFONT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2008 09:13:19 -0500
Subject: Re: [RFC] mac80211: add rate to ieee80211_tx_status
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	Felix Fietkau <nbd@openwrt.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240802051515y4028608cj38047fcebeec0898@mail.gmail.com> (sfid-20080205_231540_752489_1734F43B)
References: <12020697053277-git-send-email-tomas.winkler@intel.com>
	 <1ba2fa240802040621h2c0e9fe6yb5d84d24513aedf4@mail.gmail.com>
	 <-7767648866191425885@unknownmsgid>
	 <1ba2fa240802040713k56fdf22fp8ab15924bbebe88@mail.gmail.com>
	 <47A72E13.8070305@openwrt.org>
	 <1ba2fa240802041036v2b311eb4vcced7a9f1e2aa6a0@mail.gmail.com>
	 <47A75BF5.90101@openwrt.org>
	 <1ba2fa240802041103v622db90co2ddc24eda3347ffc@mail.gmail.com>
	 <1ba2fa240802041105g1e11ba99ldaca4acee4a07c35@mail.gmail.com>
	 <20080205222340.70e043cd@morte>
	 <1ba2fa240802051515y4028608cj38047fcebeec0898@mail.gmail.com>
	 (sfid-20080205_231540_752489_1734F43B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5nnFQtAtX0ws8WLJ4K0P"
Date: Wed, 06 Feb 2008 15:13:03 +0100
Message-Id: <1202307183.4395.38.camel@johannes.berg> (sfid-20080206_141322_388500_3FC8A15B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5nnFQtAtX0ws8WLJ4K0P
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Just keep in mind that some driver requires to report ACKed frames to
> make rate scaling algorithm to work properly, this should be optional
> only.
> Second I believe for some management frames it's good to notify mac
> about successful transmission regardless of rate scaling algorithm.

Hostapd wants that for EAPOL frames as well, so it has to be somehow
triggerable per-frame.

johannes

--=-5nnFQtAtX0ws8WLJ4K0P
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR6nAbqVg1VMiehFYAQKiNA/+LWl6joLJj5ZDL8D3FxxyE5lP1ierAShr
5qJ1NYMTrKFhWJo2gb5CFmFAMWWJ0t8PbT2ebUGxDMfhLjai9FiaGj+ASS/4LDaj
gtCkbgrB4UneNKzSxcGvkJlSGX1aJFHBCrwzyWs3+YHqb+gsAV0QCF7ZOBrhEqYs
58lhmIbOFKM5jcVYnMe+2RpqqigjjZ/2aDj+FGcvda+pInFlrikVfSjL3+mx93dS
gjHGwvUT9ZXaerdE47NbMYPy1Ma7kZdH1mlI5gEKuAY+LSASA78UrdFftpD6NTcS
52QqAtbR/b36Uh6hta7a0SlmiT5OcIEL1WV5deo29AJKfUvc7ma7YXZK7mi/408d
NLkqTKnVcugjohKZkT4ZVK8skAtuuskc+80ApKX8nnJvY43QhMGdaK2iu0FV9QM/
xG1NFnzAKh4C8jh5lp2HU+iJzJZnUS9HK1JBLsaa1Bcr1vOFKJF5xQ8pwshwcTz1
PazqLoLp84l7p1os7Ga/MXf0xC5mAGgY2pGODdfisjShBPbnihc6oYBfbRPo5QeX
N825cOXvMNhg2DT0+VbERvNi1BdO17J3EtH28f72G8iZRy521W8uI22Peewkwivn
9n3RlCj7WYKMRB9F/NRxkPb9dwlkKoWFll1FTKkpngZ3DCw0zMFaDrRrmR8/EsV5
USr0YVO9NUo=
=vJN/
-----END PGP SIGNATURE-----

--=-5nnFQtAtX0ws8WLJ4K0P--

