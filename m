Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51887 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760129AbXGFMny (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 08:43:54 -0400
Subject: Re: Multiple interfaces in mac80211
From: Johannes Berg <johannes@sipsolutions.net>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <9e4733910707060533y3bd3b4a5v5f0441f0d6e76377@mail.gmail.com>
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com>
	 <1ba2fa240707050530q2d165232raa73455397546c62@mail.gmail.com>
	 <9e4733910707050632m794944b5nb9ac9393b05dfa75@mail.gmail.com>
	 <200707052154.24976.flamingice@sourmilk.net>
	 <9e4733910707060533y3bd3b4a5v5f0441f0d6e76377@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+BJ+ZvmAcpDenGywlW8c"
Date: Fri, 06 Jul 2007 14:44:21 +0200
Message-Id: <1183725861.3779.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+BJ+ZvmAcpDenGywlW8c
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-07-06 at 08:33 -0400, Jon Smirl wrote:

> Packets to other mac addresses are arriving at the receiver and I can
> trace them up to ieee80211_rx_monitor and onto netif_rx. Something in
> the higher level networking code is filtering out these promiscuous
> packets; but I don't know what was is doing it. It's not iptables
> which it isn't loaded.

That's odd because it works for everybody else. Have you tried with
*only* a monitor interface?

johannes

--=-+BJ+ZvmAcpDenGywlW8c
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjjkl/ETPhpq3jKURAi8cAKChk3LXOew+GCc/VAQMGfJKFBs9CQCfQ5J+
j0gaaljYSMVfBxsU2P+FVHw=
=xrN3
-----END PGP SIGNATURE-----

--=-+BJ+ZvmAcpDenGywlW8c--

