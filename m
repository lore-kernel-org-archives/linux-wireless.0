Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jessica.hrz.tu-chemnitz.de ([134.109.132.47]:54412 "EHLO
	jessica.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755185AbZFIVbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2009 17:31:01 -0400
From: Tobias Doerffel <tobias.doerffel@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH] ath5k: added cfg80211 based rfkill support
Date: Tue, 9 Jun 2009 23:31:00 +0200
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
References: <20090607150755.GA19635@hash.localnet> <1244561607-6304-1-git-send-email-tobias.doerffel@gmail.com> <b6c5339f0906091126k573b8725hf623367abcdcdf1f@mail.gmail.com>
In-Reply-To: <b6c5339f0906091126k573b8725hf623367abcdcdf1f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart95741141.FDORy51out";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200906092331.01072.tobias.doerffel@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart95741141.FDORy51out
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

Am Dienstag, 9. Juni 2009 20:26:12 schrieb Bob Copeland:
> > +       /* enable RFKILL when stopping HW so Wifi LED is turned off */
> > +       ath5k_rfkill_enable(sc);
>
> Odd, but ok :)
Why odd? As a user if I disable Wifi (i.e. enable rfkill, be it via softwar=
e=20
or rfkill switch), I do not want the LED to be active anymore. It also migh=
t=20
have minimal influence on power consumption ;-)

Regarding the other changes I'd agree on an additional patch made up by you.

Toby

--nextPart95741141.FDORy51out
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkou1JUACgkQHsjdpw2OaadH7ACdFzIWpBOslxL/Ov9KI3zkjI72
makAn3MedoFXSOQ0iYGFeZvaev3mnciG
=I1cu
-----END PGP SIGNATURE-----

--nextPart95741141.FDORy51out--
