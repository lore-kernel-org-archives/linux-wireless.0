Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39935 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757601AbYJNJUL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 05:20:11 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"lrodrigues@atheros.com" <lrodrigues@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1223608949.2510.1061.camel@debian.sh.intel.com> (sfid-20081010_052512_883760_F373F92C)
References: <B27EBC40D200ED48A3F4CC2EBEABAE0B16C892F2@orsmsx501.amr.corp.intel.com>
	 <20081009154547.GB13349@tesla>
	 <1223608949.2510.1061.camel@debian.sh.intel.com>
	 (sfid-20081010_052512_883760_F373F92C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YjjNSfAjkXK6kYRb6WgK"
Date: Tue, 14 Oct 2008 11:19:32 +0200
Message-Id: <1223975972.10113.20.camel@johannes.berg> (sfid-20081014_112018_365305_DCCE7DBE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-YjjNSfAjkXK6kYRb6WgK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-10-10 at 11:22 +0800, Zhu Yi wrote:

> Does below scenario an expected behaviour?
>=20
> 0. A system with iwl3945 BG card and iwl4965 AGN card.
> 1. insmod iwl3945 -> regulatory_hint(, 99, rd) return 0;
> 2. insmod iwl4965 -> regulatory_hint(, 99, rd2) return -EALREADY;
> 3. iwl4965 has no A band support!

Yeah, I think this is expected, and the solution is to install crda and
iw and set the regulatory domain manually to whatever country you're in
rather than your cards SKU.

johannes

--=-YjjNSfAjkXK6kYRb6WgK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI9GQgAAoJEKVg1VMiehFYKe0QAKk6xJXHzmzefctaJofK4h9A
ZHT44GNhxKTtfthye/hoWosfM8U3NZ36acLDyPKRPvOQljHmQEioJgXxmcoMdll5
DKZWAM6QR8sVj/bFrok9pvUHQaJQNHnoDy1Coq9QX1PNJXLJuKXhpT5wGtaLY2Rl
zoewS6lIRk/WZNRmWpEUjrxeZXMnO94xO+YX3rJAFKzrDOHiDUqlbOTT0LD37n1r
X226k05HxR3BkT/pKHgrssqN2dWyHYvqCZEkvzqRPaO175VtngG26tplpKCHQReJ
VegpMtvFB8AkQ6e9FBFF7RilSROHZTuUKGAZdcPggFKy+MOrcknAGod3awDtbmGH
BEo1bsv27n/2kM5f8iQPxEnDcJ0LPUi/pulQ5bS0A+7Ommx5avzOafaKznlbyOOP
w29RlLA5FgDF8/IaOoZsSlN36szIwZWsYDBPIB1LWHa0h/jGXqPCSfogIoNWntRS
/HItmi2tfAfxqz3HCmnOpOu8ymB4+eoG++eAdppZ0I6sZ8ahej5y6BG+KhFeuTo3
K0x9MUD/t38nw5vArmfNbzcb3XLmHKwP6xjLhzlBpsi00k2MFGNUpMVArjJkDjG3
Az63dMPISMJztbEBCOolMovXwROvJZuzMlNjxVQpZD3mwvpMZYyab/lN1YEgivNU
ZV8re2K4iiE2Tu3akQ/c
=r24h
-----END PGP SIGNATURE-----

--=-YjjNSfAjkXK6kYRb6WgK--

