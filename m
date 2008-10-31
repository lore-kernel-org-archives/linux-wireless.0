Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55727 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752312AbYJaWZU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 18:25:20 -0400
Date: Fri, 31 Oct 2008 23:25:12 +0100
From: Mirco Tischler <mt-ml@gmx.de>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	Arjan van de Ven <arjan@infradead.org>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W.Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
Message-ID: <20081031232512.774ef2a1@mtlp.12.dimension> (sfid-20081031_232526_507355_F45187FA)
In-Reply-To: <1225389338.1115.338.camel@rc-desk>
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
	<1225157618.2917.215.camel@debian.sh.intel.com>
	<20081027213217.53558319@infradead.org>
	<1225171414.2917.229.camel@debian.sh.intel.com>
	<20081028172418.3c8e91f1@mtlp.12.dimension>
	<1225261084.2917.254.camel@debian.sh.intel.com>
	<20081030182433.0a4eb471@mtlp.12.dimension>
	<1225389338.1115.338.camel@rc-desk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/wRoDSNpxqSsz3_0eMqgRBTj";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/wRoDSNpxqSsz3_0eMqgRBTj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 30 Oct 2008 10:55:38 -0700, reinette chatre wrote:
>=20
> That helped us to obtain more information. Could you please try commit
> 9685e33a2c919c1e95cb7072988fc1e0f0bad3d9 ?
>=20
Solves the problem for me.

Thanks

Mirco

--Sig_/wRoDSNpxqSsz3_0eMqgRBTj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkLhcwACgkQz+diZ7c2xfg7ZQCfSA0w44IWHafd6/I/1DvtbRIf
TS0An3RYQRc0l47+YChmNL9RoLx5WBf5
=29jl
-----END PGP SIGNATURE-----

--Sig_/wRoDSNpxqSsz3_0eMqgRBTj--
