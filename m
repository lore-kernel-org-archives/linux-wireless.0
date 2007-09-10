Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57822 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbXIJLGl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2007 07:06:41 -0400
Subject: Re: COMMON symbol warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Tomas Winkler <tomasw@gmail.com>, Zhu Yi <yi.zhu@intel.com>
In-Reply-To: <20070908130118.GA11648@infradead.org>
References: <1189100314.28781.112.camel@johannes.berg>
	 <20070908130118.GA11648@infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EevsAf/QsXoxwn9DGwWr"
Date: Mon, 10 Sep 2007 13:08:12 +0200
Message-Id: <1189422492.4506.54.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-EevsAf/QsXoxwn9DGwWr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-09-08 at 14:01 +0100, Christoph Hellwig wrote:

> Yes.  It means a variable is declared in multiple places and the linker
> merges it for you.  The fix is to make sure these are declared extern in
> all places but one.

Interesting. So it's missing in a header file but sparse doesn't warn
about it like it does with functions that aren't declared nor static?

johannes

--=-EevsAf/QsXoxwn9DGwWr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG5SWc/ETPhpq3jKURAq7eAJ9Ui0EiUY5VCDUhMRWZH1sgbTlybQCfejPa
h/5IiXaVlZBBByBI7+3bV+I=
=cfPh
-----END PGP SIGNATURE-----

--=-EevsAf/QsXoxwn9DGwWr--

