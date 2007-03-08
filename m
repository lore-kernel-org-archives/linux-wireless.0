Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:38984 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030744AbXCHWgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 17:36:14 -0500
Subject: Re: wireless extensions vs. 64-bit architectures
From: Johannes Berg <johannes@sipsolutions.net>
To: jt@hpl.hp.com
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	Jouni Malinen <jkm@devicescape.com>,
	Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	netdev <netdev@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <20070308223058.GA24960@bougret.hpl.hp.com>
References: <20070306171316.GA19669@bougret.hpl.hp.com>
	 <200703061943.07350.mb@bu3sch.de>
	 <20070307020310.GA20466@bougret.hpl.hp.com>
	 <1173364747.14001.7.camel@johannes.berg>
	 <20070308184954.GA24485@bougret.hpl.hp.com>
	 <1173382042.3248.63.camel@johannes.berg>
	 <20070308193412.GG23040@devicescape.com>
	 <1173382802.3248.68.camel@johannes.berg>
	 <20070308221128.GA24884@bougret.hpl.hp.com>
	 <20070308141756.efdfd6da.randy.dunlap@oracle.com>
	 <20070308223058.GA24960@bougret.hpl.hp.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-A0ugIXUNFx7kSjNbWe1s"
Date: Thu, 08 Mar 2007 23:36:12 +0100
Message-Id: <1173393373.3831.23.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-A0ugIXUNFx7kSjNbWe1s
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-08 at 14:30 -0800, Jean Tourrilhes wrote:

> 	Then, I assume that the powerpc64 must be using a magic
> version of iwconfig to configure wireless interfaces, because I only
> ever got one other bug report on the issue. They should have sent the
> patch to Johannes, because now I know about their unauthorised version
> of iwconfig.

There probably aren't many powerpc64 users that actually use wireless on
it since, well, most such machines are pretty stationary and
well-equipped with gigabit ethernet :)

May I ask who this was though? Some distro?

johannes

--=-A0ugIXUNFx7kSjNbWe1s
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF8I/c/ETPhpq3jKURAhHRAJ9Ye0K+KXMJmOEr685gXO6gIP892wCeMbrk
9SIHHbbFdMPTffn+6q6Cs5A=
=cd6K
-----END PGP SIGNATURE-----

--=-A0ugIXUNFx7kSjNbWe1s--

