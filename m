Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48500 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726034AbeG0KvZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 06:51:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Wen Gong <wgong@codeaurora.org>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        ath10k@lists.infradead.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: Save sk_pacing_shift to ieee80211_hw
References: <1532589677-16428-2-git-send-email-wgong@codeaurora.org>
        <201807262252.r7bjxM51%fengguang.wu@intel.com>
        <c687d997be0c8e85a5e1e6f09a969dba@codeaurora.org>
Date: Fri, 27 Jul 2018 12:30:17 +0300
In-Reply-To: <c687d997be0c8e85a5e1e6f09a969dba@codeaurora.org> (Wen Gong's
        message of "Fri, 27 Jul 2018 16:35:42 +0800")
Message-ID: <87k1phf2l2.fsf@purkki.adurom.net> (sfid-20180727_113026_248027_8A154A00)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wen Gong <wgong@codeaurora.org> writes:

> Thanks,
> I will add description of tx_sk_pacing_shift as below and sent next
> patch.
> *
> * @tx_sk_pacing_shift: The TCP stack allow more than a single ms of data
> *     to be queued in the stack. The value is a bit-shift of 1 second,
> e.g. 8
> *     is ~4ms of queued data. It only affects local TCP sockets.
> */

Please don't top post:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#do_not_top_post_and_edit_your_quotes

-- 
Kalle Valo
