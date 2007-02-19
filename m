Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:33094 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279AbXBSOTF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 09:19:05 -0500
Subject: Re: [PATCH] d80211: fix incorrect hw.priv setting in  ieee80211_alloc_hw()
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1171892584.8550.13.camel@dv>
References: <20070217074208.348.69546.stgit@dv.roinet.com>
	 <1171707397.3487.5.camel@johannes.berg>  <1171835685.2201.4.camel@dv>
	 <1171866799.3471.1.camel@johannes.berg>  <1171892584.8550.13.camel@dv>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OBL0cOp1m+QHMTOAOJVn"
Date: Mon, 19 Feb 2007 15:18:56 +0100
Message-Id: <1171894736.3471.23.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-OBL0cOp1m+QHMTOAOJVn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-02-19 at 08:43 -0500, Pavel Roskin wrote:

> Perhaps you misunderstood my idea.  There is an field called priv in
> struct ieee80211_hw.  That field will be written to, no matter how good
> the compiler is at optimization.  And most drivers will access that
> field by reading from memory.

My mistake. I was thinking of struct wiphy.priv and not
ieee80211_hw.priv.

johannes


--=-OBL0cOp1m+QHMTOAOJVn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF2bHQ/ETPhpq3jKURAthJAJwPYCl2fsSSJaGcorq1n0KIPjKcswCdFQhg
XlRnKRmj/Tq7KwMLy1wplFg=
=/9Se
-----END PGP SIGNATURE-----

--=-OBL0cOp1m+QHMTOAOJVn--

