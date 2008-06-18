Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:49620 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189AbYFRHZa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jun 2008 03:25:30 -0400
Subject: Re: [Bugme-new] [Bug 10903] New: ssh connections hang with
	2.6.26-rc5
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilpo =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: Didier Raboud <didier@raboud.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Netdev <netdev@vger.kernel.org>,
	bugme-daemon@bugzilla.kernel.org, linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806180152410.32420@wrl-59.cs.helsinki.fi> (sfid-20080618_010511_957319_521A8B46)
References: <bug-10903-10286@http.bugzilla.kernel.org/>
	 <200806151537.11986.didier@raboud.com>
	 <Pine.LNX.4.64.0806161542290.16829@wrl-59.cs.helsinki.fi>
	 <200806172359.33768.didier@raboud.com>
	 <Pine.LNX.4.64.0806180152410.32420@wrl-59.cs.helsinki.fi>
	 (sfid-20080618_010511_957319_521A8B46)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7sktSxpeauONlM1NWqLR"
Date: Wed, 18 Jun 2008 09:24:47 +0200
Message-Id: <1213773887.3803.158.camel@johannes.berg> (sfid-20080618_092537_972893_56168D67)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-7sktSxpeauONlM1NWqLR
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable


> > > > > > > http://bugzilla.kernel.org/show_bug.cgi?id=3D10903
> > > > > > >
> > > > > > >            Summary: ssh connections hang with 2.6.26-rc5

Andrew Prince reported a similar problem and said he bisected it  to
davem's =EF=BB=BF608961a5eca8d3c6bd07172febc27b5559408c5d ("mac80211: Use
skb_header_cloned() on TX path.") which made no sense to me so I marked
the report as 'to investigate when I have more time'.

> > > You probably run it under X, no? Please switch beforehand to some oth=
er vt
> > > (a textual one) then (Ctrl-Alt-Fn, where n < 6) and then log in and
> > > running that command there and see if you get some output into screen
> > > there. If you see something (e.g., a sudden OOPS message or some othe=
r
> > > warning printed) when it locks up, the easiest things is to take a sh=
ot
> > > with a digicam (or write it down somewhere else) and send that shot (=
or
> > > those details) to us please.
> >=20
> > I tried the following in vt1 (under the new 2.6.26-rc6 with kdm stopped=
):
> >=20
> > # tcpdump -i wlan0 -w /tmp/tcpdump.wlan0
> >=20
> > and I got the attached "soft lockup".

Attached where? I can't find it in the bug either.

johannes

--=-7sktSxpeauONlM1NWqLR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIWLg7AAoJEKVg1VMiehFYPR8QAIgTQdxg/0sN1U0Lc6eX3z95
wf6Ivd8Je250gmreg4FzJrOiSB7fkmMvhyJL24HZ6+rQC/yz5zfHeeHSuKAVybtm
AfGhln31or1GYHm452+0AiTNZdK9BExtPExeRWEkl+cXQScY/Ye9k4Fcqyn99nQ2
x6WHOnvFCCM3kun2WYJVn0ilTNN7b3EuYTYNgB/kCX9YJwfp53KUl+MMno0cZrS5
M0qYgWKC8so3oV0npjFE/3uStXys1ACEKBUGGYMdnj+6bQAKk96JgH8mI3Di5m7R
wwKFEYbiX3y31WpDa4NjAiqGGj0q6xhf8JtJYo0a74dKNpol6Nbrq3SVSXvf1xfm
vhn4fpOzOtyt6XZ387oETvNuI3x0TBSSHvhtHYEJ6aZwYe6h0tYvqrwRcn89YONr
V6U1XEgqd2weLshjJkQ2PDZMNnbdz31ujdXQmpn7rlRy/YWYfJ2hkn2SotlVa+Cf
xqg3wVAK4MkQh9076mehCcxV4E34a0x2mp4Rsu/XAac5Z862CIJfgaMA5k1dTUPw
sGr4t8c954RUUqmmOUa1iW/9QF0wAj2B+mMwhy8B+oXlcuzS/UCpz1ZZ2G2BmNMq
NmjmgG/MWtVG32BMKRPJGAFUaXJFpuhRdFxV6OCHXONWHTI3Xm0ZisRwopgmGsws
IU7OIE00MyH3hlqmovtQ
=i9Ez
-----END PGP SIGNATURE-----

--=-7sktSxpeauONlM1NWqLR--

