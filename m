Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55306 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965496AbXDLIza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2007 04:55:30 -0400
Subject: Re: [patch 2/5] Add basic support for IEEE 802.11n discovery and   association
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Simon Barber <simon@devicescape.com>,
	Michael Wu <flamingice@sourmilk.net>,
	mabbas <mabbas@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <jkm@devicescape.com>
In-Reply-To: <461D6E4F.6060401@warmcat.com>
References: <1174909105.1364.53.camel@dell-4965.jf.intel.com>
	 <20070411194059.GA2436@tuxdriver.com> <461D3F48.70004@linux.intel.com>
	 <200704111630.06160.flamingice@sourmilk.net>
	 <1ba2fa240704111503l6dcef504na73c997ae75ebccd@mail.gmail.com>
	 <C86180A8C204554D8A3323D8F6B0A29F01DEB33D@dhost002-46.dex002.intermedia.net>
	 <1ba2fa240704111605l305230d3vf09c085473364eb3@mail.gmail.com>
	 <461D6E4F.6060401@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8VJC3x16hiFZyOenWyLc"
Date: Thu, 12 Apr 2007 10:56:49 +0200
Message-Id: <1176368209.7052.10.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-8VJC3x16hiFZyOenWyLc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-04-12 at 00:25 +0100, Andy Green wrote:

> Since hopefully the concept will involve a kernelside-filtered=20
> monitoring action via libpcap, the stack could for example inject a=20
> periodic stats summary packet down the monitor interface back to userspac=
e.

Eek. No *new* fake packets any more please.

johannes

--=-8VJC3x16hiFZyOenWyLc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGHfRR/ETPhpq3jKURAjksAJ45WzyXT3mW+TPiYwq/22OPyVFgtgCfTjzE
h/QayjF2rdSBOB0CGRgGQJ0=
=pa3w
-----END PGP SIGNATURE-----

--=-8VJC3x16hiFZyOenWyLc--

