Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from daemonizer.de ([87.230.16.230]:52434 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758624AbXE0Vuy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2007 17:50:54 -0400
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Sun, 27 May 2007 23:50:42 +0200
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Stephen Hemminger <shemminger@linux-foundation.org>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Jeff Garzik <jgarzik@pobox.com>,
	Gary Zambrano <zambrano@broadcom.com>, netdev@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705272313.33129.mb@bu3sch.de> <200705272316.07338.mb@bu3sch.de>
In-Reply-To: <200705272316.07338.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1803652.zZzKimUVej";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200705272350.45843.maxi@daemonizer.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1803652.zZzKimUVej
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 27 May 2007, Michael Buesch wrote:
> On Sunday 27 May 2007 23:13:32 Michael Buesch wrote:
> > On Sunday 27 May 2007 21:25:17 Maximilian Engelhardt wrote:
> > > 2.6.21.1:
> > > [  5] local 192.168.1.2 port 58414 connected with 192.168.1.1 port 50=
01
> > > [  5]  0.0-60.6 sec  1.13 MBytes    157 Kbits/sec
> > > [  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 578=
37
> > > [  4]  0.0-63.1 sec  2.82 MBytes    375 Kbits/sec
> > >
> > > 2.6.22-rc3:
> > > [  5] local 192.168.1.2 port 46557 connected with 192.168.1.1 port 50=
01
> > > [  5]  0.0-60.4 sec  58.9 MBytes  8.18 Mbits/sec
> > > [  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 516=
33
> > > [  4]  0.0-63.1 sec  7.27 MBytes    967 Kbits/sec
> >
> > This is the diff between these two kernels.
> > I'm not sure why you see a much better TX throughput here.
> >
> > Can you re-check to make sure it's not just some test-jitter?
>
> Oh, eh, and what I forgot to ask:
> Do you know an old kernel that works perfectly well for you,
> so I can look at a diff between this one and anything >=3D2.6.21.1.

I don't know any, most older kernels did work fine for me, but I never user=
=20
iperf there so I guess if the bug is there also I simply didn't trigger it.
If you think it's usefull I could go back and try different kernels, but th=
at=20
would take some time.
Except the iperf bug 2.6.21.1 and 2.6.22-rc3 work fine.

Maxi

--nextPart1803652.zZzKimUVej
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWf01Oimwv528XGERAngXAJ9DNgcgpf07I00M7q4QlJnNcczVxACgyAdG
gWUkTYXKcBvO2SfHY5PP5u0=
=GPEv
-----END PGP SIGNATURE-----

--nextPart1803652.zZzKimUVej--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
