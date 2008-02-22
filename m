Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756813AbYBVQZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 11:25:17 -0500
Subject: Re: [PATCH 05/13 v2] o11s: mesh.c, support functions for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Carlos Cobo <luisca@cozybit.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47be7736.09d7720a.37a2.6115@mx.google.com> (sfid-20080222_071818_973520_9B55DA17)
References: <47be7736.09d7720a.37a2.6115@mx.google.com>
	 (sfid-20080222_071818_973520_9B55DA17)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zkZldOHQ1K4WGuF5kLXX"
Date: Fri, 22 Feb 2008 17:25:11 +0100
Message-Id: <1203697511.7082.73.camel@johannes.berg> (sfid-20080222_162529_823698_06B7F27D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-zkZldOHQ1K4WGuF5kLXX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +	if (sta->mesh_id_len =3D=3D ie->mesh_id_len &&
> +		memcmp(sta->mesh_id, ie->mesh_id, ie->mesh_id_len) =3D=3D 0 &&
> +		memcmp(sta->mesh_pp_id, ie->mesh_config + PP_OFFSET, 4) =3D=3D 0 &&
> +		memcmp(sta->mesh_pm_id, ie->mesh_config + PM_OFFSET, 4) =3D=3D 0 &&
> +		memcmp(sta->mesh_cc_id, ie->mesh_config + CC_OFFSET, 4) =3D=3D 0)
> +	/*
> +	 * As support for each feature is added, check for matching
> +	 * - On mesh config capabilities
> +	 *   - Power Save Support En
> +	 *   - Sync support enabled
> +	 *   - Sync support active
> +	 *   - Sync support required from peer
> +	 *   - MDA enabled
> +	 * - Power management control on fc
> +	 */
> +		return true;

Can the comment be before the if please?

johannes

--=-zkZldOHQ1K4WGuF5kLXX
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR773ZqVg1VMiehFYAQK4Dw/7BIgjGUu0TUxxx+DlbdT8VbCoMDYla3zr
kPCBZE5IK/w5QUEfZWHvAx2VE5vwU6aAKBsTCVmJh67yks/IexYQXidzxvRdEzQY
BSQ4dJ4UszsPaXQPbMVIomfXaz7jX9VSXdV26M2UX/8XUvk8Rvz+evzx4s1LSvFv
1JxuntNFI6/blGoZ2XJB5az1L50ez8dHLZ6MVCSBijbneQccb3bHA6ww3rCHfA8b
aX5UOC59PxjC5Uzt04/P8F+yrTgaRciviMENp2fizMTX/I/NeAFzCsRCD9/jH+QQ
AVdqmHbtz6bG7rtnL/NoywkMkaKpJU0aiFFhjlk8/sjXWGjdXqtYZwP7FyD++rPX
M0OWObb45sdO0b9D2RjMVQ0WfABzDC+QRoeSQ2FjwZbzj0rhKUIJMR2fXqlyhnBS
2AiswdVqo+dYUPvJa+AvtxaPcqGdVszoNaJggcwLefR6CwhXttUpi6G2M60ccn/7
PFuRq7hwE3ypMl0PYaqK6LnsnIpaiSkJ8RPB4Qd5l3Z5rjaBjohstkgIjsBMIw5t
4e/4jHy+q47GLfvHcuD0THquwx03nui12XfEVCgLJC++TWrTux8a0FMU/uckul/C
CdtsHi/mC74s7IjgAPSIWe+reWhm/imgu3b76Ut5+1oesXxqDH+dk+58ri/jsJoO
e9EIz9cKW98=
=CR8U
-----END PGP SIGNATURE-----

--=-zkZldOHQ1K4WGuF5kLXX--

