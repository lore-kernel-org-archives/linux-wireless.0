Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33269 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357AbZD3SiJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2009 14:38:09 -0400
Subject: Re: [PATCH 2.6.30] mac80211: correct fragmentation threshold check
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
In-Reply-To: <20090430182927.GB9323@tuxdriver.com>
References: <1241040956.5067.1.camel@johannes.local>
	 <20090430182927.GB9323@tuxdriver.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-AipClsADw20KlfRCMr3N"
Date: Thu, 30 Apr 2009 20:37:39 +0200
Message-Id: <1241116659.29878.24.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--=-AipClsADw20KlfRCMr3N
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-04-30 at 14:29 -0400, John W. Linville wrote:
> Does there happen to be a bugzilla somewhere that corresponds to this?

No, Michael said he was running into this warning and this was the only
spot I could find... There's a mail somewhere:

http://article.gmane.org/gmane.linux.kernel.wireless.general/32205

johannes

--=-AipClsADw20KlfRCMr3N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJ+e/wAAoJEKVg1VMiehFYhSIP/0WnwWEsVcMrFeWgXKML8dT0
5J6UrLfDTcMH1Xr2EGPrcgJ6HnmXdAt6Wu09Bfr5SJZ3b87bg45FjNmIyC1mjQoy
ZrTTHRBiWN/ez+EYpQ/SutsNR2YW0VeTlCamT9wD+PxfneriBp5P5cX9lqFeL0Vz
Ti33oA2OkL9PuCRIqcyfUMWsp/YaC1/hjWRjXmrcmEeuYRnh9gNWgd/0ug729Sxr
1PK4u6ZZYihUOTZGmamLdT9whH0N4AHLfH9uOFB00/xOepio8spC4UHTcbazitod
DNjOEKqdVw61PJ2GQ/+3X8RfdfoH+E/yObAqkLrNxx6WYscVmO1KtuAaoMsNBt30
rlCPCVgC6/zKCT5dcLey43DPKf5U73+92fgh2oje4HyMBGG9WHqtyR6d00U/iQE6
2iRdE9H4QJoYMgio/29OkNNzPtC6nWvv5xgi9jGLIB6if8/oMhKuMpsr20z5MRY+
KAGK2gnAs5NzsAO1zjv0tL3jNFJxXDAZQ8Up7RUKRLjeO4gm/dzqGd+5yKKFKfS6
UtLvcE/WTMmT9ZKZ02/aR8HaBlxfvRXuDUvC9Qkjx5F9QkBhc8pq82Bzw6PXCT4P
xt6MpfE3g+FsO4eGvJvyItAXIugwTPp75c5KLcczQcGz0MYjN03XuOQTh+3gRZr5
XBGr7nFT1OJCUj8HhlRT
=Zo88
-----END PGP SIGNATURE-----

--=-AipClsADw20KlfRCMr3N--

