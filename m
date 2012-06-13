Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [85.214.105.140] ([85.214.105.140]:59299 "EHLO
	h1355771.stratoserver.net" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752687Ab2FMRns (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 13:43:48 -0400
Date: Wed, 13 Jun 2012 19:42:54 +0200
From: Andreas Kemnade <andreas@kemnade.info>
To: hong zhang <henryzhang62@yahoo.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	dsd@laptop.org, libertas-dev@lists.infradead.org
Subject: Re: poor performance with W2CBW003 (Marvell 8686)
Message-ID: <20120613194254.076268a8@kemnade.info> (sfid-20120613_194352_108330_37502908)
In-Reply-To: <1339607214.55182.YahooMailClassic@web161701.mail.bf1.yahoo.com>
References: <1339539360.3284.235.camel@localhost>
	<1339607214.55182.YahooMailClassic@web161701.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/3=rV_qZh7Bqk.jWqD+02Bh/";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/3=rV_qZh7Bqk.jWqD+02Bh/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 13 Jun 2012 10:06:54 -0700 (PDT)
hong zhang <henryzhang62@yahoo.com> wrote:

> > 4 bit is supported.
> > The hardware does not impose unresolvable limitations, the
> > 2.6.32 kernel
> > gives high performance. But since that kernel is not
> > mainstream, it is
> > very hard to find out which patch gives the slowdown. git
> > bisect
> > is not very useful in that situation.
> > SD memory card reading speed is always ok (on another of the
> > integrated
> > sd host controllers).
>=20
> Have you tested receive throughput? Any difference between TX and Rx thro=
ughput?=20
>=20
I tested both.
No significant difference with 3.x.

Greetings
Andreas Kemnade

--Sig_/3=rV_qZh7Bqk.jWqD+02Bh/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk/Y0R4ACgkQvUy8S31NDebG5wCgpeWATENoVsLZ9tbaz2A6WY+w
HjIAoJyM+I+om1LmQFIEkiaFYO8pP0KD
=sW+D
-----END PGP SIGNATURE-----

--Sig_/3=rV_qZh7Bqk.jWqD+02Bh/--
