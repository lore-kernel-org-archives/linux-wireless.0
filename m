Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:36227 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933341AbXBETXm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Feb 2007 14:23:42 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC PATCH 1/3] cfg80211 and nl80211
Date: Mon, 5 Feb 2007 14:23:09 -0500
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <20070131013717.GA28076@tuxdriver.com> <200702051314.21627.flamingice@sourmilk.net> <1170699268.3572.39.camel@johannes.berg>
In-Reply-To: <1170699268.3572.39.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2887420.o4QVh55Ead";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702051423.13998.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2887420.o4QVh55Ead
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 05 February 2007 13:14, Johannes Berg wrote:
> > I'm not sure what you mean. The program can get the configuration info =
it
> > needs from nl80211/cfg80211/WE and send/inject frames through the monit=
or
> > interface.
>
> Well, I guess I'm saying that wpa_supplicant shouldn't need the monitor
> iface at all since it wants just management frames and we should give
> those to it via netlink to avoid having to add more radiotap foo.
>
Yeah, a monitor interface is overkill for wpa_supplicant. We can make the=20
IEEE80211_IF_TYPE_MGMT be a sort of filtered monitor interface optimized fo=
r=20
userspace MLME. Or maybe add some sort of filtering configuration for monit=
or=20
interfaces.. might be overkill. Anyway, netlink does not seem appropriate f=
or=20
sending or receiving frames.

=2DMichael Wu

--nextPart2887420.o4QVh55Ead
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFx4QhT3Oqt9AH4aERAhg2AKDQLsWTfcirY/z17ZdSEyvKDNL8RACfYduQ
J0eEhO2Tv1imKt33+7fi1I0=
=qK5H
-----END PGP SIGNATURE-----

--nextPart2887420.o4QVh55Ead--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
