Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44290 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbeGDFNJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 01:13:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 04 Jul 2018 10:43:08 +0530
From: Tamizh chelvam <tamizhr@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/7] mac80211: Add api to support configuring station
 specific rssi threshold
In-Reply-To: <1530264674.3481.36.camel@sipsolutions.net>
References: <1528886747-26342-1-git-send-email-tamizhr@codeaurora.org>
 <1528886747-26342-4-git-send-email-tamizhr@codeaurora.org>
 <1530264674.3481.36.camel@sipsolutions.net>
Message-ID: <5eb5f19dd161db6486befe750e558923@codeaurora.org> (sfid-20180704_071313_059443_DCA3B3D6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-06-29 15:01, Johannes Berg wrote:
> The subjects are a bit confusing - I think you should align the 
> cfg80211
> and mac80211 ones so it's clearer that this one is implementing the
> previous one's API. Peer vs. station, and mac80211 doesn't add API but
> implements it.
> 
> This patch doesn't really do anything though, so I guess you need to
> combine it with patch 5.
> 
Okay sure
