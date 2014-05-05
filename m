Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39602 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635AbaEEHeC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 03:34:02 -0400
Message-ID: <1399275222.22235.2.camel@jlt4.sipsolutions.net> (sfid-20140505_093409_549323_30FB5B38)
Subject: Re: [PATCH 3.15] cfg80211: allow restricting supported dfs regions
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 05 May 2014 09:33:42 +0200
In-Reply-To: <1399150555-36041-1-git-send-email-nbd@openwrt.org>
References: <1399150555-36041-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-05-03 at 22:55 +0200, Felix Fietkau wrote:
> At the moment, the ath9k/ath10k DFS module only supports detecting ETSI
> radar patterns.

It seems this should also be advertised to the userspace.

> Add a bitmap in the interface combinations, indicating which DFS regions
> are supported by the detector.

Does that make sense? It seems unlikely to me that it would be interface
combination specific?

I think it's already questionable to put this in after -rc4, in
particular with the userspace advertising part. Can we do anything
else? 

johannes


