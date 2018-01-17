Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54728 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753142AbeAQO7G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Jan 2018 09:59:06 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: pkshih@realtek.com, Larry.Finger@lwfinger.net,
        yhchuang@realtek.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3 04/10] rtlwifi: enable mac80211 fast-tx support
References: <20180117061530.30049-1-pkshih@realtek.com>
        <20180117061530.30049-5-pkshih@realtek.com>
        <5A5F24D1.2080709@broadcom.com>
Date: Wed, 17 Jan 2018 16:59:00 +0200
In-Reply-To: <5A5F24D1.2080709@broadcom.com> (Arend van Spriel's message of
        "Wed, 17 Jan 2018 11:26:25 +0100")
Message-ID: <87d128cz0r.fsf@kamboji.qca.qualcomm.com> (sfid-20180117_155910_015768_7585C0D5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 1/17/2018 7:15 AM, pkshih@realtek.com wrote:
>> From: Ping-Ke Shih <pkshih@realtek.com>
>>
>> To enable the mac80211 fast-tx feature, the hw/driver needs to support
>> dynamic power saving and fragmentation. Since our driver does not
>> need to fragment packet into smaller pieces, we just hook an empty
>> callback of set_frag_threshold to avoid fragmentation in mac80211.
>>
>> After this, the mac80211 will not fragment the packets and can transmit
>> them faster by cache the header information.
>
> NACK. Please refer to earlier discussion [1].

I dropped this patch.

-- 
Kalle Valo
