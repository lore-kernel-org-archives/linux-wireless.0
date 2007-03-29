Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59731 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbXC2Lth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:49:37 -0400
Subject: Re: [PATCH 4/4] mac80211: Monitor mode radiotap-based  packet injection
From: Johannes Berg <johannes@sipsolutions.net>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <460BA3FE.3000700@warmcat.com>
References: <20070320103955.600509703@warmcat.com>
	 <20070320104104.837354764@warmcat.com>
	 <1174501733.3944.28.camel@johannes.berg>  <460B9F8C.3040701@warmcat.com>
	 <1175167176.8807.53.camel@johannes.berg>  <460BA3FE.3000700@warmcat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-F/8AVLujKXZ42QRDiGUK"
Date: Thu, 29 Mar 2007 13:48:31 +0200
Message-Id: <1175168911.8807.65.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-F/8AVLujKXZ42QRDiGUK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-29 at 12:33 +0100, Andy Green wrote:

> I missed this conversation evidently, didn't find it just now either.=20

Sorry. It was on IRC.

> In case the plan is to block the thread doing the injection until the=20
> packet has gone out and is retired and can return an "acknowledged"=20
> status direct to the send()er, throughput is an issue.

I don't think that's the plan. But apparently the current interface
doesn't allow userspace to exactly map the sent packet to the tx status
it gets in the monitor interface (when the sent packet shows up there).
I'm a bit worried that it would need such an exact mapping especially
when others may be injecting frames at the same time, but I suppose that
can be solved when we get to it.

johannes

--=-F/8AVLujKXZ42QRDiGUK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGC6eP/ETPhpq3jKURAl+6AJwNs6AQsFB6XawYSbMxvvy9UaWxmACbBz6f
Nt3IWgSHlUvFd5ujg7kdajM=
=zQ2P
-----END PGP SIGNATURE-----

--=-F/8AVLujKXZ42QRDiGUK--

