Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.infomaniak.ch ([84.16.68.90]:51277 "EHLO
	smtp2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777AbYFRLeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 07:34:37 -0400
From: Didier Raboud <didier@raboud.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bugme-new] [Bug 10903] New: ssh connections hang with 2.6.26-rc5
Date: Wed, 18 Jun 2008 13:34:06 +0200
Cc: Ilpo =?iso-8859-1?q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
	Andrew Morton <akpm@linux-foundation.org>,
	Netdev <netdev@vger.kernel.org>,
	bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
References: <bug-10903-10286@http.bugzilla.kernel.org/> <Pine.LNX.4.64.0806180152410.32420@wrl-59.cs.helsinki.fi> <1213773887.3803.158.camel@johannes.berg>
In-Reply-To: <1213773887.3803.158.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1314852.cUizIlx1dO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200806181334.10654.didier@raboud.com> (sfid-20080618_133459_483286_00AC1DF4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1314852.cUizIlx1dO
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Le mercredi 18 juin 2008 09:24:47 Johannes Berg, vous avez =C3=A9crit=C2=A0:
> > > > > > > > http://bugzilla.kernel.org/show_bug.cgi?id=3D10903
> > > > > > > >
> > > > > > > >            Summary: ssh connections hang with 2.6.26-rc5
>
> Andrew Prince reported a similar problem and said he bisected it  to
> davem's =EF=BB=BF608961a5eca8d3c6bd07172febc27b5559408c5d ("mac80211: Use
> skb_header_cloned() on TX path.") which made no sense to me so I marked
> the report as 'to investigate when I have more time'.
>
> > > and I got the attached "soft lockup".
>
> Attached where? I can't find it in the bug either.
>
> johannes

Hi,=20

for unknown reasons, my mail doesn't appear in the mailing list archives an=
d=20
the big attachment has visibly been stripped.

You'll find the "soft lockup" there:

http://raboud.homelinux.org/~didier/kernel/tcpdump_oops.jpg

Regards,=20

Didier
=2D-=20
Didier Raboud, proud Debian user.
CH-1802 Corseaux
didier@raboud.com

--nextPart1314852.cUizIlx1dO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkhY8q8ACgkQwW1nnOmiePC7LACgh4PI3zxmk0J2HY8CbFShx8PP
mokAnAmpInN/FS9ZwIULX2CRP7mvJs4t
=eXTe
-----END PGP SIGNATURE-----

--nextPart1314852.cUizIlx1dO--
