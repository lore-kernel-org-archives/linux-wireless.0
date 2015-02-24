Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37971 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752321AbbBXJxc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2015 04:53:32 -0500
Message-ID: <1424771609.2192.7.camel@sipsolutions.net> (sfid-20150224_105400_547057_97EA2D8F)
Subject: Re: [PATCH] mac80211_hwsim: Add minimal capability for vendor
 command/event testing
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 24 Feb 2015 10:53:29 +0100
In-Reply-To: <1423498789-11760-1-git-send-email-jouni@qca.qualcomm.com>
References: <1423498789-11760-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-02-09 at 18:19 +0200, Jouni Malinen wrote:
> This allows wpa_supplicant/hostapd to send a vendor command and verify
> response to that command and event.

I'm going to drop this since you're working on the wdev thing. That
might even help you with the first patch since you don't need to update
this then.

Please resubmit all these three patches (probably just two then)
together.

johannes

