Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:14137 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754990AbXKGAvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 19:51:51 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Claudio Matsuoka <claudio@mandriva.com>
Subject: Re: RTL8187 rate control problems
Date: Tue, 6 Nov 2007 19:47:14 -0500
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200711061323.16302.claudio@mandriva.com> <20071106164148.GB4440@tuxdriver.com> <200711062239.13052.claudio@mandriva.com>
In-Reply-To: <200711062239.13052.claudio@mandriva.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1801492.s1PkzPfUKA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200711061947.21927.flamingice@sourmilk.net> (sfid-20071107_005157_014757_0E6753FD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1801492.s1PkzPfUKA
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 06 November 2007 19:39:11 Claudio Matsuoka wrote:
> Yes, I thought so. I checked the Realtek site and these specs are not
> published there, are they restricted for some reason or can I have a look
> at them?
>
Restricted, but you can find the specs for the 8186 floating around on the =
net=20
which tells you a bit about the registers. Doesn't tell you anything about=
=20
the rx/tx path of the usb variant, which is a bit inferior to the rx/tx pat=
h=20
of the pci chips. There's no easy way to do tx ack reporting on the rtl8187=
=2E=20
The only solutions that could work involve some polling or a different rate=
=20
control algorithm.

=2DMichael Wu

--nextPart1801492.s1PkzPfUKA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHMQsZT3Oqt9AH4aERAkKQAJ0RFL099Vbk866ge3I38CNgf1Zv+QCeLS12
lrgKVJ6u5gXxHeohRq7zU88=
=ztT1
-----END PGP SIGNATURE-----

--nextPart1801492.s1PkzPfUKA--
