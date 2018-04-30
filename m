Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753480AbeD3SQ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Apr 2018 14:16:29 -0400
Date: Mon, 30 Apr 2018 11:16:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sriram R <srirrama@codeaurora.org>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH 0/2 linux-stable-4.4] ath10k: rebuild crypto header in rx
 data frames
Message-ID: <20180430181619.GA12118@kroah.com> (sfid-20180430_201632_881627_2F509A7C)
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

Thanks, now queued up.

greg k-h
