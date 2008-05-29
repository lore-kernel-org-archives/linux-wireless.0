Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49024 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYE2KNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 06:13:38 -0400
Subject: Re: [PATCH 38/43] mac80211: allow disable FAT in specific
	configurations
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240805290258of0559a0t183128d3f9889eae@mail.gmail.com> (sfid-20080529_115825_625584_C4B4B16E)
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-32-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-33-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-34-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-35-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-36-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-37-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-38-git-send-email-yi.zhu@intel.com>
	 <1212050128-17132-39-git-send-email-yi.zhu@intel.com>
	 <1212053870.16917.39.camel@johannes.berg>
	 <1ba2fa240805290258of0559a0t183128d3f9889eae@mail.gmail.com>
	 (sfid-20080529_115825_625584_C4B4B16E)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jY+fFG2G8tbECvhxxJBr"
Date: Thu, 29 May 2008 12:12:30 +0200
Message-Id: <1212055950.16917.53.camel@johannes.berg> (sfid-20080529_121341_270181_5EDDFAA9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-jY+fFG2G8tbECvhxxJBr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > It seems to me that (12, -1) would be pretty much the same as (8, +1) a=
s
> > far as regulatory is concerned.
>=20
> Yes, just beacons will flows on 12 and not on 8 so from protocol point
> this is important

Yes, but how is it important to the regulatory regulations?

> (But this is not what is written in the comment we comparing (8,-1) to
> (8,+1) - Both are FAT channels - Beacons flow on 8 channel)
>=20
> I'm just thinking about how we should
> > express this in the regulatory database where we're not really concerne=
d
> > with channels but rather allowed bands.
> >
> Not sure what do you mean, You always need to keep in mind channel, band =
tuple.

Well our database just says: "ok, you're allowed to use 2400-2483.5 MHz,
at a maximum bandwidth of 40 MHz, if it fits"

johannes

--=-jY+fFG2G8tbECvhxxJBr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASD6BjaVg1VMiehFYAQLI7g/+LQtTLDIXrmZG63jh4jGmqHTemvNRKkcg
PY3K/hPJE9BiNseWfINFdNf5GZSo3+1D1aCUlZixYYdvAamwB8aostwdmUZJ2wK/
ofn13MGtIQyL6/shhl9S1ooxuiTnLoPaMIn5tknYD7y246ptcdATcArP8CzFhxcS
7heAvhCiCy4RInhTEwMAVcxW4SGXYsz1giLgXlIAGH++mFFaOpC05pWIPfFsp1xq
eILRc9KuXJQKnn9nHEFdlx4ZQKv2awsXyy761ROicJ4B0hVTve49JdteJRZoMxPx
q5jnIAOGhqdkojRmdCM7UGUr7VILUFDE7q9Rg4vuDR3fL9YZ2Ib0ssv3BJVzv3Rq
peZOENcynG68F8QjQ3SFZwPpz2UqkHZ6fIjqwOceyhcmn3rRfVMBlAPm4RKgLSGI
eJmYN67CF3jywUdSIGVtfBxsdpwFNY+Iy1qovoToo6mYA7C4TQ/KQxXl1fTNbmbP
ugQgLY9A5zB6p2H63aZZJNFQ5QMH+VYaA+TfyIyl+LwTcP+G1Md6E7fif9VfL5sZ
3Ki35y1DPGVZUa+a9LUXTCDINWxoRWOQvGajnUHpippLJj/uNbTbx02dX6/h4W88
X5pLlr908HxpbnZGpREr0Iol3bWiURPkwYv0WWciQ9OqsMvSgeCYGt2wFUsD+gJM
/xbU8maC3e4=
=Vv1F
-----END PGP SIGNATURE-----

--=-jY+fFG2G8tbECvhxxJBr--

