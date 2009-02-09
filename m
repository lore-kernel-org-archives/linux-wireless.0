Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:50764 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757428AbZBITg2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 14:36:28 -0500
Subject: Re: IWL5300, 2.6.29-rc4, CRDA 1.0.1: Missing out 802.11A frequency
 ranges
From: Tony Vroon <tony@linx.net>
Reply-To: tony@linx.net
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org,
	reinette chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1234207263.6694.1.camel@localhost>
References: <1234202993.21570.18.camel@localhost>
	 <43e72e890902091020p65235e3ds833560974c785318@mail.gmail.com>
	 <1234203811.21570.19.camel@localhost> <20090209183924.GA6069@tuxdriver.com>
	 <1234207263.6694.1.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-c3sDt1U04JqkwZ8f0+Jg"
Date: Mon, 09 Feb 2009 19:35:52 +0000
Message-Id: <1234208152.6694.4.camel@localhost> (sfid-20090209_203717_909324_92B33937)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-c3sDt1U04JqkwZ8f0+Jg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Do correct me if I'm missing something here, but:
cfg80211: Leaving channel 5180 MHz intact on phy0 - no rule found in
band on Country IE

How will leaving the channel intact help, if the static world domain
turned it off in the first place? (Note that the CRDA request for the
world domain is emitted by the kernel before /dev/sda is even attached,
so needless to say that goes unserviced)

Regards,
Tony V.

--=-c3sDt1U04JqkwZ8f0+Jg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmQhZgACgkQp5vW4rUFj5rOcwCfel1rgi6+ZmN9kpKcpXNKg3kt
0cYAn3R6KEp6XU9NMcHc2QzI8LUQI/yF
=b4Ul
-----END PGP SIGNATURE-----

--=-c3sDt1U04JqkwZ8f0+Jg--

