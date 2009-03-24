Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from durandal.kismetwireless.net ([199.201.145.179]:38475 "EHLO
	durandal.nerv-un.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755636AbZCXUMY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 16:12:24 -0400
Date: Tue, 24 Mar 2009 16:13:19 -0400
From: Mike Kershaw <dragorn@kismetwireless.net>
To: G?bor Stefanik <gst@remote-exploit.org>
Cc: "Info[at]Giuppi" <info@giuppi.com>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: rtl8187 bug report
Message-ID: <20090324201319.GB14489@drd1813.lan> (sfid-20090324_211241_011044_3AEFBF84)
Reply-To: Mike Kershaw <dragorn@kismetwireless.net>
References: <49C12DFA.80308@giuppi.com> <3ace41890903191439q1c375925md2e4227f79147399@mail.gmail.com> <49C2D537.6080406@giuppi.com> <3ace41890903191856s234118c9j2f4de15486cb37a9@mail.gmail.com> <49C39A83.5090004@giuppi.com> <69e28c910903201406o1e908214s4f0ab8cfa28392f1@mail.gmail.com> <20090322235416.GA32143@drd1813.cave.swamp>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
In-Reply-To: <20090322235416.GA32143@drd1813.cave.swamp>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 22, 2009 at 07:54:16PM -0400, Mike Kershaw wrote:
> On Fri, Mar 20, 2009 at 10:06:49PM +0100, G?bor Stefanik wrote:
> > Could you please test if you can see packets originating from your
> > network in Kismet or Wireshark?
> > Also, did you use the included airmon-ng script to enable monitor
> > mode, or did you just do "ifconfig wlan0 down; iwconfig wlan0 mode
> > monitor, ifconfig wlan0 up"? (The two are significantly different, as
> > airmon-ng uses iw/nl80211 to enable monitor mode on a separate
> > interface - it would be good if you tried it both ways.)
>=20
> I have actually seen similar problems with the 8187 (unknown if it is B
> or L - the drivers think it's B, but the production run of the hardware
> is NORMALLY L and may have recently changed;  I have known-B generic card=
s=20
> and maybe-B Alfa cards)

I am NOT seeing this behavior under 2.6.29 so far (~1hr test) with
channel hopping enabled (siocsiwchan, nothing fancy) at 3x a second,
single rfmon vap set via siociwmode.

-m

--=20
Mike Kershaw/Dragorn <dragorn@kismetwireless.net>
GPG Fingerprint: 3546 89DF 3C9D ED80 3381  A661 D7B2 8822 738B BDB1

"Hostility towards Microsoft is not difficult to find on the Net, and it=20
blends two strains: resentful people who feel Microsoft is too powerful,=20
and disdainful people who think it's tacky. This is all strongly reminiscen=
t=20
of the heyday of Communism and Socialism, when the bourgeoisie were hated=
=20
=66rom both ends: by the proles, because they had all the money, and by the=
=20
intelligentsia, because of their tendency to spend it on lawn ornaments."
                       -- Neal Stephenson

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknJPt8ACgkQ17KIInOLvbGGZwCfcT6S2CTeOQdYKjeNN68wnEaO
SUEAn0veNqaMl5YSuUFsXhv/0sm2c60u
=UtUF
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
