Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:45377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbYCFRn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 12:43:58 -0500
Subject: Re: [RFC] mac80211: handling Qdisc issues
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com
In-Reply-To: <200803061830.32316.mb@bu3sch.de> (sfid-20080306_173105_199273_D1060F8D)
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com>
	 <200803061815.31398.mb@bu3sch.de>
	 <1204824008.25502.123.camel@johannes.berg>
	 <200803061830.32316.mb@bu3sch.de> (sfid-20080306_173105_199273_D1060F8D)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pan7+cUyI1hPeFPqpl+k"
Date: Thu, 06 Mar 2008 18:42:49 +0100
Message-Id: <1204825369.25502.125.camel@johannes.berg> (sfid-20080306_174424_009905_AC3D26D3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-pan7+cUyI1hPeFPqpl+k
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > That's my old patch, I think Ron doesn't know anything about b43 :) And
> > my patch was based before your QoS support patches.
>=20
> Ah ok. You can just add this #ifdef to the already existing
> dynamic condition on b43_modparam_qos in the new queue mapping function.

Yeah, but I wish we didn't actually need the #ifdef in all drivers.
Since CONFIG_NETDEVICES_MULTIQUEUE is dirt cheap I think we should just
make mac80211 depend on it, I think we'll end up requiring
CONFIG_NET_SCHED too.


johannes

--=-pan7+cUyI1hPeFPqpl+k
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR9AtGKVg1VMiehFYAQJK2A//RX9Bf7NAlvnMiuu8w+nRm9SUPdnZFToL
TiijqQaO5zHQo6h7tQCuvysPxewML12HGNl/5BeqdAucfEf4ZDuFXE3zKYX7yYst
O+8Rl/EKsch8fI77zUSzrI/VXdt1zBSYpC2K2wlJQ1EnoifHcZInwaHMD157HahV
jQGDuVxSIo0/aRv/q1H0rMcmaPd6Ef512xtZpNlCUB5VYPYXWmb8BSt0HJVhnZkt
lDEq1cxEEsFS7egh6+eoaom+LpnBMFjd/TGbAENff+TINzxxIC3vXXvOWcJnT07B
Y9Zx4ZPCBXSqWBgkd1ckFewFsWk4pJr0s0IbGvfRndPFRPh/IitDz7JqokH2NASI
A+NxY+RwXYQfugLabux6577B4ckg1qDLB/eVAMs5o+SDe6Jl+8DjA2AsGNKZqvE9
p0vEQSJWWMiNwWf0g/n1DT+BDaa/lYRrswANhikvGcQGH4D2WFr18OSizpGBFvw+
Fn1lf5menkio3tHhv+f9/jzaIk7nq3xOu9thol2czpzEKD0akMR0J98HIUhnE9iv
3F67xoUlC5ar8zqsmlS+omEZBkV8E8ZcIIP0UhBPQQ9W5w4FOc2/A/O4KwS7nmGm
HNJqwXrsmKuCycM2qf2LCR6rKbNW7m2SveSDALfSLns2OpmYXWWEpJFnOBXo2/6d
C8Uj4GFMCRQ=
=R/Ll
-----END PGP SIGNATURE-----

--=-pan7+cUyI1hPeFPqpl+k--

