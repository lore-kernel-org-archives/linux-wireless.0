Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40551 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYJTGiQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 02:38:16 -0400
Subject: Re: New Regulatory Domain Api.
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Zhu Yi <yi.zhu@intel.com>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810192333r7b3f6a0m56d499d0aed9240e@mail.gmail.com> (sfid-20081020_083338_695077_49476712)
References: <20081015112517.GF6509@tesla>
	 <1ba2fa240810151735t100ceda5s7fe7b495f735c507@mail.gmail.com>
	 <20081015174447.GF15902@tesla>
	 <1ba2fa240810151757r11060dfble6b58c76a7d0d8d1@mail.gmail.com>
	 <20081015185636.GH15902@tesla>
	 <1224126030.24677.78.camel@debian.sh.intel.com>
	 <20081016113848.GB5899@tesla>
	 <1224471102.24677.124.camel@debian.sh.intel.com>
	 <43e72e890810192040w567fa4f6j1bf40e80084a857e@mail.gmail.com>
	 <1224479933.24677.148.camel@debian.sh.intel.com>
	 <43e72e890810192333r7b3f6a0m56d499d0aed9240e@mail.gmail.com>
	 (sfid-20081020_083338_695077_49476712)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hnQyK3zOHMZ3m6wpye0G"
Date: Mon, 20 Oct 2008 08:38:05 +0200
Message-Id: <1224484685.18024.5.camel@johannes.berg> (sfid-20081020_083819_912798_C2C6E171)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-hnQyK3zOHMZ3m6wpye0G
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-10-19 at 23:33 -0700, Luis R. Rodriguez wrote:

> Well the code specifically disregards secondary regulatory_hint()'s
> right now and we reviewed why -- we discussed it at OLS and agreed to
> go with the first one as that will usually be the built in one. That's
> why. The restrictive thing to do next to handle more cards better is
> to keep doing intersections.

If we're going to disregard 5 GHz for the first hint if there's no
information on it, then we should take the first hint containing 5 GHz
information seriously imho.

johannes

--=-hnQyK3zOHMZ3m6wpye0G
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/CdKAAoJEKVg1VMiehFYb10QAK/Mda0emjAgHh4yyZFWE4xo
lc1FXJY5Egvs1viFb/es+D3WU2gnucXSLgQW4ZEDAAyoALtJLKCiR7GCPFVIixvH
ilXi8s6uFskQOybv5FZq/70PpMKn1kK7Klxgj9fHPodX/SrRkXbUkU5gb5H9kZJA
Yw8Lx5f00Ea891yaLecl1zsKc6+mbPbT3VSYTxH/SxOKVfCwfx6D8T/YNpFhXpD4
cV8nW24NVaFE2GWw9Y7WG8Ln3YOnYmbTKnRcXiFN1oopxwqg1/jkNzAUaRJG+D4Q
ecKRq+2k72jBDmwdTQyfW974TxkJHDmf0GEzHsjRJ0jVVxq25cCMFULvsuk1S1c0
+UVb4XsD2B9+A5mliDmHxpu2A8jSVN1bwFFw+7eX8kO4tVIVtNd8QNwU0pc4Ia06
xEK1OfIBqBBzlWWY+A3Gp5MDaWnfYkTK20wmeMdYe0/E+59d6UhV0Xpf741uG2bv
J8TBo0FqvyB4VQKulWC8Gf9ofylJAorZcTOKFc9AnUiYhPUOVAY7dSaybnER81ZA
3hetQK5pzRBJBWAtCiJBJgznu9qBLLwBVrAa2/8z+UQ68ZRk1Xdk6/ARhVFYMM7R
QxDP6Yh5ypNmVm/ent7LRzyLVWCcOVvi/Ttv/BJRO0FbLyUseX18AdSr3ACH+/L6
Uy5lxEbQyLOw2Ney2VZu
=nYMc
-----END PGP SIGNATURE-----

--=-hnQyK3zOHMZ3m6wpye0G--

