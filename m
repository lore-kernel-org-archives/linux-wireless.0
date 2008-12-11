Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:34403 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756972AbYLKTZS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 14:25:18 -0500
Subject: Re: [RFC] mac80211: Add HT rates into RX status reporting
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org,
	Henning Rogge <hrogge@googlemail.com>
In-Reply-To: <20081211192251.GA5170@jm.kir.nu>
References: <20081211161741.GA27460@jm.kir.nu>
	 <1229015789.8081.40.camel@johannes.berg> <20081211181545.GB32500@jm.kir.nu>
	 <1229019768.8081.53.camel@johannes.berg>  <20081211192251.GA5170@jm.kir.nu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fToZ+3mw4MWbfuq1d2b3"
Date: Thu, 11 Dec 2008 20:24:42 +0100
Message-Id: <1229023482.8081.67.camel@johannes.berg> (sfid-20081211_202532_997043_9704DE28)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-fToZ+3mw4MWbfuq1d2b3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-12-11 at 21:22 +0200, Jouni Malinen wrote:
> On Thu, Dec 11, 2008 at 07:22:48PM +0100, Johannes Berg wrote:
> > On Thu, 2008-12-11 at 20:15 +0200, Jouni Malinen wrote:
> > > Yes. FreeBSD radiotap definition uses 0x80 as a flag in the rate fiel=
d
> > > for indicating that it is an MCS index, not bitrate.
>=20
> > Ugh. Nobody will dissect that properly.
>=20
> Actually, wireshark seems to have code to dissect that..

Ok, I stand corrected. Oh well, this is a huge mess...

> Well, yes, I do need it like yesterday. I really want to have a reliable
> sniffer that I can trust on providing correct information about received
> frames. I can obviously handle a personal patch that adds this, but it
> gets more complex when asking others to capture some frames for you..

Right. We'll need A-MPDU stuff too, I guess?

> Anyway, I will move the radiotap parts into a separate patch and leave
> it to others to decide whether that should go in now or not. The best
> option (if John is willing) would likely be to get the first part
> (mac80211 driver API addition and ath9k fix/cleanup) in and pushed
> upstream while the radiotap parts would be maintained only in
> wireless-testing for the time being.

I agree, that seems best.

johannes

--=-fToZ+3mw4MWbfuq1d2b3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJQWj3AAoJEKVg1VMiehFYaw0QAMD20qcWMj1Xj8/jES8FFSEo
hfDdfX5j2uDUMhxd8LR+fTg+qSzMmVzjOtrpacLVvbx3lFlt8vsumDajz/q4SBPj
eo9hNBYVQmQheuyUuegTrbF/sZFZlZKIeY6CAGbsGBZqGnzRvRExtPDjgW3/RgDY
J82qS0wI0obkqeTe9gKpq/fen+dEu9HDIBJDq9wt/3oPE3xR7I8So7+PRF4XhQx2
xspMnplFbexw1wh3Jy9ZkTck14NCWQG9Y53biWS3WXFUEWRqUiPIWaf91BMVvlTS
4Dj1Sg3+0X1BlZrmZ6I7lZzQxDp7otAxAnmwb0XW8C5iM31EKQg62k04AJwRBDo7
8hb0RMlLJnjEF1bhQYJsMx5NV0BOvQY64fv5eL5W0aJeQj2keDuYcr11813Tqpn2
fPUiOzsxjw9jSLVbGtFLfGH/3TajMWC6RB2arRJkrNncpXTbPTcIBc9mEFq81OTN
lpTTgnI8eQlhyqnm5YAxZwYDEIbPf4Ai0ZgDh7VFC2X+kdpayGJ2gHOBV9zASccW
syfTHOpwGs+hIux3izZTsX471cs8gRjy1MEVwmkFI/NJbWIWRTm0j0kbDrsIspmi
J9wL9nzO7AyhEdjH6b8E2SCiWLtJlwmVQyXlBX7sj1sbyIGZn0KPjQrlqdYSv6cn
bW+C1TeXYTTrhl5YQknm
=J7JN
-----END PGP SIGNATURE-----

--=-fToZ+3mw4MWbfuq1d2b3--

