Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbYEEJGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 05:06:04 -0400
Subject: Re: [PATCH 20/25] iwlwifi : Set monitor mode for 4965
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
In-Reply-To: <1209977598.2827.134.camel@debian.sh.intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-15-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-16-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-17-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
	 (sfid-20080505_044417_821018_3824BECA)  <1209971503.3655.0.camel@johannes.berg>
	 <1209974740.2827.124.camel@debian.sh.intel.com>
	 <1209976096.3655.19.camel@johannes.berg>
	 <1209977598.2827.134.camel@debian.sh.intel.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VpoQ19EIR2hrfYmgILhR"
Date: Mon, 05 May 2008 11:05:54 +0200
Message-Id: <1209978354.3655.24.camel@johannes.berg> (sfid-20080505_110525_742775_DB665983)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-VpoQ19EIR2hrfYmgILhR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> The thing is the firmware treats it as a different mode. For 4965, we
> explicitly setup the "sniffer" type to the firmware so that it operates
> differently with other modes. Some drivers (i.e ipw2200) have separated
> firmware images for bss, ibss and monitor modes.

Uh, ok. Weird firmware :)

johannes

--=-VpoQ19EIR2hrfYmgILhR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASB7N8KVg1VMiehFYAQJExRAAvrRdRSMHeSEfdNzUQzPr1e2s/Vte2Jlq
JvE+lsFmMD/GVKNc9pTHaSXWgNYPf1zHUHMiNJzMbvDl/m8XZwyrAxE1H8nKCqSQ
jWipOG2ftvI8zNAW7bPou0vbG+vGsAD8BBc9pvUki6lheFP1XCQsi4/+4sgHv39M
8Z9jxm5HHcMAJjh+uEiuwtLyy6k3pgULhD/tMWc7CNnJX0IhO9zJvBg/5VYdBfHV
wTs4FUXFnHcpCVzMR1/bGajdbL9hCeoZmODBXNSizYGMURvgqicEcaAhW6ZHkC3a
avpJi3ZeQdSmA3mRcHQnVhlj3MHlpC1EXeuEV4XivnI+nyXJ9YtYdxUR0sMxlX/G
bDbak/7iKI27oqMe2z1TESXSWH/WARHqCuLdJqkLgCyg1/eJvKQxOBKAg0HgZWsG
YGptUNrUFkuVl4xRLtSCuMq9JYo97pF/djjWfoJhGI84xS1dLscK6mHqiSEKmq3N
P6394U7kRTs5wUfvKw0X4Armwi3v5trEaIBuvwa9s3bby18T9Cbtjb7I6DXw9EaX
2++30k987bXunynxHDxEUAPqRmrnwvcEWBQhfddBu6kbVWV+Y3X6rUUm+AgGEt47
WUMHL330yxYjrjNXumPA9guecnSduIDtN6y4c5z7Pc8IbQU9UW8Bbd5kkCRMjJGj
8IN7GAOHqeo=
=HBpe
-----END PGP SIGNATURE-----

--=-VpoQ19EIR2hrfYmgILhR--

