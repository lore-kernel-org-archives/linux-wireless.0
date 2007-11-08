Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43849 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759901AbXKHRXd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Nov 2007 12:23:33 -0500
Subject: Re: [FYI] hostapd state with mac80211 on linux
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: hostap <hostap@shmoo.com>, Chuck Tuffli <CTuffli@dspg.com>,
	Guillaume Chevillot <guillaume@chevillot.net>,
	Alexander Kotelnikov <sacha@myxomop.com>
In-Reply-To: <1193338400.4406.4.camel@johannes.berg> (sfid-20071026_113617_589897_6D21318C)
References: <1193338400.4406.4.camel@johannes.berg>
	 (sfid-20071026_113617_589897_6D21318C)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PC7rXhhmudzju1NAZG7S"
Date: Thu, 08 Nov 2007 18:24:55 +0100
Message-Id: <1194542695.4793.16.camel@johannes.berg> (sfid-20071108_172342_980902_F2BD15D1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-PC7rXhhmudzju1NAZG7S
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> hostapd works with
>  - kernel 2.6.24-rc1
>  - plus my patches from http://johannes.sipsolutions.net/patches/kernel/a=
ll/
>  - plus the commit 5c58298c2536252ab95aa2b1497ab47eb878ca5d from net-2.6
>    ([NETLINK]: Fix ACK processing after netlink_dump_start)
>  - my hostapd patches from http://johannes.sipsolutions.net/patches/hosta=
p/all/

I forgot to mention that it needs libnl, but now I can fix that: while
it used to require libnl from git it should work with the recently
released libnl 1.0-pre7. Hopefully distros will pick that up in the same
way they picked up 1.0-pre6.

johannes

--=-PC7rXhhmudzju1NAZG7S
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUARzNGZqVg1VMiehFYAQJRahAAvD1lS1gVaA+7ntHwnKptGvTrHYHgbMn1
3hFhKKqm4j2EOSRz7ANgFgFC3SFDXkZ6NouQWAUiHknb8xdALH7rrnxaZ1o6slD6
R8jHXmoXcBS8HOgsvPiP+lXR4eJpV28xrT6lMMOOKPEHq1LihWymAy+bXzPEh9pu
UvU3vhBi1DiOEi+ldM3QGSuWRYxsUIxoOoFPRGP0ho4Ggd7nkhMXzwCmbX+vQwM5
S2dPX5NpjhDRDK6+lmsyVFORops6yOntNLrAWOMqJ5FF3RdRXLA4NrcjdN82FAMv
9ckCRSVPgjfvrXzU0UOftDz+FRxuFNliARZ6oI70lvMbYi6awXhmwudmBQPBH/Od
vG/4NlI6F0E7rgAJCPgWUnO147No1haSlEDRUew4kiRWMWmibcxW9wHK1x9eC3no
pBFZKMs6cVnVvCF4t5D9VX/qy9B2vn4ay1DIquocjXgzHHfgy/ikhPSzf/8OCTxy
DGbhcpzAESMyGnKNUGzKhNUjPV2zoSNYly9KEsK4gEzd59otuZU7l20vDUT0uP+1
Ry0q1FJH9Px0OOYobH7dYS7Sj+UIG9yRhImtg6AuMsSOqHVeCVD+HVc8Iccow/lG
2k2xyCLKYjrMDEDKn16v7Vyd2MEdfh1TeGHlyQz9DOcTdWSkw0wkMoZy1p1BFJ7Y
7ZWZs0MQ3yY=
=gdfV
-----END PGP SIGNATURE-----

--=-PC7rXhhmudzju1NAZG7S--

