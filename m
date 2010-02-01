Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60898 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab0BAVZO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2010 16:25:14 -0500
Subject: Re: [PATCH 1/1] cfg80211: wext: set bssid to NULL in SIOCIWESSID
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Zhao, Shanyu" <shanyu.zhao@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100201194748.GC4952@tuxdriver.com>
References: <1264808376-8003-1-git-send-email-shanyu.zhao@intel.com>
	 <1264840626.3546.181.camel@johannes.local>
	 <380B2771CDD78E46856E6B788D9F199750233886@orsmsx503.amr.corp.intel.com>
	 <1265052460.29119.0.camel@johannes.local>
	 <20100201194748.GC4952@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-+KIsEiqi9E96hKR312Gn"
Date: Mon, 01 Feb 2010 22:25:04 +0100
Message-ID: <1265059504.29119.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-+KIsEiqi9E96hKR312Gn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2010-02-01 at 14:47 -0500, John W. Linville wrote:

> > > iwconfig wlan0 essid "foo"
> > > This will make the station associate with the first AP with essid
> > > "foo".
> > >=20
> > > iwconfig wlan0 ap "00:...:ff"
> > > This will disassociate from the previous AP, and then associate with
> > > the first AP with MAC "00:...:ff".
> > >=20
> > > Am I missing anything here?
> >=20
> > No, I missed something. The problem will only occur when the SSID is
> > hidden as well, because the connect code will not have the SSID and not
> > know what to scan for, or which SSID to choose (there are Cisco APs tha=
t
> > use the same BSSID for multiple hidden SSIDs).
>=20
> Well, in the confusion I deleted the original post.  Could you
> (i.e. Shanyu Zhao) resend it to me?

Sorry -- I wasn't clear. My mail missed something in describing the
problem, but that doesn't change the fact that the patch will break it.

johannes

--=-+KIsEiqi9E96hKR312Gn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLZ0atAAoJEODzc/N7+QmaUD8P/0/yGyyeCUHhZv9qSATMHbyS
0VidzZ9ZpKpfQRpCh6bqKqIoImBHrF/+4gKFnEZJyK4nwfHblnbJELK852yL1MlG
btn2anuwI+U4cepcqSNt6L0doHup5KzJp4QegyhdBluY90Q2PyPtr+vb3pAWnNFC
+1c1mgtVQDVj1yeHeEFpiDDVczFhYK+2dMft8e586hnKq3eyG3JK3Dida8Jh9PTu
hZqhb0/bc6+FqicTAaWtm9pWT+j/Xf7NshAnJ6owP2locJyZ0DVLZlMio4Tgzyjf
hu0NooDsEDK3GrV/htr8W5KYEZ1AlGEhjX3aZbinjQMrnxVXwyUFdIzKRQnBU3Rl
rJrO9h0s+lDvdYOMEemKyMZiaNtLOCA5qA3E/VLvTbMYjWc36oCVNyK1WnBQoYg8
srL57CWrfynFgmwvnjG/PWYaA3Xk0Ks9yyXNSIiDfo84HzIbEgAuOqS7YP21nFPd
ySNjeVCGQy+vMsrIeCiD2CJXsDDyMmhjCgubQTuPdja2xdwsdU/ZWcch/7JxJqM1
0KZa9poSRK60PLnczqowPsaYkmQhNdMsMoXC5dL2Ta8D7sNxXp6RnrtBaON3b7vv
EtFYsAg4GGnbdGl7HFrD9n1a5OVQ1+3+HEPEvcXfeWINlLySp4yZvZThyrjK8gaW
VVDAkTA34eKjIYuS8Q6j
=DQxB
-----END PGP SIGNATURE-----

--=-+KIsEiqi9E96hKR312Gn--

