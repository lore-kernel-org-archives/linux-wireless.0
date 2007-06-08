Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:33751 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933269AbXFHQx5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 12:53:57 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH V3] mac80211: Set low initial rate in rc80211_simple
Date: Fri, 8 Jun 2007 09:35:36 -0700
Cc: Larry Finger <larry.finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
References: <4668c71b.E0vXnFMnxxm8I5gE%Larry.Finger@lwfinger.net> <200706072205.27902.flamingice@sourmilk.net> <20070608112146.2df3608c@griffin.suse.cz>
In-Reply-To: <20070608112146.2df3608c@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1212763.UXQSnCCK0s";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200706080935.40267.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1212763.UXQSnCCK0s
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 08 June 2007 02:21, Jiri Benc wrote:
> No :-) In theory, you can use PRISM2_HOSTAPD_SET_RATE_SETS ioctl to
> disable the lowest available rate. Yes, that's deprecated and bad thing
> to do; but unfortunately, it can be done with the current code.
>
Oh, nevermind, I didn't notice the [0] index.=20

> Larry's patch is IMHO correct.
>
I was pointing out the fact that the loop now unconditionally stops after t=
he=20
first iteration, which does not seem like what was intended given the=20
indentation level of the break. mode->rates[0].flags has nothing to do with=
=20
my comment though I answered that question (wrongly) anyway. :)

=2DMichael Wu

--nextPart1212763.UXQSnCCK0s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGaYVcT3Oqt9AH4aERAoMRAJ9//ZJ1xGas60Iq0LfOMOqIdZkvqwCfWJmS
s/PdEnvL0Uxr7Qrqu2fXmbA=
=MwT0
-----END PGP SIGNATURE-----

--nextPart1212763.UXQSnCCK0s--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
