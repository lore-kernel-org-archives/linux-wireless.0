Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37738 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbYAXOuk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 09:50:40 -0500
Subject: Re: [PATCH 03/12] mac80211: A-MPDU Tx adding basic functionality
From: Johannes Berg <johannes@sipsolutions.net>
To: Ron Rindjunsky <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, tomas.winkler@intel.com, yi.zhu@intel.com
In-Reply-To: <12009163393182-git-send-email-ron.rindjunsky@intel.com> (sfid-20080121_115439_500829_54AD44A6)
References: <12009163321727-git-send-email-ron.rindjunsky@intel.com>
	 <12009163393182-git-send-email-ron.rindjunsky@intel.com>
	 (sfid-20080121_115439_500829_54AD44A6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OLkbjUB1VXDrxvqe1EM3"
Date: Thu, 24 Jan 2008 10:34:40 +0100
Message-Id: <1201167281.3454.65.camel@johannes.berg> (sfid-20080124_145058_906100_2DC6AA56)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OLkbjUB1VXDrxvqe1EM3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	/* Will put all the packets in the new SW queue */
> +	/* ieee80211_requeue(local, ieee802_1d_to_ac[tid]); */
> +	spin_unlock_bh(&local->mdev->queue_lock);
> +
> +	/* We have most probably almost emptied the legacy queue */
> +	/* ieee80211_wake_queue(local_to_hw(local), ieee802_1d_to_ac[tid]); */


Can't you re-order the patches instead? Or, if it simply doesn't work,
I'd much prefer them to go into the tree as a single patch. (You also
introduced leading whitespace in the patches removing the comment marks)

johannes

--=-OLkbjUB1VXDrxvqe1EM3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR5hbr6Vg1VMiehFYAQJH5A/+JXr64PVSNaVUBFU946gWgSHWDEHNyRSL
QNNcqtntc7Fty8qxKx2GOD3PJ1yHiLrV2+3uPHdKZmjVpANajNosk4k7RVzZ5LDZ
OvlnXG4eEbSW5I6RUI1orGi7dOu0q0jYEMJW8H8q1PFzI/5MYCpEOhqT4I9/EWaK
pfizwHR8OtoZ2SbhTgErdx0Lglhjs8tDoDwMf9Nu0uQLh8/6Ayx0u0ibhby0A87k
OjuvnEifVT6Gyt1Cbrw9D4c93WhTwv88Rhn3oXFOO7Z8xR7Yxg3MZ8LAcoBT8ifj
mtn0bSgIe31CzwxcFypZRVTHb0vKXZTIzsHNvpPzMz0BHdzsvX06U9JXSKWUcTnB
TnhjFybzcApO77mK5v+vE3qMV/ERTveJ/U73a+bTQiEMthlSOmDW8H2s6v5WDz7G
Rht0trnHUUOZbIX1E+USu/kXCR4Y3tzt/X3Trl66etCTz/Pu3LxwdoLivD78/SjY
Jrf/+Y38VzATE0biRJJ0Q2523vEKErRBe1JuwB8JkV5XPF5Kx7A30EbLce2RuAw8
a2dcSDmM9vx4oP5y4HBa+aRX9lIPLDLlKZQTT+9WKF3gVslIVwbTacF9MIdwUxc4
k0uuQnAkWkR3kzqheHbWZwfCNcSBC37Nlk32njvuq8e4lcq7aa/vXpXE9kUvs/E4
//G77o1zZyw=
=Gumj
-----END PGP SIGNATURE-----

--=-OLkbjUB1VXDrxvqe1EM3--

