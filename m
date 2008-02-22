Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48968 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbYBVPQM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 10:16:12 -0500
Subject: Re: mac80211: STA info size
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <20080222143409.GA3067@tuxdriver.com> (sfid-20080222_150738_689668_5F34E6AD)
References: <1203675307.26341.29.camel@johannes.berg>
	 <20080222143409.GA3067@tuxdriver.com>
	 (sfid-20080222_150738_689668_5F34E6AD)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DsIYCoMxYVfojA9X5DGQ"
Date: Fri, 22 Feb 2008 16:15:53 +0100
Message-Id: <1203693353.7082.28.camel@johannes.berg> (sfid-20080222_151624_206155_5F8CA384)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DsIYCoMxYVfojA9X5DGQ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > STA info struct currently (after my reorg) takes 2432 bytes. Almost 200=
0
> > of those are in struct sta_ampdu_mlme which is most likely not used for
> > most STAs.
> >=20
> > Do you think that is too much memory per station? It'd probably be
> > possible to allocate the sta_ampdu_mlme dynamically when needed, no?
>=20
> My count was closer to 1.5k, but I may have missed something.

You need to get pahole :P

http://lwn.net/Articles/206805/

johannes

--=-DsIYCoMxYVfojA9X5DGQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR77nKKVg1VMiehFYAQJt2hAAi9znugOl2JOfe6Q3yHJc0pVCVWjjTnvh
w3dJOrt3y+IghBio3bZb8Co7x/jxoTRkSiGiv3VX3T4FmYbMwL6cpzTLm6ZJvP/r
9lDVLEf4L8T2+E599RXQXk7Ja5SZkAOnPB3r6W0DuwMmrwNQyIVGGKNQ5HvNyIjD
k7kuZ7gub+/wsum8KRkCQdNiywxYoFKmzM7ffbLTO70CMpNdqLSLYR792xclE9GF
Y8JB6nh9BdF7MUu/Ta/hJgHmi7O2PCgwnw5BA9kcfoxX1ODoCWfYp1nUCXR+M0CE
4KPAB4AXJxtynwJlTZYSJU/WaRI1G1gr+6X+jBgqjGt3Jomlipmk37a4T0xKBcyv
xH4F1BlaZtg3kyxlnVbMDmblO9573hFd0sFXCkztTk4HcJYbWiRUtTyZ8mBK+F8y
/jPNsGI2hDlksAVw1hd316inSQZZ5qtOXQqn/GR/+U82C56QnN3uZnIMOf4Nzszt
FIJxtdPiktELB3fuMLAfYaI3dkKnGfWQ3q2hqTynCDSTPflaXzShl/B7ASVkZcy8
kNwClaOHmluPNC8Np2RV3ASTsKPegAGGHQUNxY7axhBfY5xCXuvyk3los59sDtgd
IIGTWg8J78J014RZZLqgw+3+Em7ssRKZesH6JNXTcIjNLigDD8J329hp0ny7J+kk
NaVN6hyHHTU=
=GboK
-----END PGP SIGNATURE-----

--=-DsIYCoMxYVfojA9X5DGQ--

