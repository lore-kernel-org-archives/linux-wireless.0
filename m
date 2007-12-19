Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40698 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756836AbXLSPsv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 10:48:51 -0500
Subject: RE: [PATCH 6/8] mac80211: A-MPDU Rx adding BAR handling capability
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1879838866982C46A9CB3D56BA49ADEB04313AE5@hasmsx411.ger.corp.intel.com>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com>
	 <11979070783125-git-send-email-ron.rindjunsky@intel.com>
	 <1197915884.4885.93.camel@johannes.berg>
	 <c85cb4470712180545u46dc0a21obdc6d7b6c095b797@mail.gmail.com>
	 (sfid-20071218_134627_418190_29EDCA18) <1197986001.4885.144.camel@johannes.berg>
	 <1879838866982C46A9CB3D56BA49ADEB04313AE5@hasmsx411.ger.corp.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-p2Y3Y4q+mUqQrmkcsKIm"
Date: Wed, 19 Dec 2007 16:45:38 +0100
Message-Id: <1198079138.4747.8.camel@johannes.berg> (sfid-20071219_154854_903633_EDFF5FF9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-p2Y3Y4q+mUqQrmkcsKIm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > I guess we should just return NULL in all other cases here. But please
> > enumerate the cases explicitly so that people who add new interface
> > types get warnings, i.e. don't use a default: statement in a switch
> > (interface type)
>=20
> you sure you want these ugly warnings? I do prefer to put default here.

No, I want to put all currently possible values there instead of the
default so that when the mesh folks add their type they get the warning
there.

johannes

--=-p2Y3Y4q+mUqQrmkcsKIm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR2k8oaVg1VMiehFYAQI/nw//WLsvOi9XSRHcMu/X/6TtsPjiMvUpw2gv
2lP/BTnwZ9+eKwSBrkSeUj8r8rRnLEtMNeGcWEI43vl/zbuYFO3+Y3DJc7OPafvb
vdRuqCl+dWnxEKtfnKAsSgLZy3L0V3Ko7Tih1/o99rp7xDbUs+zPFm+fwVP6fmVL
47sa0OhJlRIlTLoeFjeq9nv9s2jne1kcw5ITIX9B/MTEakJXP7wt9Tz5icyhotLy
oleLXRgFWOwi6dOrHqlJnHDfsLjfEladPJ531e6YtoOHuXXvlD19B2HciGnfxqWI
x0JlkXOGeYjQGhruc6wNtRlmdczKRNC7TiL3TNZnvUBNVzQqj85u116hDuSY/2pt
nKxvn4ccUrrxmiGwXg0YrMnfS7DO1Z7MWICjXCPsez1GdhGLUzDaaImr+KuBJeDb
nfEosZeWqLIAaMJXFpSvabD57TQYwiGw9y7PlOYeFYxgCvd2ErNcPDR6KFFAPT5B
3/la50ytoFihyQ+r3gpaM3Hs4rRFO8Z3xLJV5iQz+0SxAsVdp7taJt30tb+9Nzq6
CWEzNVRY74U9RGFS+lFEdbr/MY2wU3gt9NWXkG/v5npHXVYGMEKl+XC1fXODGdb/
15rTS9X7jrJY6W+p6I3sMabKafmLIsQ+nhPwSoNlaIWP3BWNKD2CFuRhuaWORIXP
Infu4Yl0V6c=
=K6VT
-----END PGP SIGNATURE-----

--=-p2Y3Y4q+mUqQrmkcsKIm--

