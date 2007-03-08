Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60044 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133AbXCHT1f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 14:27:35 -0500
Subject: Re: wireless extensions vs. 64-bit architectures
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
	Dan Williams <dcbw@redhat.com>,
	Jouni Malinen <jkm@devicescape.com>
In-Reply-To: <20070308184954.GA24485@bougret.hpl.hp.com>
References: <1173144447.15891.93.camel@johannes.berg>
	 <20070306171316.GA19669@bougret.hpl.hp.com>
	 <200703061943.07350.mb@bu3sch.de>
	 <20070307020310.GA20466@bougret.hpl.hp.com>
	 <1173364747.14001.7.camel@johannes.berg>
	 <20070308184954.GA24485@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VjUWlSUMKghz3KaPjnFd"
Date: Thu, 08 Mar 2007 20:27:22 +0100
Message-Id: <1173382042.3248.63.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VjUWlSUMKghz3KaPjnFd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-08 at 10:49 -0800, Jean Tourrilhes wrote:
> 	A proper fix would involve forcing the alignement in the
> kernel. Unfortunately, that would break 64bit->64bit configs. I think
> I can build a workaround for this in iwlib.

Actually, other tools like network manager, wpa supplicant and possibly
more don't use iwlib afaik and are affected too, so the only real fix
seems to be possible in the kernel.

johannes

--=-VjUWlSUMKghz3KaPjnFd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF8GOa/ETPhpq3jKURAufVAJ9rn5Xs0kODVf31jtCJAU0e6N0b4ACfYDpv
ytNYd3/mBS0bVO61rLcZs4Y=
=PAHo
-----END PGP SIGNATURE-----

--=-VjUWlSUMKghz3KaPjnFd--

