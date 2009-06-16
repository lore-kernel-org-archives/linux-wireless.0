Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53046 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbZFPTiS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 15:38:18 -0400
Subject: Re: [PATCH] cfg80211: allow adding/deleting stations on mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org
In-Reply-To: <445f43ac0906161232x743d7ab9u2f36a5893240b789@mail.gmail.com>
References: <1245177064-31861-1-git-send-email-andrey@cozybit.com>
	 <1245177307.21287.34.camel@johannes.local>
	 <45e8e6c40906161142m759e6ecdgc6765333a4cced01@mail.gmail.com>
	 <1245177946.21287.42.camel@johannes.local>
	 <45e8e6c40906161155i1e5dc5bag114dea7a8c6caa66@mail.gmail.com>
	 <1245178613.21287.45.camel@johannes.local>
	 <445f43ac0906161232x743d7ab9u2f36a5893240b789@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5vB3lVtSuIs6rxVrrBSL"
Date: Tue, 16 Jun 2009 21:37:49 +0200
Message-Id: <1245181069.21287.53.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-5vB3lVtSuIs6rxVrrBSL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-16 at 12:32 -0700, Javier Cardona wrote:

> There are some mesh parameters that you would probably want to be
> uniform across the mesh network (timeouts, number of retries, etc).
> But the only mesh parameter that would result in a different mesh
> network is the mesh_id, and that's only settable when the mesh
> interface is created.
>=20
> Do you have a specific configuration parameter in mind?

No, I don't have any in mind. I wasn't aware that only the mesh_id
defines the mesh, I was under the impression that more needs to match,
as codified in mesh_matches_local().

johannes

--=-5vB3lVtSuIs6rxVrrBSL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKN/SHAAoJEODzc/N7+Qma89gQAMid/Ljigw0VWRaCMKbH6ji/
fYPygf/frtiVaYnXhpVzfBE88dO6pLsSQ/fCpnp7NPUmnMr6YfyPIqOZIG7d9Mks
bbAOfZJhtR6xmM3DiVHrtaNMHPnntHJ3RX8WY0SmIgFUNNJ2CEe5/flGemXPyKef
/smpMm+wLIYHbZMTvo7F9LX3Bzzkswmvm7uXVMX0wQOzmra5CVO0gKevn2oEx6zJ
IwdEBv/7IXVFD+cgwl6Q+27+A9hGJXilWjJz1TqLFfhaX5C8OlHrFuL/gd31vz6e
qWHPla8FxRXD/NkcvGJTHHhvtW/EBGJIJV5lD+mbrcIqCs7vOHDM0o+/R4HMokvI
Zlpcj2fOCuTEGcOcZ1IH64nAJuxPveaBMq8KXVgSFAIWw57BBzDNj5lnmFuKhvPu
AAF9yGCpl9VFSlyhcAI1anFviR4LG9l7Hbd7vTPhMs0ZfR6BqPOw3a6eGNzMtloZ
CTZHzpu/6AKKPBA5v1Lk1OyXzKne78KTJKzfIXeUtWRv/M26Rsv3CcUfbk/OxEcF
K4BkvDJ1G974NApJMvs5mjwerD4BC2kM+YQYQvN/NnoxCwcN4QNLuGC2ZAT/if2y
qUjf5CYXEbIwcqLmdq8DRuemy7H6wacXnP8iMkbHBQmzWiSN9K4x9cH7rcOYa3r2
k0OlXGEzdff5T1v7OLRy
=yzl2
-----END PGP SIGNATURE-----

--=-5vB3lVtSuIs6rxVrrBSL--

