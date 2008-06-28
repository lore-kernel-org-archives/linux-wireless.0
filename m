Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:39918 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752501AbYF1DpN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 23:45:13 -0400
Message-ID: <4865B3C6.1030007@gmx.de> (sfid-20080628_054520_514865_A52F30EE)
Date: Sat, 28 Jun 2008 05:45:10 +0200
From: Jan Conrads <janconrads@gmx.de>
Reply-To: janconrads@gmx.de
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Missing channels on iwl3945  shipped with 2.6.26-rc8
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,

I build a vanilla kernel 2.6.26-rc8 tonight.

But I only see the international channels 1-11 36-64.



With cfg80211 it should be possible to set a diffent regiocode:


~ modinfo cfg80211
filename:       /lib/modules/2.6.26-rc8-jan/kernel/net/wireless/cfg80211.ko
description:    wireless configuration support
license:        GPL
author:         Johannes Berg
srcversion:     710CF290EE4647BC8A3A50B
depends:
vermagic:       2.6.26-rc8-jan SMP mod_unload modversions CORE2
parm:           ieee80211_regdom:IEEE 802.11 regulatory domain code (charp)

I read, that 64 should be ok, but if I set any option only the 2.4GHz
Band is listed. For germany 276 is a common valve on atheros cards, but
this doesn not work, too.


Yours Jan Conrads
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIVAwUBSGWzxStM7u3i25jxAQJpXg/+L0HME8ywkYoc59ql/wZj74WgD1w80RpU
BIy23ntM9kWDUc44UxScjldCSn1zWdNqid7iTms+FVFU+lrDdvQybauxpd92CyHe
AFJw/HIio37ADSH9w97mwyKXq6QcticKgtD6PuZvkngJUsa9HcANJv2nGxzQ37A8
paS42GjsPe2d6hVl4KICrNxDJjB6w38NTI6Ss9yOj7u9qEZy5WC1fTvRBQ2nzX3n
40mBL7XnY+LwPhBTP3Syi5nFgEYzguntxZSiRGS2ZK5caacqcq2/+szqk5657z5R
EtWetVvml32lrkDaephIi1CA6+4HeJoR0ErgT/ClD7+eu7rYUUGF9vwdi/HIKbCk
orkCgt0AVy7XC4hmbReuQip4mPeeD6InShH/8lgkWPpCs5W/H+6YWNZhZateVrF4
69KREgQbAStM6AAdNrdRlRgYLtCuS+rmKSAQLfyNnBdoWUHy7oYAEpPoP3WOh3rH
l+sPG5n2GXuWIT64jjEvsbPNxqA4RcFNkaZgfQrXOoeuy4BGG1YWONT83VXzVe9x
B+RkS9FziWxPH1SxepFBIStF7Uif7Vwfy9nlW8p3hhhY87U5BrpM/G1lZSOwu1PV
sHmS3Ik9kpc34bnXdTl6UucoxTlQHHnSoxAif0RZkUaMsTraBafjmkEscAe4T8HY
v4TqTzcny0Y=
=UXkm
-----END PGP SIGNATURE-----
