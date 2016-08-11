Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52510 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828AbcHKMNc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 08:13:32 -0400
Message-ID: <1470917552.5266.19.camel@sipsolutions.net> (sfid-20160811_141336_032093_A2F3E778)
Subject: Re: [PATCH] mac80211: remove skb header offset mangling in
 ieee80211_build_hdr
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date: Thu, 11 Aug 2016 14:12:32 +0200
In-Reply-To: <20160713090002.51127-1-nbd@nbd.name> (sfid-20160713_110004_041152_D6C9EDB9)
References: <20160713090002.51127-1-nbd@nbd.name>
	 (sfid-20160713_110004_041152_D6C9EDB9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-07-13 at 11:00 +0200, Felix Fietkau wrote:
> Since the code only touches the MAC headers, the offsets to the
> network/transport headers remain the same throughout this function.
> Remove pointless pieces of code that try to 'preserve' them.
> 
Applied, thanks.

johannes
