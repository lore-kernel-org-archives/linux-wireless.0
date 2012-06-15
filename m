Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from h1355771.stratoserver.net ([85.214.105.140]:37564 "EHLO
	h1355771.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab2FOGTC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 02:19:02 -0400
Date: Fri, 15 Jun 2012 08:18:50 +0200
From: Andreas Kemnade <andreas@kemnade.info>
To: hong zhang <henryzhang62@yahoo.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	dsd@laptop.org, libertas-dev@lists.infradead.org
Subject: Re: poor performance with W2CBW003 (Marvell 8686)
Message-ID: <20120615081850.77454e10@kemnade.info> (sfid-20120615_081907_013150_94E4E9FF)
In-Reply-To: <1339690266.19412.YahooMailClassic@web161704.mail.bf1.yahoo.com>
References: <20120614074545.105a459d@kemnade.info>
	<1339690266.19412.YahooMailClassic@web161704.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/nobSRgKBGyJ+7vNG8U70Xkb";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/nobSRgKBGyJ+7vNG8U70Xkb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 14 Jun 2012 09:11:06 -0700 (PDT)
hong zhang <henryzhang62@yahoo.com> wrote:

> bit mode and interrupt or PIO are configured in SDIO hoster side.
> Not in driver side.
>=20
yes, I wrote the last email just to say that I have found something to look=
 at.
That is of course in the host driver. So the thing I did was reading
commit logs of the 2.6.32 kernel working well.

The only thing which puzzles me is the 5.5Mb/s data rate iwconfig shows.
After playing with the host side driver, it also shows higher rates. But
why does host driver affects *that* data rate of link qualitiy is good?

Thanks for all your ideas where to look at.

Greetings
Andreas Kemnade

--Sig_/nobSRgKBGyJ+7vNG8U70Xkb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk/a08oACgkQvUy8S31NDea/9QCghMvn8MXk71psi+KKWzFQUkc8
K+IAoLtCWTfZomTKa3PTPvVjnrKJXE3i
=rYLV
-----END PGP SIGNATURE-----

--Sig_/nobSRgKBGyJ+7vNG8U70Xkb--
