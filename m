Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41011 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab1AGK6F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 05:58:05 -0500
Subject: Re: [PATCH 1/3] ath9k: Decrease skb size to fit into one page.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 11:58:00 +0100
Message-ID: <1294397880.3467.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-01-06 at 16:46 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Patch is from Eric Dumazet, as described here:
> https://patchwork.kernel.org/patch/104271/
> 
> Reported-by: Michael Guntsche <mike@it-loops.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
> 
> NOTE:  This needs review by ath9k and/or other informed
> people.

This doesn't make sense. It might help, but it'll probably lead to not
being able to receive all frames off the air.

If this is an issue, ath9k should do paged RX like iwlwifi.

johannes

