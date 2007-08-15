Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39348 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989AbXHON2e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2007 09:28:34 -0400
Subject: Re: [PATCH V3] mac80211: Turn off meaningless TKIP message when   software WEP encryption is used
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <46C2FCAB.6090607@lwfinger.net>
References: <46c0d788.GYQYqGfCBKyAWrg7%Larry.Finger@lwfinger.net>
	 <1187136960.31200.37.camel@johannes.berg>  <46C2FCAB.6090607@lwfinger.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1j7F9AG1yo04z6va/X8m"
Date: Wed, 15 Aug 2007 15:30:57 +0200
Message-Id: <1187184657.27608.1.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-1j7F9AG1yo04z6va/X8m
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-08-15 at 08:16 -0500, Larry Finger wrote:

> AFAIK, I'm using WPA-PSK TKIP. My AP is a Linksys WRT54G V5. On the "Wire=
less Security" page, I have=20
> selected "WPA Personal" for the security mode and TKIP for the WPA algori=
thm. On my laptop, the=20
> connection is managed by NetworkManager. My key is stored in Kwallet and =
is supplied automatically,=20
> but NM asked for a WPA passphrase when I set it up.

Ok.
=20
> That is certainly possible, either in my network or that of my neighbors.=
 A network list shows 5=20
> APs, two of which are mine. Only the AP in question is using WPA, 3 are u=
sing WEP, and one is=20
> unencrypted.=20

I don't think the other networks should matter, at least if we got the
BSSID filtering right.

> I'm collecting a packet dump now using Kismet - I don't run X on my secon=
d laptop as it=20
> has too little memory and is slow besides. I'll send you that file off-li=
st. I have filtered out=20
> beacons. I hope that is OK.

Sounds great, I'll take a look at it then.

johannes

--=-1j7F9AG1yo04z6va/X8m
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGwwAR/ETPhpq3jKURAuIOAKCE3hOuYcCasczNvuTRSG3E4PbyDgCcC65f
Lhr5p2S1MOqBFAFmXEF1w5E=
=FHGT
-----END PGP SIGNATURE-----

--=-1j7F9AG1yo04z6va/X8m--

