Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57889 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab1FOMnc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jun 2011 08:43:32 -0400
Received: by yxi11 with SMTP id 11so191212yxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Jun 2011 05:43:32 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 15 Jun 2011 20:43:31 +0800
Message-ID: <BANLkTi=AM=mqmz7+hYGMwmVhFTHHd0o3Ug@mail.gmail.com> (sfid-20110615_144335_938466_44053B48)
Subject: can mesh(802.11s) be supported in 802.11n?
From: b z <zb80211@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have got 2 802.11n wireless routers using ralink rt3052f soc chip,mimo 2x2
burned with openwrt (kernel 2.6.37.6, compat-wireless-2011-05-27)

I configured them as mesh point respectively,  then
#iw dev wlan0 station dump

but the tx rate and rx rate still not exceed 54mbps, that is mean the
ht mode(300mbps) is not been actived

can anyone tell me how to active the 802.11n ht mode in mesh?
it is the problem with mac80211 or rt2800pci driver?
or mesh using 802.11n is not implemented in the current kernel?

will it be implemented in the future?
thank!
