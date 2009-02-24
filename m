Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:43591 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbZBXChb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2009 21:37:31 -0500
Subject: Re: Signal quality strange since commit 708c57cf1709fb95
From: Johannes Berg <johannes@sipsolutions.net>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Dan Williams <dcbw@redhat.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <8763j33rgq.fsf@litku.valot.fi> (sfid-20090222_074023_562332_D346678B)
References: <49A01922.1090106@lwfinger.net>
	 <1235241867.3284.44.camel@localhost> <49A05E35.70904@lwfinger.net>
	 <8763j33rgq.fsf@litku.valot.fi> (sfid-20090222_074023_562332_D346678B)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KjGjHFMoq03RzuIoryXi"
Date: Mon, 23 Feb 2009 18:10:41 -0800
Message-Id: <1235441441.4455.58.camel@johannes.local> (sfid-20090224_033734_461027_423FF9DF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KjGjHFMoq03RzuIoryXi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-02-22 at 08:39 +0200, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>=20
> > I know how it works with drivers that implement their own ioctl
> > calls for the WEXT interface; however, the 3 that I mentioned all
> > use mac80211 and get their WEXT support through cfg80211.
>=20
> Yes, something is wrong now. I noticed the same problem (/70 in signal
> strength) when I was implementing rssi support for at76c50x-usb.

Ok, so what exactly is the problem here?

I intentionally changed it to be /70 rather than /100 so I didn't have
to do *100/70 in kernel space, and tools should cope with that (and
users too); is there a problem with how the XX (XX/70) gets calculated?

johannes

--=-KjGjHFMoq03RzuIoryXi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJo1cdAAoJEKVg1VMiehFYll0P/0koJqv+el2G00qfhZ5eFzjD
eOpDZFQHewhIlZJK9Ndqtw5MTQPbrFCnoxINlt3bkH4oFyfpB6ggcY0SypJqGBJt
gRBAbERR2+WRhlOgpDN/ppDNk2YtMplhjEoCW4QkqV+/txRk8zI8m6pp6vkwOTgR
C3ccibQM2PLF5bW/7nnEMx4nTsvz5o+n/e/onGMZeSVPN4NcS/sqAwDi4CeZQpN9
fyWF4nCGqWQ6HSmqpbxjA22st1Rz+XkJCEu6d5kH+muDK0MoJY0tfrIRc5dqD5ba
1LUBS+SH/YmDPkTI+2lWXIgQNFvBg9dc/Zpg5ptPOOsawBzVlV7gnoHhtkkGQs5P
E01oXJWKLzFGuAVvYf922yNe3bfjxpphGejKECB9AzEjdwT68KvCEht6gg2YzlpI
MuBZWn/pre/1cMoJqo4EbPeuNAvFFThf3GPPbtkxCXQzirmAL8gWwvp45fgFnkfQ
YxAMCbfaS9hrZRdTuujU3GxZ2JjkWnYlg/448Jh6uvtkMJvSEVsA081Gk6j8YJPo
UWEMdFlfCMqFxjvRxs3zOz4ht5C/Zw3778sueol2HtX2QsWyG//0ocb2TIwL5NGh
KUWL5dMmkll59GjkZVTLEocPJnRovnm0uFQhBWq2A9tyWanBeRclJ1se5iIhKuXa
/HlOSXUqOs7uRn/ksufW
=4wWz
-----END PGP SIGNATURE-----

--=-KjGjHFMoq03RzuIoryXi--

