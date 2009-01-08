Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from flock1.newmail.ru ([82.204.219.207]:55815 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759818AbZAHSzY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 13:55:24 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: [PATCH] orinoco: take the driver lock in the rx tasklet
Date: Thu, 8 Jan 2009 21:55:14 +0300
Cc: orinoco-devel@lists.sourceforge.net,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
References: <1231287835-17707-1-git-send-email-kilroyd@googlemail.com> <200901081128.30143.arvidjaar@mail.ru> <496644D0.6050301@gmail.com>
In-Reply-To: <496644D0.6050301@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart15226211.t0LQKgWvT4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200901082155.15657.arvidjaar@mail.ru> (sfid-20090108_195529_090933_A2F0A61E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart15226211.t0LQKgWvT4
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On =D0=A7=D0=B5=D1=82=D0=B2=D0=B5=D1=80=D0=B3 08 =D1=8F=D0=BD=D0=B2=D0=B0=
=D1=80=D1=8F 2009 21:24:16 Dave wrote:
> The move to the RX tasklet was not motivated by improved performance,
> but the requirements of the crypto library (can't call from
> interrupt) and the need to do MIC calculations on RX.
>
> Unless the crypto routines have changed, reverting that commit will
> break WPA support.

Thank you for clarification.

--nextPart15226211.t0LQKgWvT4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklmTBMACgkQR6LMutpd94yKMACgokphX6yE5V8C4CCPe7oz+iRB
2/gAn385ZudvXbyUERxOJlDqjZzLVuJh
=GduK
-----END PGP SIGNATURE-----

--nextPart15226211.t0LQKgWvT4--
