Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:40125 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761451AbXIUWFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2007 18:05:22 -0400
Subject: Re: [stable] [PATCH] cfg80211: fix initialisation if built-in
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	stable@kernel.org, Rob Hussey <robjhussey@gmail.com>
In-Reply-To: <20070921220253.GA32585@kroah.com>
References: <1189424685.4506.63.camel@johannes.berg>
	 <20070921220253.GA32585@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tBE6grxHYA1Oiiwht9ua"
Date: Sat, 22 Sep 2007 00:06:39 +0200
Message-Id: <1190412399.18521.181.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-tBE6grxHYA1Oiiwht9ua
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-09-21 at 15:02 -0700, Greg KH wrote:

> When this goes into Linus's tree, please resend it to the
> stable@kernel.org address so we can add it to our queue.

It's on the way, sitting in net-2.6.24 right now but I don't know
whether it's scheduled for .23. I'm no longer sure if it really matters
for -stable since we have no drivers there so typically drivers build as
out-of-tree modules and the issue doesn't matter.

johannes

--=-tBE6grxHYA1Oiiwht9ua
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG9EBv/ETPhpq3jKURAjyvAJ9lX7GVENiZpEFg4y4qfWKcvmV39ACgr8BJ
0b4ZUlCBsKtV8LFg38lC3fY=
=AV/m
-----END PGP SIGNATURE-----

--=-tBE6grxHYA1Oiiwht9ua--

