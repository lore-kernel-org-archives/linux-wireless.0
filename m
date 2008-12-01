Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:57697 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYLARx1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 12:53:27 -0500
Received: by ug-out-1314.google.com with SMTP id 39so2743922ugf.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 09:53:26 -0800 (PST)
From: Henning Rogge <hrogge@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: RFC Patch v2: Add signal strength to nl80211station info
Date: Mon, 1 Dec 2008 18:53:16 +0100
Cc: Henning Rogge <rogge@fgan.de>,
	Johannes Berg <johannes@sipsolutions.net>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>, nbd@openwrt.org
References: <200811252131.30161.hrogge@googlemail.com> <200812011422.30671.rogge@fgan.de> <20081201173948.GD5992@tesla>
In-Reply-To: <20081201173948.GD5992@tesla>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2709015.YEA7tJ1iW4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200812011853.22318.hrogge@googlemail.com> (sfid-20081201_185331_506538_4D96C96E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2709015.YEA7tJ1iW4
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 01 December 2008 18:39:48 Luis R. Rodriguez wrote:
> It would be nice to get this figured out before adding it. We got random
> complaints from users claiming 802.11n wasn't working before because
> iwconfig didn't report a good rate. Users will trust it so I'd rather
> see this go in with MCS rate figured out as part of the API to avoid
> such reports. Would it be possible for you to work on that?

> This might come in handy:
>
> http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n#=
MC
>SRates
I will look at it... thank you for the link.

> What you need then is the guard interval, the MCS rate index and the
> number of streams being used for communication.

> Also how about we add a last TX rate and last RX rate so we get both?
Sounds like a good idea... have to look at the code of mac80211 a little bi=
t=20
more (I just copied the TX-rate thing from the wext code), but I really lik=
e=20
the idea.

Henning

--nextPart2709015.YEA7tJ1iW4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkk0JJIACgkQcenvcwAcHWfMPACfXNtVCtravTORyDYHNJGwm4vd
ND4An0/TOdZPi/av8J8io3lBeMDe1zrX
=Kyf3
-----END PGP SIGNATURE-----

--nextPart2709015.YEA7tJ1iW4--
