Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:35912 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933967AbXCFHdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2007 02:33:12 -0500
Date: Tue, 6 Mar 2007 07:33:07 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [FYI] compiling hostapd against latest wireless-dev
Message-ID: <20070306073307.GA24026@infradead.org>
References: <1173095902.6131.63.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1173095902.6131.63.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 05, 2007 at 12:58:22PM +0100, Johannes Berg wrote:
> ... isn't really possible at the moment. But you only need to change
> some include paths (to be able to include the
> net/mac80211/mac80211_common.h header!) and apply this change to be able
> to include include/net/mac80211.h into the userspace code.
> 
> And no, this shouldn't be applied. Rather should the prism ioctl foo be
> deleted.

Yepp.

