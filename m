Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ht1.myhostedexchange.com ([69.50.2.37]:62297 "EHLO
	ht1.hostedexchange.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161159Ab3DEIlW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Apr 2013 04:41:22 -0400
Date: Fri, 5 Apr 2013 10:39:56 +0200
From: Antonio Quartulli <antonio@open-mesh.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] cfg80211: add get_max_tp() API
Message-ID: <20130405083956.GA14463@open-mesh.com> (sfid-20130405_104127_352691_94EB5BB6)
References: <1365105442-31876-1-git-send-email-antonio@open-mesh.com>
 <CAGXE3d98a4pBG=gWKUm9A2RJRN+eic4Zi8dh4grTuqQmW3GOsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
In-Reply-To: <CAGXE3d98a4pBG=gWKUm9A2RJRN+eic4Zi8dh4grTuqQmW3GOsg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Helmut,

On Fri, Apr 05, 2013 at 01:21:06AM -0700, Helmut Schaa wrote:
> Hi Antonio,
>=20
> On Thu, Apr 4, 2013 at 9:57 PM, Antonio Quartulli <antonio@open-mesh.com>=
 wrote:
> > This new API is aimed to let other modules in the kernel
> > fetch the maximum throughput value towards a peer over
> > a given VIF.
>=20
> Just curios, what's the intended use for this?
>=20

In the batman-adv module (which implements a routing protocol for mesh netw=
orks
on layer 2) we are trying to switch metric from packet loss to throughput a=
nd
the idea is to read the estimation from the rate control component (thanks =
to
the API mechanism in cfg/mac80211 this can be eventually changed later).

I am not entirely sure that the value I proposed to read (the maximum in the
rate table) is the one which better plays the needed role. But the prelimin=
ar
tests demonstrated that it  :)


Cheers,


--=20
Antonio Quartulli

=2E.each of us alone is worth nothing..
Ernesto "Che" Guevara

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBCAAGBQJRXo3cAAoJEADl0hg6qKeO27YP/2DoIn9hFn8bOojFFdxUpBA5
RbiU1mi5pC2xXABr4Ix0+zXTjoNV65LgNUcj2kp6AJ589jPOxpVG6cnGfJngGgwq
0AQKMnB/A38iRg3X4MBshnnDZPUXac52cEc93d406HD+lvfAgP4FtXZJByA6n/nw
ZOVz5SyH1pd6ut7mndmli+ZZAYjnW13TI0npyTGWNCwUU46/Z8swkkOtK/LMiibd
Fm6t42XaKFK9h+xwu7QtlvhliBSIdeSehxTnW76JJLt/2q9KEquDlOT+n+1luQE2
3Uoyz3IGNq1RnUen3sy58+H5KK4e7M+dQ3/tHjW+U6zyhd8lVCLOcbwo9EW+EPCV
B4MTVv6qH2W/eNmZn+9q3HV//6gsYEkijT/GGbA3SNG4JJpYIZvRGw0lqIX6+mPp
mYZxggnjfb5xsCkkehgxxi+OXaiJQVs4QPUOSqqatx1722misbXOGfo27KZlTth+
19UVlsezU9Ld/9aveFILtiv4BFmBJMNY1A3lbKtqK5yt11PPhwClmkqoaRR7h+gp
4U7FwofxcokrXwekfhzSH8/MbR5MNKDMDlJzzQmtGbl1b0ztlZr8FZc7UIf8hDm4
ywOBiRRxdAwnNXKsvX2/wN3McllMqrmmKgXfFNl8hAfuvl9n8d0kGEArg+/MNyLX
rrK8solfYrygCcoRxsY5
=221Y
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
