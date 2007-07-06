Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:14901 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752683AbXGFEyc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 00:54:32 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: "Jon Smirl" <jonsmirl@gmail.com>
Subject: Re: Multiple interfaces in mac80211
Date: Thu, 5 Jul 2007 21:54:20 -0700
Cc: linux-wireless@vger.kernel.org
References: <9e4733910707041723g6f7a535ap1a62dd4473484d40@mail.gmail.com> <1ba2fa240707050530q2d165232raa73455397546c62@mail.gmail.com> <9e4733910707050632m794944b5nb9ac9393b05dfa75@mail.gmail.com>
In-Reply-To: <9e4733910707050632m794944b5nb9ac9393b05dfa75@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4403587.AQPdKWYTVV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200707052154.24976.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart4403587.AQPdKWYTVV
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 05 July 2007 06:32, Jon Smirl wrote:
> I'm debugging this because I've been trying for two days without
> success to get monitor mode to work. I have the adapter in promisc
> mode and the interface in monitor mode.  I can see directed and
> broadcast traffic with tcpdump, but not directed traffic for other
> nodes.
>
Outgoing packets from the wireless adapter are not reported unless you have=
=20
Johannes' radiotap patches. Is that what you're talking about?

=2DMichael Wu

--nextPart4403587.AQPdKWYTVV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGjcsAT3Oqt9AH4aERAu+/AKCUW+YUMwFx7+BbumvggUX1BeZxxgCeNZz1
G3n5cQW3CU/+SJ529Ix/JV4=
=Bjyh
-----END PGP SIGNATURE-----

--nextPart4403587.AQPdKWYTVV--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
