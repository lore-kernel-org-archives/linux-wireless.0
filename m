Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52467 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137AbYJHH6p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 03:58:45 -0400
Subject: Re: Infinite loop in sta_info_debugfs_add_work().
From: Johannes Berg <johannes@sipsolutions.net>
To: Robin Holt <holt@sgi.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Jiri Benc <jbenc@suse.cz>
In-Reply-To: <20081007225245.GN8534@sgi.com>
References: <20081004103144.GI8534@sgi.com>
	 <1223165956.24551.76.camel@johannes.berg> <20081005023143.GJ8534@sgi.com>
	 <1223195921.24551.79.camel@johannes.berg> <20081006064509.GK8534@sgi.com>
	 <1223283470.24551.86.camel@johannes.berg> <20081006133045.GM8534@sgi.com>
	 <1223330976.3778.47.camel@johannes.berg>  <20081007225245.GN8534@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sZt8seEWyRSo2Kue2h/8"
Date: Wed, 08 Oct 2008 09:58:42 +0200
Message-Id: <1223452722.3618.16.camel@johannes.berg> (sfid-20081008_095848_965716_C4E5EBE8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-sZt8seEWyRSo2Kue2h/8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-07 at 17:52 -0500, Robin Holt wrote:

> On a seperate note, I got a panic with your earlier patch applied at:
> IP: [<f8c669df>] :mac80211:netdev_notify+0x5f/0x90
>=20
> Not sure if that is just exposed by the hangs being out of the way.  I
> hand wrote that part.  Nothing else got captured in the logs :(

I think I've heard about such a thing before (RH BZ or something) but I
have not seen any plausible explanation for it yet since that function
checks pretty much everything that could go wrong. If you can get more
information I'd appreciate it. I think the previous conclusion was that
it might just have been fluke or a miscompilation.

johannes

--=-sZt8seEWyRSo2Kue2h/8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI7GguAAoJEKVg1VMiehFYnAAP/2c3FmciiPw8NxlB54pRSRmU
DOklVtll+7V0X3quJSMPLOqIeoHL0zkTlFoX5wzPy56ffbhrHSdbrqe2MV8SOe/t
MZHKKl3h38MoI9CLF1SMCSWlk1Ibs3vEZCe3CE75KjJwmRDSJ53fsimPKtvTa/Ot
yyqdSDptcgauOa2KxXOFSH6I56XJ3f2t1d0DEOdKKSWpKuP1YGg8LSVvinzeI3Nk
sNxvtNudktakg0c1Y+XEV/ebsu4nJlg7Rj/XaSogCV0LPqziSL0D/pfx8mwJrAJk
O+lfgcomSUdIr7ybqNYl86zfws4gkoK4IROP+m899+aTSYK72hm6aSEWa2g6fryV
OYCuEhww+esuXlsWuXlnV3lNRJfjsDlW0mD/0UKvRrP6r41RHnYtSoZjYk6Y4vF9
qgqcvYTcWvmGjFw+wRXbzOoArLOORS7F3TflYXpDoSAlh1NG8mFLGB2heY+h1U2D
oErifjJLxgAUvs6ChZAqxbCqgQf8n2Q5ggVInX2WR1GFsxu8lZzqVvHURy9r1wyr
aIfkVU39kDDiESsHvpAp/svBSR3G96RSnfNLYigD0jEIrggo7GGFmGZvNt+lzeG6
VUkCEunFXQN4jhmLzo9F/h59hx21S8zWyF5hF2yK9Vf97ZJmdUyY1LvtnM5gydz9
ON+gsKCoin/8eI4Uzt/4
=IDxl
-----END PGP SIGNATURE-----

--=-sZt8seEWyRSo2Kue2h/8--

