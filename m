Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41070 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab2HERMf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Aug 2012 13:12:35 -0400
Message-ID: <501EA97B.3010703@openwrt.org> (sfid-20120805_191238_582924_59C32460)
Date: Sun, 05 Aug 2012 19:12:27 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: WDS vs. multi-channel operation
References: <1343655393.4452.13.camel@jlt3.sipsolutions.net>
In-Reply-To: <1343655393.4452.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-07-30 3:36 PM, Johannes Berg wrote:
> Ok so I'm chipping away at multi-channel operation, but WDS is
> troubling. Which channel should it use? It doesn't even have channel
> configuration today, but relies on having a channel already, but that
> breaks when you have multi-channel since then it either has to have its
> own channel or be slaved to another channel...
> 
> Anyone have any ideas?
Let's bind WDS interfaces to AP VIFs, then they can be slave to the AP's
channel context. This is necessary for my yet-to-be-resubmitted WDS
fixes anyway.

- Felix

