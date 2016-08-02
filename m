Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40050 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755788AbcHBIb0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 04:31:26 -0400
Message-ID: <1470123940.2665.11.camel@sipsolutions.net> (sfid-20160802_103142_117094_34FD96CD)
Subject: Re: [PATCH] mac80211: fix check for buffered powersave frames with
 txq
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Date: Tue, 02 Aug 2016 09:45:40 +0200
In-Reply-To: <20160711130915.86284-1-nbd@nbd.name> (sfid-20160711_150917_670422_3ECD3697)
References: <20160711130915.86284-1-nbd@nbd.name>
	 (sfid-20160711_150917_670422_3ECD3697)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-07-11 at 15:09 +0200, Felix Fietkau wrote:
> The logic was inverted here, set the bit if frames are pending.
> 
Applied, thanks.

johannes
