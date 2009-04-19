Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail3.webfaction.com ([70.85.44.146]:35519 "EHLO
	mail3.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761551AbZDSRKh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 13:10:37 -0400
Date: Sun, 19 Apr 2009 13:09:51 -0400
From: Forest Bond <forest@alittletooquiet.net>
To: Greg KH <greg@kroah.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <marcel@holtmann.org>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH] Add vt6656 driver to drivers/staging.
Message-ID: <20090419170950.GA28885@storm.local.network> (sfid-20090419_191101_724088_54FFFA63)
References: <20090414105200.GE25746@storm.local.network> <1239707258.4778.3.camel@johannes.local> <20090414113928.GA20470@storm.local.network> <1239709727.4778.6.camel@johannes.local> <1239712106.11795.21.camel@violet> <1239713034.17109.10.camel@johannes.local> <20090414130248.GA3291@tuxdriver.com> <20090414141852.GB20470@storm.local.network> <20090415011020.GC10045@kroah.com> <20090415015116.GJ20470@storm.local.network>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
In-Reply-To: <20090415015116.GJ20470@storm.local.network>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Apr 14, 2009 at 09:51:16PM -0400, Forest Bond wrote:
> I need to get you some new patches, anyway, as the upstream sources depen=
d on
> header files that I failed to provide as they sit in a separate includes
> directory.  I'll get this sent as soon as time permits (probably today or
> tomorrow).

I have some new patches almost ready, including Kconfig files and Makefiles=
=2E  I
am in the process of resolving a few build failures.

However, I did have a question:

The vt6655 driver builds viawget.ko, and the vt6656 driver builds vntwusb.k=
o.
Should the directories be named "viawget" and "vntwusb," respectively, or i=
s it
appropriate for them to be named "vt6655" and "vt6656"?

Thanks,
Forest
--=20
Forest Bond
http://www.alittletooquiet.net
http://www.pytagsfs.org

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJ61reRO4fQQdv5AwRAtLZAKDHpj/++2ZtbR2dqP1cS4mUCGRVBgCeLtwt
CKMSzOfxeAQr/QgIWqGHuz4=
=9ixY
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
