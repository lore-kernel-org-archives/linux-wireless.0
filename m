Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38592 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947AbaEMNv1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 09:51:27 -0400
Message-ID: <1399989073.4137.25.camel@jlt4.sipsolutions.net> (sfid-20140513_155130_534266_99B33F28)
Subject: Re: [PATCH v2] cfg80211: allow restricting supported dfs regions
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 13 May 2014 15:51:13 +0200
In-Reply-To: <1399283320-66468-1-git-send-email-nbd@openwrt.org>
References: <1399283320-66468-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-05-05 at 11:48 +0200, Felix Fietkau wrote:
> At the moment, the ath9k/ath10k DFS module only supports detecting ETSI
> radar patterns.
> Add a bitmap in the interface combinations, indicating which DFS regions
> are supported by the detector. If unset, support for all regions is
> assumed.

Applied. Not sure the "unset" thing is really the most appropriate, it
may make sense to change that once the driver gets updated.

johannes

