Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38123 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750970AbeEBU7M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 16:59:12 -0400
Date: Wed, 2 May 2018 13:59:00 -0700
From: Greg KH <greg@kroah.com>
To: Sriram R <srirrama@codeaurora.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 0/2 linux-stable-4.4] ath10k: rebuild crypto header in rx
 data frames
Message-ID: <20180502205900.GB18099@kroah.com> (sfid-20180502_230201_682379_931E8206)
References: <1525069587-19281-1-git-send-email-srirrama@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525069587-19281-1-git-send-email-srirrama@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 30, 2018 at 11:56:25AM +0530, Sriram R wrote:
> ath10k has a replay detection issue which was fixed in v4.14 and we would
> like to get this security fix also to linux-stable-4.4.But for that it
> depends on 3 mac80211 patches so the below mac80211 commits needs to be
> picked first in the same order and then apply this patchset.
> 
> f980ebc058c2 : mac80211: allow not sending MIC up from driver for HW crypto
> f631a77ba920 : mac80211: allow same PN for AMSDU sub-frames  
> cef0acd4d7d4 : mac80211: Add RX flag to indicate ICV stripped
> 
> These patches should be applied in that order(commit f980ebc058c2 first)
> and they should apply cleanly with 3-way merge.

Ok, let's try this again, now queued up :)

greg k-h
