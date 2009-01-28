Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZA1Kyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 05:54:31 -0500
Subject: Re: [PATCH 7/7] iwlwifi: unify iwlagn and 3945 power save
	management
From: Johannes Berg <johannes@sipsolutions.net>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Winkler, Tomas" <tomas.winkler@intel.com>
In-Reply-To: <1233095278-5850-8-git-send-email-reinette.chatre@intel.com> (sfid-20090127_232519_492386_712CFEB2)
References: <> <1233095278-5850-1-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-2-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-3-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-4-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-5-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-6-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-7-git-send-email-reinette.chatre@intel.com>
	 <1233095278-5850-8-git-send-email-reinette.chatre@intel.com>
	 (sfid-20090127_232519_492386_712CFEB2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QGR8f0lDebd7kctl+O3M"
Date: Wed, 28 Jan 2009 11:16:31 +0100
Message-Id: <1233137791.3936.0.camel@johannes.local> (sfid-20090128_115435_576876_F593BED1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-QGR8f0lDebd7kctl+O3M
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 14:27 -0800, Reinette Chatre wrote:
> From: Winkler, Tomas <tomas.winkler@intel.com>
>=20
> This patch unifies 3945 and iwlagn power save management
> This patch also better separates system state from user setting.
> System state shall be removed later as this shall be shifted to user spac=
e

I've got a patch to remove much of the cruft (system state and
associated variables etc) somewhere, can dig that up if you want.

johannes

--=-QGR8f0lDebd7kctl+O3M
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJgDB8AAoJEKVg1VMiehFYlL4P/if95WNPK9Yhw9kt6XPK7vkP
luxddbAtAJrvcoCs6pwu8VP6fCVFGSgnlCrE6mvzJKfPNUNnWpDPxLW3pH36m77j
HZOj9nmiT202bp1SVeOeAceBAtLVYaJLvgYsav2/3z8T35augualR+v51cVEUu1Z
1ghxKDBYQd4pO3j/tjPSsAhRjEjvCLmuaY/mgN6T75jfGoCCubokJCuL8+vqrBCO
EsM5ZLN48miX+Hs+S/F6YxdcaMLSSTElqHB4YjR1k++6Tk8gtnDSNuiqv4GlIMH+
XSdLNyyH8gTjtWE0ogDHaCgzbAD17wpKShaqGk8l2bRz2YR9PUTRAlg/+1h0S9zR
/QXhGJes1GtgXozWp3PB1nQzDCGe2BAqj6SM4gM8bb11X2PUFijW+49/jXST9GIB
gByrADSH1HIcae2Aef5cDMhxFO5u+0ovcLByeN29T0vt/9RqV41bgpX2UKWdGW96
5tBtrUG/ahxrTy9YMvlqVx815JsZodZHPJ8oJnbN1lwJayHFtCJHJrS2w020P9TM
3+VSjkoXr4qMps13y7LEIS7MYV78y000WQGL6vdx8EAfm9p3SyfxhfBoK/KoOMVJ
x/rSOzuMqnn+TsYjlebQdIo0VxK7eqYb/mUevmaNFmPfJkUIQA0Kgiy+ZFxWq3Dv
+YpptknXMT+w31LUjMUX
=mAy5
-----END PGP SIGNATURE-----

--=-QGR8f0lDebd7kctl+O3M--

