Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:44928 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbXHBJMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 05:12:44 -0400
Subject: Re: chaning mode only when interface down?
From: Johannes Berg <johannes@sipsolutions.net>
To: dragoran <drago01@gmail.com>
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <46B18B77.5020802@gmail.com>
References: <46B18B77.5020802@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-63s1UtFa7RTiIXvPq0R3"
Date: Thu, 02 Aug 2007 11:14:04 +0200
Message-Id: <1186046044.24230.11.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-63s1UtFa7RTiIXvPq0R3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-08-02 at 09:44 +0200, dragoran wrote:
> I noticed that I have to do ifdown wlan0 before I can change the mode=20
> with iwconfig.
> When I do it while the interface is up I get a error that the device is=20
> busy.

It is busy.

> It seems to happen with ad-hoc, master and back from them to managed.
> Is this a bug in the iwlwifi driver or in mac80211 ?

Neither, it is expected behaviour. Blame it on Jean that wireless
extensions are ill-defined and don't mandate this.

> Because of this NM can't create ad-hoc networks because it does it while=20
> the device is up.
> Any ideas?

Fix NM?

johannes

--=-63s1UtFa7RTiIXvPq0R3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGsaBc/ETPhpq3jKURApKaAJ9VsGeDcry0SUYer2xkRzzUOptITwCdF89D
NLG8/vOMblzTaf/TcK9kviI=
=f4ZU
-----END PGP SIGNATURE-----

--=-63s1UtFa7RTiIXvPq0R3--

