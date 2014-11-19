Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:39993 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752950AbaKSRir (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 12:38:47 -0500
Message-ID: <1416418724.9374.8.camel@sipsolutions.net> (sfid-20141119_183849_871764_004D5BE3)
Subject: Re: [PATCH] mac80211: skip legacy rate mask handling for VHT rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, karl.beldan@rivierawaves.com
Date: Wed, 19 Nov 2014 18:38:44 +0100
In-Reply-To: <1416019734-17509-1-git-send-email-nbd@openwrt.org>
References: <1416019734-17509-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-11-15 at 03:48 +0100, Felix Fietkau wrote:
> The rate mask code currently assumes that a rate is legacy if
> IEEE80211_TX_RC_MCS is not set. This might be the cause of bogus VHT
> rates being reported with minstrel_ht.

Applied.

johannes

