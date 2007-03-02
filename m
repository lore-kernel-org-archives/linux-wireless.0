Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:53691 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945905AbXCBMiW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 07:38:22 -0500
Subject: Re: renaming in debugfs?
From: Johannes Berg <johannes@sipsolutions.net>
To: Greg KH <greg@kroah.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20070215224057.GA20464@kroah.com>
References: <1171540374.20204.2.camel@johannes.berg>
	 <20070215224057.GA20464@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-eyksJ1+WPmXEMqwdbgH+"
Date: Fri, 02 Mar 2007 13:37:59 +0100
Message-Id: <1172839079.3482.34.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-eyksJ1+WPmXEMqwdbgH+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-02-15 at 14:40 -0800, Greg KH wrote:

> For debugfs, there is no rename function yet, but it would be pretty
> trivial to add one if you wish.

I tried to, but failed.
http://johannes.sipsolutions.net/patches/debugfs-rename.patch

does absolutely nothing at all, not even return an error! What am I
doing wrong? :)

johannes

--=-eyksJ1+WPmXEMqwdbgH+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF6Bqm/ETPhpq3jKURAjN8AKCGbIM2oI11tFEtbVLaISw1X8jzKQCfUIrK
s1djbVQ3Z5/U4PW/b4KXHlU=
=e4yY
-----END PGP SIGNATURE-----

--=-eyksJ1+WPmXEMqwdbgH+--

