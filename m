Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854AbXLMLju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 06:39:50 -0500
Subject: Re: mac80211 ethtool support
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Tomas Winkler <tomasw@gmail.com>, Michael Buesch <mb@bu3sch.de>,
	Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20071213002739.GB3139@tuxdriver.com>
References: <1197361048.3170.381.camel@debian.sh.intel.com>
	 <200712111350.25522.mb@bu3sch.de>
	 <1197421988.3170.405.camel@debian.sh.intel.com>
	 <200712121148.48716.mb@bu3sch.de> <1197481520.6558.140.camel@johannes.berg>
	 <1ba2fa240712121523h59d919f8k42fe54b992618432@mail.gmail.com>
	 <20071213002739.GB3139@tuxdriver.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lyYb9qxyuESX+YAsFU8v"
Date: Thu, 13 Dec 2007 12:38:50 +0100
Message-Id: <1197545930.6558.243.camel@johannes.berg> (sfid-20071213_113952_999379_CF988A03)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-lyYb9qxyuESX+YAsFU8v
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Has anyone taken the trouble to analyze the various ethtool operations
> to see which ones even make sense for wireless devices?  That might
> make a better starting point for discussing how to implement whatever
> remains.

Most, except very few hardware-specific like the EEPROM under discussion
and a few driver-specific (get driver version etc) don't make any sense,
like WOL, GSO, pause, UFO, ...

johannes

--=-lyYb9qxyuESX+YAsFU8v
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2EZyaVg1VMiehFYAQJMhRAAxZGArPqaYUlOw+nMm4k1a0/AgPWq3ByH
Bc8E73n70Wk91Du3M6bwBxnSiXxXygTdY2JGjPkzYl9YuyeqneTc0ygZGipoDPVP
KfM1ReSbEANdj5GGnaLMTVebTZzRZsaOaaJifP+ZIlxvSX643V0yWjOotkiRtKRX
Qat/MMWmi/R5GKrG4TkObgCwXFPfvM/z6n6gi5/XcFbK9WhVsIhFQNcILH1iadY6
WNblP3bstS+tL1iWjYIBnaGlNxcghFGhgulPfbQFzueo5bZ8mpjLJRHwnhyWPDLN
USFUCU/4N/SP+PgYJP43C5vqKKifJ6QU5RZ1Dq59cw5B/X0aGnCE4lAG3CQDiRVB
r5Um0tJy2nDYWpsFOIUqcMl1FiDwWuBD9A6IpB4oRGObvtMKs4NnxrrwiHSb4Sbj
7IHLxJJTnsix6gRLyyt/ccmXMfejgX4J2Dx8TgWZTghYd6DB76ui1mc5PymKEjl8
9t9qsfS4VJJnVtsANGcCl4EU9zSQJyRuF3S1lQjMBroIgDN8HbjS6hz4QIdIXAps
IbbbORlhBqnMdi0R2bF2PBQH4aIn049PfTBrmK0K3kZy/1+Lk46vT08lay+fhIe8
3HpWtfrbx/Z6ZzcvEBcxaSDtcqroZMvawROpv0mYNnZ8wnBbvDuGLAFFdJwO2AfQ
TRT6MdQw2nE=
=uHtU
-----END PGP SIGNATURE-----

--=-lyYb9qxyuESX+YAsFU8v--

