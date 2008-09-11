Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:60963 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbYIKTN0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 15:13:26 -0400
Subject: Re: [PATCH] libertas: Improvements on automatic tx power control
	via SIOCSIWTXPOW.
From: Johannes Berg <johannes@sipsolutions.net>
To: Anna Neal <anna@cozybit.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
In-Reply-To: <aa050c750809111156s41d4cfcbnc79ed65687f97348@mail.gmail.com> (sfid-20080911_205648_859148_18BAA38E)
References: <48c964bf.1b018e0a.75a0.0ecf@mx.google.com>
	 <1221158234.6986.50.camel@johannes.berg>
	 <aa050c750809111156s41d4cfcbnc79ed65687f97348@mail.gmail.com>
	 (sfid-20080911_205648_859148_18BAA38E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EwlHs0UmuMtnyeGa2EEa"
Date: Thu, 11 Sep 2008 21:12:50 +0200
Message-Id: <1221160370.6986.59.camel@johannes.berg> (sfid-20080911_211330_369385_54E7A91B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EwlHs0UmuMtnyeGa2EEa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-09-11 at 11:56 -0700, Anna Neal wrote:

> I was just trying to be consistent with the rest of the file. I am not
> currently using kernel-doc.

Oh ok, I hadn't actually checked the rest of the file.

> Maybe its worth it, in a subsequent patch, to convert the whole file
> to kernel-doc notation?

Possibly, if accompanied by hooking it into the kernel-doc system int
Documentation/DocBook/ too.

> Any volunteers?

Not me right now :)

johannes

--=-EwlHs0UmuMtnyeGa2EEa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIyW2tAAoJEKVg1VMiehFYB8cP/ikevIo9yVo6pInAFwtK1t5y
KtNerf7SjcII8ODNl6iv9Eu2nG6HFy8O1lSPK2pkVZhJAZs+mo9wH65KZLBBo6wK
7A4t9/0ghPreMWyQQ8ARz+s38WfHYEMyyhELmzK/8K4Ov7rYYnj6/tB4JDGMcO0H
v/3i+3X+B+sryoWPmypWY+fO5vUCSTHf8pWJXbBSjvRC62tLjvKKY9zUL60KX6sU
IN42a60vObL1PWl/p47FAsONRWiVR0NnXHRH3MaOAl2C1NSCjbVxIsOdM5ZWMF34
5WV7CWvmNAS/Tmg5rvmxX77VqmVpcODfKCG+c5K1jg07PkQw0tzX6hWY0MRHug3e
GI3A3DcYS2+g2pmxyVPo/saUVvMLUmoE0XV9v9D27VED3OaqrheUfIxCsE877j43
jmWUfs5mvk/Rty/0riiZa+TUxtC+J6E0CI1Y+dyhEKJpsCtMDsKP/I+vgTxLvYy0
mdA+AbL+UEBnKYfhUknHlWIbr9QKsL4FCkyae/llI9vwExiQ4zuS4r9QLDadH0j4
KgDKrywhpDkXSwUDkLihfKXjoPZ1IZ+ssfnHTG57xWrVMRmeP71q4XGCXqBvotMF
J+cQ8v2/fcfMHXQEuho9XCSPeByqoVAsu0QVrDsmqyOw1YtqztV7VN5JB+I7YMX/
HGVUCIXq5lgEjIU6XJqn
=eDcE
-----END PGP SIGNATURE-----

--=-EwlHs0UmuMtnyeGa2EEa--

