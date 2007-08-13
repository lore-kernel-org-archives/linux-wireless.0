Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:27303 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935902AbXHNAAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 20:00:43 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH V3] mac80211: Turn off meaningless TKIP message when software WEP encryption is used
Date: Mon, 13 Aug 2007 16:58:21 -0700
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <46c0d788.GYQYqGfCBKyAWrg7%Larry.Finger@lwfinger.net> <200708140054.22845.IvDoorn@gmail.com> <46C0E5AD.2080407@lwfinger.net>
In-Reply-To: <46C0E5AD.2080407@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1662557.yOAriq5RbT";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200708131658.27758.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1662557.yOAriq5RbT
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 13 August 2007 16:13, Larry Finger wrote:
> Yes, this empirical behavior does not seem to match one's intuition on wh=
at
> the flag should do.
>
The flag means the hardware does the rc4 but doesn't bother to deal with th=
e=20
IV/ICV. If you're going do software encryption, there's no reason to bother=
=20
with that flag, as that says your hardware supports and does rc4 in hardwar=
e.

=2DMichael Wu

--nextPart1662557.yOAriq5RbT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGwPAjT3Oqt9AH4aERAl2JAJ4sMN9ZwYUqtl/T3TI/NehNo8eKLQCgwhPV
SVai7Vjxx9RrrRJqY5XiAgg=
=L1ff
-----END PGP SIGNATURE-----

--nextPart1662557.yOAriq5RbT--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
