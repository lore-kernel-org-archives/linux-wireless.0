Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:52415 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932718AbXBWUf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 15:35:28 -0500
Subject: Re: [PATCH] create net/wireless/Kconfig and make nl80211 optional
From: Johannes Berg <johannes@sipsolutions.net>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <45DF4D4B.6010601@linux.intel.com>
References: <45DDF22D.9000003@linux.intel.com>
	 <1172229914.3870.13.camel@johannes.berg> <45DF176E.9090509@linux.intel.com>
	 <1172261472.3870.50.camel@johannes.berg> <45DF4D4B.6010601@linux.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ypO+32qID0yVW9aKqbl2"
Date: Fri, 23 Feb 2007 21:35:15 +0100
Message-Id: <1172262915.3870.76.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-ypO+32qID0yVW9aKqbl2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-23 at 12:23 -0800, James Ketrenos wrote:

> Ya, I guess that follows standard kernel guidelines more... I tend to=20
> find it a lot easier in resolving problems with short spanning ifdef's=20
> sprinkled in code vs. hidden functionality in header files that changes=20
> based on CONFIG options.  But alas, I think I am in the minority on that.

Yeah, I guess you can argue about that. I tend to not care about what
the functions do (unless I want to follow them anyway) so it's more
readable that way.

> I'll resend my prior 'make nl80211 optional' patch adding below to it.

Great, thanks. That has my
Acked-by: Johannes Berg <johannes@sipsolutions.net>
then.

johannes

--=-ypO+32qID0yVW9aKqbl2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF31AD/ETPhpq3jKURAjj+AJ94lGZV7hXVaWrtoHA7xnecHwP1EQCgqNEZ
JInrHLoWXg7HMjF28EU409A=
=+x6B
-----END PGP SIGNATURE-----

--=-ypO+32qID0yVW9aKqbl2--

