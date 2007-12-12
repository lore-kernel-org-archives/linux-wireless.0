Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from londo.lunn.ch ([80.238.139.98]:57602 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbXLLSCJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 13:02:09 -0500
Date: Wed, 12 Dec 2007 19:02:04 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: flamingice@sourmilk.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: Re: [PATCH] try 2: mac80211: Fix swapped parameters to
	ieee80211_set_channel()
Message-ID: <20071212180204.GP31218@lunn.ch> (sfid-20071212_180214_585278_726841D7)
References: <20071212153158.GB16947@lunn.ch> <1197481426.6558.138.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197481426.6558.138.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Good catch, but please resubmit with tabs as indentation and CC John as
> he gets to apply patches. Or I can send it on if you wish.

OK. Here it is with tabs, and with CC to John Linville

    Andrew

Signed-off-by Andrew lunn <andrew@lunn.ch>
---


diff --git a/net/mac80211/ieee80211_ioctl.c b/net/mac80211/ieee80211_ioctl.c
index 7027eed..50d4a46 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -344,7 +344,7 @@ static int ieee80211_ioctl_siwfreq(struct net_device *dev,
                                        IEEE80211_STA_AUTO_CHANNEL_SEL;
                        return 0;
                } else
-                       return ieee80211_set_channel(local, freq->m, -1);
+                       return ieee80211_set_channel(local, -1, freq->m);
        } else {
                int i, div = 1000000;
                for (i = 0; i < freq->e; i++)
