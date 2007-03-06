Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965312AbXCFQje (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2007 11:39:34 -0500
Subject: Re: [FYI] compiling hostapd against latest wireless-dev
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1173195638.12545.3.camel@localhost.localdomain>
References: <1173095902.6131.63.camel@johannes.berg>
	 <1173195638.12545.3.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DUOlXHOvc6XTyP9CPk7L"
Date: Tue, 06 Mar 2007 17:39:01 +0100
Message-Id: <1173199141.14058.11.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-DUOlXHOvc6XTyP9CPk7L
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-06 at 10:40 -0500, Dan Williams wrote:

> Right; if there's something that the prism ioctls do that cfg80211
> doesn't, and that something is useful, then we probably need to extend
> cfg80211 to do that thing.  Then we rip out all the custom ioctl junk
> everywhere.

Yep. I got bcm43xx working in master mode now so I can start doing
exactly that.

johannes

--=-DUOlXHOvc6XTyP9CPk7L
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF7Zkl/ETPhpq3jKURAo5KAJ4iHPhSB2SMzIoT7PKK9RweZoWrfgCfXZrW
oJL1T1bQqMgiu4m4rrkLeDs=
=EsUC
-----END PGP SIGNATURE-----

--=-DUOlXHOvc6XTyP9CPk7L--

