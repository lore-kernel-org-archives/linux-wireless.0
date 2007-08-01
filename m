Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:32867 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762158AbXHAM14 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2007 08:27:56 -0400
Subject: Re: Rate control over multiple devices
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Benc <jbenc@suse.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org,
	James Ketrenos <jketreno@linux.intel.com>
In-Reply-To: <20070801142318.7234c63b@griffin.suse.cz>
References: <46AFB779.4040003@warmcat.com>
	 <20070801004543.GD4719@tuxdriver.com>
	 <1185960764.14279.2.camel@johannes.berg>
	 <20070801134624.481eb856@griffin.suse.cz>
	 <1185969255.21901.11.camel@johannes.berg>
	 <20070801142318.7234c63b@griffin.suse.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-onvpu9pZ6M3nMbrSQicF"
Date: Wed, 01 Aug 2007 14:29:14 +0200
Message-Id: <1185971354.21901.21.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-onvpu9pZ6M3nMbrSQicF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-01 at 14:23 +0200, Jiri Benc wrote:

> Yes. But I'd like to see a solution to the problem reported by Andy in
> the patch. One of the possible solutions could be adding a "this is a
> special rate control alg which shouldn't be selected automatically"
> flag to rate control algs and not selecting such algorithms in
> ieee80211_try_rate_control_ops_get when 'name' is NULL. Should be easy
> to implement.

Maybe go all the way then and somehow tie it to specific information it
requires from the hardware that most hardware doesn't give it?

johannes

--=-onvpu9pZ6M3nMbrSQicF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsHya/ETPhpq3jKURAj+5AKCvP5HKIxOwdga+UhbTL7YGZii17gCgrjgX
S9xYEiI5eh6AIOXF2Qw7avQ=
=nFkO
-----END PGP SIGNATURE-----

--=-onvpu9pZ6M3nMbrSQicF--

