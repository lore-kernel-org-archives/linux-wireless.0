Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55224 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934326AbeGJQMy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Jul 2018 12:12:54 -0400
Subject: Re: [PATCHv2] mac80211: add stop/start logic for software TXQs
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <1531225597-4736-1-git-send-email-mpubbise@codeaurora.org>
 <201807102352.la08cKey%fengguang.wu@intel.com>
From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
Message-ID: <1ff8f34d-d6f9-68a3-cf57-058674a701ed@codeaurora.org> (sfid-20180710_181301_595613_CEC5B785)
Date: Tue, 10 Jul 2018 21:42:49 +0530
MIME-Version: 1.0
In-Reply-To: <201807102352.la08cKey%fengguang.wu@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> include/net/mac80211.h:1537: warning: Function parameter or member 'txqs_stopped' not described in 'ieee80211_vif'
>
Described txq_stopped instead of txqs_stopped; will fix this in the next 
version.

Thanks,
Manikanta
