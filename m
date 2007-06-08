Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:47668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938268AbXFHHXK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 03:23:10 -0400
Subject: Re: [PATCH 1/3] mac80211: add IEEE802.11e/WMM structures
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
In-Reply-To: <1181266477.3039.97.camel@debian.sh.intel.com>
References: <20070606082210.GA28649@mail.intel.com>
	 <20070607223058.44122be4@griffin.suse.cz>
	 <1181266477.3039.97.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KL9vklekKc0wW6Hnxr+N"
Date: Fri, 08 Jun 2007 09:23:25 +0200
Message-Id: <1181287405.6533.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-KL9vklekKc0wW6Hnxr+N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-06-08 at 09:34 +0800, Zhu Yi wrote:

> I think we have talked this early and now you know correctly WIFI is not
> a trademark. You define IEEE80211_STYPE_ASSOC_REQ, etc, but defines
> those for Wi-Fi with WLAN prefix? WLAN prefix should be used by symbols
> defined by mac80211, for example: WLAN_CAPABILITY_ESS.

FWIW, I agree, and not using WIFI_ because it might be a trademark...
Jiri, feel free to put a note in the header that "all mentioned names
may be trademarks of their respective owners" or something, but
something that is defined by the wifi alliance should reasonably be
called WIFI_... too.

johannes

--=-KL9vklekKc0wW6Hnxr+N
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGaQPt/ETPhpq3jKURAga1AJ90SRwH+KqqgWk5270Rx1d3qqu9dwCfWW9/
7JSGTpXTpz9uYFCGLeAtQKg=
=7UZC
-----END PGP SIGNATURE-----

--=-KL9vklekKc0wW6Hnxr+N--

