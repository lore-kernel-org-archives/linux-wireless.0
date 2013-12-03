Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from glaubenleben.de ([85.214.105.140]:39698 "EHLO glaubenleben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab3LCUKX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 15:10:23 -0500
Date: Tue, 3 Dec 2013 20:26:07 +0100
From: Andreas Kemnade <andreas@kemnade.info>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: status of libertas_tf + sdio?
Message-ID: <20131203202607.0b445195@kemnade.info> (sfid-20131203_211026_589880_7AEA89CB)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/99/4iGekBLiWLQ+.zjPJO42"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/99/4iGekBLiWLQ+.zjPJO42
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi,

I want to be able to use my marvel sdio wifi as an ap, so I am interested
in having the sdio interface of libertas_tf. I sucessfully copied
over the libertas_tf directory from somewhere and fixed a bit of things
and compiled that in a 3.7 kernel. It works.
But now I am thinking about generating a clean patch.

I found this one here:
http://www.spinics.net/lists/linux-wireless/msg55245.html
Is there any newer patch to start working on?

Greetings
Andreas Kemnade

--Sig_/99/4iGekBLiWLQ+.zjPJO42
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlKeME8ACgkQvUy8S31NDeZ7HACfb1CJLiUXX4LM6cSr8effWBaI
LSYAni0qZ8XESLeH9e3P+C2siRagyezM
=PcT5
-----END PGP SIGNATURE-----

--Sig_/99/4iGekBLiWLQ+.zjPJO42--
