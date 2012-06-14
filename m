Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from h1355771.stratoserver.net ([85.214.105.140]:52715 "EHLO
	h1355771.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2FNGue (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jun 2012 02:50:34 -0400
Date: Thu, 14 Jun 2012 07:45:45 +0200
From: Andreas Kemnade <andreas@kemnade.info>
To: hong zhang <henryzhang62@yahoo.com>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	dsd@laptop.org, libertas-dev@lists.infradead.org
Subject: Re: poor performance with W2CBW003 (Marvell 8686)
Message-ID: <20120614074545.105a459d@kemnade.info> (sfid-20120614_085037_174476_3BC3AC4E)
In-Reply-To: <1339612748.69001.YahooMailClassic@web161703.mail.bf1.yahoo.com>
References: <20120613194254.076268a8@kemnade.info>
	<1339612748.69001.YahooMailClassic@web161703.mail.bf1.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/hnLahwjvpLBeE9xYX093dB4";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/hnLahwjvpLBeE9xYX093dB4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, 13 Jun 2012 11:39:08 -0700 (PDT)
hong zhang <henryzhang62@yahoo.com> wrote:

> You have to identify problem caused by=20
> SDIO host controller or wifi driver.
>=20
> If driver is working well in x86 with Roch SDIO, that means wifi driver i=
s ok.=20
>=20
> You have to find out
> 1. SDIO interface if using Interrupt or PIO

Hmm, very interesting point, of course, there are interrupts. But after rea=
ding
the commit logs in the patched 2.6.32 kernel I see there is a patch enabling
asynchronous *sdio* interrupts. That looks clearly suspicious.=20

> 2. 1 bit or 4 bit

Hmm, 4bit.

Greetings
Andreas Kemnade

--Sig_/hnLahwjvpLBeE9xYX093dB4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk/ZeooACgkQvUy8S31NDebPmgCeOZbPYKkwr8Xy7xhO2Ku/jysP
qnUAnR65lNJ1eqFnWkNxiHCroJauERgK
=nGiz
-----END PGP SIGNATURE-----

--Sig_/hnLahwjvpLBeE9xYX093dB4--
