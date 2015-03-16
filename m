Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47943 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbbCPIdG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2015 04:33:06 -0400
Message-ID: <1426494784.1935.2.camel@sipsolutions.net> (sfid-20150316_093311_282616_992AAF34)
Subject: Re: [PATCH 5/7] mac80211: Adjust chan_ctx when assigning reserved
 vif
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <egrumbach@gmail.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 16 Mar 2015 09:33:04 +0100
In-Reply-To: <1426143210-25635-5-git-send-email-emmanuel.grumbach@intel.com>
References: <1426143210-25635-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1426143210-25635-5-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-03-12 at 08:53 +0200, Emmanuel Grumbach wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> 
> It is possible to reserve a narrower channel context during csa (as long as
> the chandefs are compatible). However when the reservation is used, the
> channel context should be adjusted. Not doing so would result in attempts
> to use higher rates than the chan_ctx supports.

The commit log for this patch doesn't make any sense. I tried to make
sense of it, even with Luca's help, but I can't - are you thinking about
the min_def, which isn't really "the channel context" but just an
auxiliary concept?

I've applied all the other patches, but I rewrote the commit log for 7/7
(where I could figure out what you really meant)

johannes

