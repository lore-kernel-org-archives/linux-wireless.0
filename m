Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43574 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbYJ1Sub (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 14:50:31 -0400
Subject: Re: [PATCH] wireless: fix a few sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1225219702.11483.0.camel@brick> (sfid-20081028_194828_204041_E0B216C6)
References: <1225208981.3598.10.camel@johannes.berg>
	 <1225219702.11483.0.camel@brick> (sfid-20081028_194828_204041_E0B216C6)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qGrzoNFNrNpfR0iStSN7"
Date: Tue, 28 Oct 2008 19:50:25 +0100
Message-Id: <1225219825.3598.43.camel@johannes.berg> (sfid-20081028_195050_460241_FFAA556A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-qGrzoNFNrNpfR0iStSN7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-28 at 11:48 -0700, Harvey Harrison wrote:
> On Tue, 2008-10-28 at 16:49 +0100, Johannes Berg wrote:
> > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > ---
>=20
> It's helpful to put the warnings that are being fixed in the commit
> message.

Indeed, but I fixed them over time so I was too lazy to reproduce
them :) In any case, it should be easy to deduce them by looking at the
patch.

johannes

--=-qGrzoNFNrNpfR0iStSN7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJB17uAAoJEKVg1VMiehFY0kEP/imJZMLLMa5fHfKR8vu3uYny
3/M/dt2j+6eunfpAo4SrekAkFGA0Wmdlh/RsNINcQ8kG+oxhChPXj66bG43kopcO
uymidMna+MKwatmeQL/uu5gvL9uPeg8CuuzOYhOtCuJVWnM3ia/M7t1pCjbCZUph
x7ON88LGQcORH26vxGrMHcI3JD7qOx/hZJqL/VXPpwff1hlRQg8LKGw/elHXm4Wq
58iFh0RFz7bZNnsRwnRRK6ChLxvIGUpuK6Q+rZcbrcB4s3MhdfWbP4kvey6kvtnI
8cSKgOMAmrC3gvkBwyZoA9X2a2H1H9eh+DKz1MpJYv4YUY5Jdbw8p5WRhwTQDj/P
YdFMrnNlSsAqGDNMswe/7AgL89LPPEDE0GUfVJToIZTsUlShXth1oy/IWIMsvmDT
N3T36xXsjxllGPWyTn8T+ECXD9NvmtuhsEK3L5ytalIITsP2jJbxR1REnhkCEKxc
OUV205hdhY+3Tmc8S4RcsZgRL70OlST4mT1OsMe8Y5QfySTQSfgwnRlxT8j1xsVY
AGsMpLeJvl1ZmIdCSuvgMxNS+1fnwy3rJc6xc1djsIzQMwwQCHxNTFAIiXqlGDZ2
qYt9W9onNIEzmcsWEKcLxIiPvs+hD0jpyUjhB0W1lBWb4hEJ3f32pB9hyAK7VVIQ
qgDs9Z9LQc/riANMVuJ+
=Yuc/
-----END PGP SIGNATURE-----

--=-qGrzoNFNrNpfR0iStSN7--

