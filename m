Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:36060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759023AbZFWLZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 07:25:32 -0400
Subject: Re: [PATCH 1/2 RFC] cfg80211: connect/disconnect API
From: Johannes Berg <johannes@sipsolutions.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <20090622170409.GB30147@sortiz.org>
References: <20090622170409.GB30147@sortiz.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-k5d+B7NZHiUmJTCxJZ16"
Date: Tue, 23 Jun 2009 13:25:33 +0200
Message-Id: <1245756333.4184.44.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-k5d+B7NZHiUmJTCxJZ16
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

And this, symmetric to the first one:

[  302.975063] WARNING: at /home/johannes/sys/wireless-testing/net/wireless=
/sme.c:95 cfg80211_disconnected+0x9d/0xc0()
[  302.976435] Hardware name:=20
[  302.976869] Pid: 1321, comm: wpa_supplicant Tainted: G        W  2.6.30-=
wl #71
[  302.977819] Call Trace:
[  302.980113]  [<ffffffff8024ae93>] warn_slowpath_common+0x73/0xc0
[  302.981529]  [<ffffffff8024aeef>] warn_slowpath_null+0xf/0x20
[  302.982356]  [<ffffffff805a578d>] cfg80211_disconnected+0x9d/0xc0
[  302.983205]  [<ffffffff805a5092>] cfg80211_send_deauth+0x72/0x80
[  302.995239]  [<ffffffff805af634>] ieee80211_send_deauth_disassoc+0x144/0=
x160
[  303.005284]  [<ffffffff805af7e5>] ieee80211_set_disassoc+0x195/0x3d0
[  303.023982]  [<ffffffff805afac2>] ieee80211_sta_deauthenticate+0x42/0x50
[  303.027995]  [<ffffffff805b6ef7>] ieee80211_deauth+0x17/0x20
[  303.028830]  [<ffffffff8059dd7b>] nl80211_deauthenticate+0x14b/0x160

johannes

--=-k5d+B7NZHiUmJTCxJZ16
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKQLuqAAoJEODzc/N7+QmatAQQAIE5FeIPIU1rkWqnKjz+OYJJ
CJn15dqU4amiRjvjNkMp4TXvQ1a6S8EY5hOn8OgfEO6MIFafPrYpxUZReNUIy88M
yzMM5vE/Jodk5bEU1kYNU6rcVGUURgtXZXLnZQGc27soe9WZRKczfl1ia+ugStfq
DDKrae8aqXAmzdjrEjdCZd41Ie3MT2QO0jvRGoP2+B+CyAveqellsNl1ju2pRd3a
ekPcfdfczKWDJ2WhPUWucJdlOxP307pOCvhHcoZLENW5r5zo5FRQCPgMAEEH/x8T
X4HhltVHiUE8VM4gwPFjVa7TS+LcRit0tRu0SF1865HesTHLbzM3sy86UlF4qptA
qcHsB6Ee4tFISZqiAH6X7JH5iHmbc80mflNmXDpqAvMXrxxjZ215SQ1ldT8szoaP
Um7GwlB0KZXmF7vna4FdO/+7xeso2ui0V7MBSwMiadbnwrXL7XIoBwWrkET9DhyJ
A16O2/ZhON9IfTqFIQA0Bprn0t4z8YKNbiEFDIQedMiBVeev836v8DbkTsEg8VFB
Zhc2+gJOBcody5dtHM0VgdQbZ6gVtCd/Y8dMG5NFa6n1Gf3nb9Gjjromf09mOil+
rlqnuhNzJvnXBs8cKMqyLA/dgekgL41mnp+HXvHIr1XAyQu7DQCAeEPyytU5negv
w6tiNjnm0fiLMpE1olAK
=Oi4I
-----END PGP SIGNATURE-----

--=-k5d+B7NZHiUmJTCxJZ16--

