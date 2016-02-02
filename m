Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:32920 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbcBBPSR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Feb 2016 10:18:17 -0500
Message-ID: <1454426294.2926.12.camel@sipsolutions.net> (sfid-20160202_161820_431303_800EB425)
Subject: Re: [PATCH 1/3] mac80211: move A-MSDU skb_linearize call to
 ieee80211_amsdu_to_8023s
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Date: Tue, 02 Feb 2016 16:18:14 +0100
In-Reply-To: <1454420350-8313-1-git-send-email-nbd@openwrt.org>
References: <1454420350-8313-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

all three applied, I fixed some whitespace damage (bad indent) on the
last patch

johannes
