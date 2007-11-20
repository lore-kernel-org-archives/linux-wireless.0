Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719AbXKTMnD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2007 07:43:03 -0500
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: shaddy_baddah@hotmail.com, linux-wireless@vger.kernel.org,
	jt@hpl.hp.com, dsd@gentoo.org
In-Reply-To: <20071119.142046.188284555.davem@davemloft.net>
References: <4740DF47.4040206@hotmail.com>
	 <20071119.002755.77617097.davem@davemloft.net>
	 <1195484582.8642.18.camel@johannes.berg>
	 <20071119.142046.188284555.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aB5pF6HXxcoqLn+WcjsG"
Date: Tue, 20 Nov 2007 13:40:54 +0100
Message-Id: <1195562454.10920.6.camel@johannes.berg> (sfid-20071120_124310_726505_B39ADBC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-aB5pF6HXxcoqLn+WcjsG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable



> It has to be, %99 of sparc64 userland is 32-bit.

Thought so. Same on powerpc.

> > The kernel has never been fixed and never will be. New wireless
> > tools should "support" this, but imnsho you're *much* better off
> > compiling 64-bit wireless tools.
>=20
> This is an unreasonable requirement, all kernel ABIs should work in
> 32-bit compat tasks.  And when it's very difficult or impossible to
> make it work, there should be a new ABI to transition to that does
> work in compat mode and in particular would work now for the user.

Well, I complained too but it's unfixable without breaking one thing or
the other, consider netlink messages with iw_point in them that are
broadcast. Ugh.

johannes

--=-aB5pF6HXxcoqLn+WcjsG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR0LV1aVg1VMiehFYAQJcnQ//Qnv4gi7pJCqzqMppJVsqtRJNslMiIXub
ttH4yN+NLXXpTq4uuzh9rUt4P2DgN21yisR6wNpM21eToPzXI9JjlMrJ4+iojrm3
9xCGjrDjRnFWNRbKSCK2jYdumrMUz9fI2j058mqggoO3Dmckfq08zgnGuHlcWOer
ebsRoY8JQXDyZF/qyhREE8zhUlaYSN5Ce0SGLjuCvzGc2YFhn6qWZMNhHR2oWUJx
+WdUrNC4DPcLPfk2ld3MVprU11XTLGIvlA69DR5NJI5L/wgtCEy1ub13p1EsDMcg
mXRJ4in27264V7fo9kfztgmE+zlRdCvn5pb4C4KyJclQVeYI5/eTdLSoBfhyalbj
vkF2ZB4G7f7pzYUhh1wPBIYUy87D4IWad8mXD6KqEoyaVmpVR9572lfwRsQ+TGpf
PspiMfxM2WkimMnpLF96LMwKbp7xGa6wme0hMmrRfEjhPHCp7zDDMFP3WygnrCRj
GEWbc09Jgkab0kg6qH2l0m9A7DP3bb1MRDL1FQvgTDYAycphzN+c7Ri2P7uO4hO3
ppzS8UAjiH75Ih0lFyQRkCt6BeMMmnplJD0NZe2TV9CkkFyP2030mF2KE1Z76FTX
jrqoTOeqB1VVEzEiJKMBmQ9Pq3cIBr7BeRJsfJwIkpfWj5yoC/9bSN3L1M3YiTMN
Bozqm4xEgZM=
=PvNE
-----END PGP SIGNATURE-----

--=-aB5pF6HXxcoqLn+WcjsG--

