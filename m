Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53451 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067AbZA0LTI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 06:19:08 -0500
Subject: Re: [PATCH 4/6] mac80211: More small changes for modularization
From: Johannes Berg <johannes@sipsolutions.net>
To: Florian Sesser <flomaillist@cosetrain.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <497EECED.1020106@cosetrain.com>
References: <497E1B90.4060803@cosetrain.com>
	 <abd4234c03d59a65d3eb9259821d705899a08612.1233001802.git.flomaillist@cosetrain.com>
	 <3202b18e8531aa78c29636c163de20875ae1a9cf.1233001802.git.flomaillist@cosetrain.com>
	 <e236615740b8ce8c9515c14aac3a2d9d93806a98.1233001802.git.flomaillist@cosetrain.com>
	 <79a59b62a4378b8b88cb3a33b1ec3cbd3808906e.1233001802.git.flomaillist@cosetrain.com>
	 (sfid-20090126_213927_757374_C1421A9C) <1233004598.4533.37.camel@johannes.local>
	 <497EECED.1020106@cosetrain.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aFS+UPlds/lIovJPDvxd"
Date: Tue, 27 Jan 2009 12:19:04 +0100
Message-Id: <1233055144.4012.33.camel@johannes.local> (sfid-20090127_121913_730293_71162687)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aFS+UPlds/lIovJPDvxd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

> Thanks for your comment. My intention was having a logical seperation to
> enable better discussion of my patch, which I think is pretty much of a
> monster and not yet ready for inclusion?

I've seen larger patches ;) But ok.

> What do you think about my selection of mesh_path_sel_ops and the
> storing of mesh PP/PM/CC id?
>=20
> If you deem it OK I would be happy to reformat the patch (into three or
> so seperatly compiling patches) and include KConfigs.

Well, you really need to run checkpatch and address (most of) its
complaints. Then you can repost and I'll take a look again.

johannes

--=-aFS+UPlds/lIovJPDvxd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJfu2lAAoJEKVg1VMiehFYwY4P/1uk1LjxRuns0Dd7vLtnor5y
MCLxZ28PVtTj787+UUM0lfcYJspqqWdXje+CGi1dgYsz1m3ngNNJ1kGdUiUOWJSw
UmpeI3HZjy9G8n7WXrMVZY2VDL1HPemXmXW1Ddj+Co1zv5Eisy4l2R3l+bJAd7T3
VLSSWEJyL45f26+pPpk3MNSETpZR+OSgkd4TYKM+R5WyZdvu2btSvXOPHFQtIS4G
8uax47igMFrWqcRYoWO97mxGMfGcqNFm7ogpu5rDGFtaWVvVNrYN9GKhCFwWxRsb
REfuxKN+nqwNr9SUf3cOY/sD2Aa+FkiolD8nshWtVp7rIhk8O0RpZdsa9VjqH1Ge
OCH7FzlQQM5wSouYZmJZtXvafZUcxvKLwxpzcaaj2AYAMpSsFSh8ah0AZDPDLgCq
ctuFxmSCQkPmQwOguq7viRwe8YBLWa+dT4zlJLIbrG2KmbAFF6tgEm2Td+RLczy0
dFGJlUzpzHx0R74ZCkYg4ui6v44NF1DgPyti90OnsfIEprDYFCN5mwUkkwI9FCNm
lhA0bY2dE8y3xOIa7ZPpsoCFVBnTk0OcObpURUyXGD+5uIwrQWuME6TysXoMZ/sp
h/NE90/fPdaQ2XIH1v7lnnJljGys7uN46ZxFFNCzApchLZrQKW4oUh7EWlicZIyE
IhZBWCIXG2jAE4LP641+
=qtp5
-----END PGP SIGNATURE-----

--=-aFS+UPlds/lIovJPDvxd--

