Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53076 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3CGKYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 05:24:08 -0500
Message-ID: <1362651844.8694.26.camel@jlt4.sipsolutions.net> (sfid-20130307_112412_898521_15378A80)
Subject: Re: [PATCH] mac80211: provide race-free 64-bit traffic counters
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: greearb@candelatech.com
Date: Thu, 07 Mar 2013 11:24:04 +0100
In-Reply-To: <1362416578-1672-1-git-send-email-johannes@sipsolutions.net> (sfid-20130304_180309_300167_9633E6E6)
References: <1362416578-1672-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20130304_180309_300167_9633E6E6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-03-04 at 18:02 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Make the TX bytes/packets counters race-free by keeping
> them per AC so concurrent TX on queues can't cause lost
> or wrong updates. This works since each station belongs
> to a single interface. While at it also make the bytes
> counters 64-bit.

Applied, with the fix Ben suggested.

johannes

