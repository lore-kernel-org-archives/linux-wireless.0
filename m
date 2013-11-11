Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36222 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab3KKN45 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Nov 2013 08:56:57 -0500
Message-ID: <1384178213.14334.17.camel@jlt4.sipsolutions.net> (sfid-20131111_145710_894189_8BEB9BF5)
Subject: Re: [PATCH] mac80211: fix crash when using AP VLAN interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Nov 2013 14:56:53 +0100
In-Reply-To: <1383928297-25206-1-git-send-email-nbd@openwrt.org>
References: <1383928297-25206-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-11-08 at 17:31 +0100, Felix Fietkau wrote:
> Commit "mac80211: implement SMPS for AP" applies to AP_VLAN as well.
> It assumes that sta->sdata->vif.bss_conf.bssid is present, which did not
> get set for AP_VLAN.
> Initialize it to sdata->vif.addr like for other interface types.

Applied.

It'd be great if you could submit a vlan and 4-addr test to Jouni's
hwsim tests :-)

johannes

