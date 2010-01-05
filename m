Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:57157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab0AEJV0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 04:21:26 -0500
Subject: Re: [PATCH 4/9] mac80211: create Probe Request template
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100103210749.29287.96141.stgit@tikku>
References: <20100103210552.29287.20384.stgit@tikku>
	 <20100103210749.29287.96141.stgit@tikku>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dYV4e86qs6pbbMWH28Fg"
Date: Tue, 05 Jan 2010 10:21:05 +0100
Message-ID: <1262683265.20098.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-dYV4e86qs6pbbMWH28Fg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-01-03 at 23:07 +0200, Kalle Valo wrote:

> + * @ie: buffer containing all IEs expect SSID for the template

typo -> except


> + * @ie_len: length of the IE buffer
> + *
> + * Creates a Probe Request template which can, for example, uploaded
> to

be uploaded


However, there already is ieee80211_send_probe_req and
ieee80211_build_preq_ies -- shouldn't this use some of the new code?

johannes

--=-dYV4e86qs6pbbMWH28Fg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLQwR9AAoJEODzc/N7+QmaYZIQAMqlt1Sbmb7BMZqoDeMt/Xz3
wuUrBUoq+qaTN87HTrhQ6OMbxCtJ+4VAUIFTCZgEcSrnSy+5QOpESSg9obKUYoE9
HueGPQ8Ig9V4shVI0lxoD/LvhMf4mVFN53fVwvmytfv3/t65HZRsAlUzIA9/yAdF
u66VpIV30omPAgkJbfwsCPFkgSVBpeWG7AlkruvVfqOr35MTZBQT1Tcf1EYwtQ7L
T6JFIBp9JfLX5J8uaTpMZdBH/rwuYXrePGgxAe/Etj3Aju2nR5uAVEh8yE92Gcoc
VmjFBuC3puEtZwwIM+xfP5BqDYZwnqAYr14DyXVP2kbJ5IFcslxb0/VrLTA4q34j
77eL5GHn9R2vpEnKaJG6j3Gkq3N6QWGKubJgWUD0Vc7wCTXvVMZ4QkORM5gM4LHY
A52EiWhk4NBUyGVJaHnBeFLNwjaskjyMfgJVcJj+pgAcX00lM7neR6oypAoq5iiR
Wf0mYifyweDexI/1gNEuE+ih+LzyCtADl2+IgggPsBqW9jS8pSw52+kKgrGk3v9o
HtSmYkIUXCY4c3ZmD3DKmp48+AC3KoG1w+VSl7FUBg4GifXDK6Lm+cUjOhR/uWtj
HDo0HhZzQhJ4VkHkmD9x8d2qSPu+i0uNj1J7+hwg1jwPff/w8KPPka2WOIlIeice
fBFusZXW2Ill1csq0599
=y/Iw
-----END PGP SIGNATURE-----

--=-dYV4e86qs6pbbMWH28Fg--

