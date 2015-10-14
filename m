Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:59739 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446AbbJNOsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 10:48:54 -0400
Date: Wed, 14 Oct 2015 16:48:43 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Larry Finger <larry.finger@lwfinger.net>,
	Hauke Mehrtens <hauke@hauke-m.de>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: [PATCH][RFC][RFT] ssb: pick PCMCIA host code support from b43
 driver
Message-ID: <20151014164843.4f9a00e3@wiggum> (sfid-20151014_164858_853464_77CB78EE)
In-Reply-To: <CACna6rwGRM-qiXSijeGDzupwUXg62BoUDtyL3gPD-HrCJvhQmQ@mail.gmail.com>
References: <1442826259-6270-1-git-send-email-zajec5@gmail.com>
	<20150921182000.6d89445d@wiggum>
	<CACna6rzSqnJF2uBS-DszR+1PFNwqM8S0WecAE+R4QRJjGYuXYQ@mail.gmail.com>
	<20150923175801.69076f31@wiggum>
	<CACna6rwGRM-qiXSijeGDzupwUXg62BoUDtyL3gPD-HrCJvhQmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/6kn8V_ZeAd8Hog1RscyFw/P"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Sig_/6kn8V_ZeAd8Hog1RscyFw/P
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Oct 2015 13:17:16 +0200
Rafa=C5=82 Mi=C5=82ecki <zajec5@gmail.com> wrote:

> If all PCI-bus-host-specific code is always the same,

And that's the point. It's always the same _except_ for the device IDs.
Which obviously are PCI-device specific.

--=20
Michael

--Sig_/6kn8V_ZeAd8Hog1RscyFw/P
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWHmtLAAoJEPUyvh2QjYsOe8QP/RKKCOiVfm+W0aNVaqbBl+l/
p39+NGqku4DmgjVogHlen2wlgKDDUonsc88y1IENPl32xTqgkS6QxKYoOJXuxkw3
hE/U+qgff28fonwtVh+mSz/aV8F+icxo6GsvSOnnAzxugtDE2v7oU5vuNdHtlhVs
QmsnuJIWYhlvUJp/dR8ZBRnd7sl8B/5M96lJICwMAhlQl/6DvYTq0s8e+lVQYS8P
JFbE9DgiSpV54LV7CPuBNuHByI/B9CdCrY+PO6Tmp94l0OJulUJUGZibCtivjdtH
Wf1UhwIlK4lwEFaVHzhEFyav9hLR5HGil0aQfphXE/QBd54K5/cYt9AUaMYlO4Jm
knv5VbMEHgopUT3mWNjN2b4PWzK5pq4IVBL3O3hQYuMR0/6V7u8iT6vsm2QAFbuI
EgxJ04YVxz2D9cOdCFitSsOgCeE2EN1wtSLdDSoDOXEYmaBoMNqFFlkTjHs4Sukh
eXFiS8f3/Slfyf2y3aRQ+YDNTYeUPoAAjCdUQ0aW5JrCaaPSsPZdZTVj0DXj47Id
WLcQ+Fkn+XYurHgy45xNzwwRH1oBp79iFlLrkkmey1OXebv/hRy5g38PW1wBYtCh
TmR4Wv5ca4HrubLAptXwQS3z3M+5I8ox7pZF2W4G8ko64i/vdfCmPn7nGKlPGUnp
bPMFhXtM7/3qz+AxE9hN
=R/Hh
-----END PGP SIGNATURE-----

--Sig_/6kn8V_ZeAd8Hog1RscyFw/P--
