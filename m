Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:57158 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbXC3KvZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2007 06:51:25 -0400
Subject: Re: mac80211 vs. hostapd
From: Johannes Berg <johannes@sipsolutions.net>
To: Joerg Pommnitz <pommnitz@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <347198.46462.qm@web51402.mail.re2.yahoo.com>
References: <347198.46462.qm@web51402.mail.re2.yahoo.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/Vfg2wqXC7MtAEPgwY2N"
Date: Fri, 30 Mar 2007 12:50:33 +0200
Message-Id: <1175251833.19085.19.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-/Vfg2wqXC7MtAEPgwY2N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-03-30 at 01:37 -0700, Joerg Pommnitz wrote:

> The kernel part of the stack does
> not include the AP functionality at all.

Well, it includes some of the required functionality obviously...

>  Handling of associated stations is done by hostapd. Is this
> correct so far?

If I understand you correctly, then yes.

>  Does "iwconfig wlan0 mode master" have any meaning?=20

It prepares mac80211 to accept hostapd commands on the interface.

> How does one create multiple
> virtual interfaces (the equivalent of Madwifis wlanconfig command)?

Through nl80211 or cfg80211's sysfs.

> If so, I could not find a sample configuration for hostapd that provides =
a simple, unsecured AP.
> I suspect that this is because traditionally hostapd has only been used t=
o provide a WPA secured AP.

The hostapd config file is well commented. Go read it.

johannes

--=-/Vfg2wqXC7MtAEPgwY2N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGDOt4/ETPhpq3jKURAg6aAJ98LYAsBJJyZ79s3pwhro4sq7FrVACeI/dm
I4BqKnosPDMLpp0g71tDY3Y=
=zmWz
-----END PGP SIGNATURE-----

--=-/Vfg2wqXC7MtAEPgwY2N--

