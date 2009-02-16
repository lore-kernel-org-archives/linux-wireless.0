Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gold.linx.net ([195.66.232.40]:46224 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZBPMJd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 07:09:33 -0500
Subject: Re: IWL5300, 2.6.29-rc4, CRDA 1.0.1: Missing out 802.11A frequency
 ranges
From: Tony Vroon <tony@linx.net>
Reply-To: tony@linx.net
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	reinette chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20090214045232.GA5769@tesla>
References: <1234202993.21570.18.camel@localhost>
	 <43e72e890902091020p65235e3ds833560974c785318@mail.gmail.com>
	 <1234203811.21570.19.camel@localhost> <20090209183924.GA6069@tuxdriver.com>
	 <1234207263.6694.1.camel@localhost> <1234208152.6694.4.camel@localhost>
	 <20090210013941.GA4386@tesla> <1234230689.3793.15.camel@localhost>
	 <20090210020708.GC4386@tesla> <1234379981.4789.7.camel@localhost>
	 <20090214045232.GA5769@tesla>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-bywdwxdSyFq1oWR6NeDu"
Date: Mon, 16 Feb 2009 12:08:44 +0000
Message-Id: <1234786124.4271.2.camel@localhost> (sfid-20090216_130942_898521_881009FB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-bywdwxdSyFq1oWR6NeDu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Just to confirm, if I use my early-boot hook that I used for your iw
list to set the regulatory domain manually (iw reg set GB) all is well.
If I allow the driver stack to get to the association stage without
setting a regulatory domain, I can never get my 802.11A spectrum back
after the fact.
Would you still see this as a bug or rather a specific requirement of
the new interface that hasn't yet been documented?

Regards,
Tony V.

--=-bywdwxdSyFq1oWR6NeDu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmZV0wACgkQp5vW4rUFj5p/EgCfQHpiczFALZE12NqPvmhxGmC6
M8MAoKs/CAknZ4axlCoUfwEywBkclXrl
=YFtO
-----END PGP SIGNATURE-----

--=-bywdwxdSyFq1oWR6NeDu--

