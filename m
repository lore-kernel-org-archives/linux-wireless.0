Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44664 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751162AbdFEPNv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Jun 2017 11:13:51 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: Re: [PATCH 2/9] rtlwifi: btcoex: rename ex_halbtc....YZant to ex_btc.....YZant
References: <20170602213435.29968-1-Larry.Finger@lwfinger.net>
        <87bmq28p6l.fsf@codeaurora.org>
Date: Mon, 05 Jun 2017 18:13:45 +0300
Message-ID: <87vaoa79hy.fsf@qca.qualcomm.com> (sfid-20170605_171419_373205_A9658F5E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Removing the X letters from the subject to bypass vger filters)

Kalle Valo <kvalo@codeaurora.org> writes:

> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>>
>> These external functions are for BT-coexistence, so remove the "hal"
>> prefix for consistancy.
>>
>> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Ping-Ke Shih <pkshih@realtek.com>
>> Cc: Birming Chiu <birming@realtek.com>
>> Cc: Shaofu <shaofu@realtek.com>
>> Cc: Steven Ting <steventing@realtek.com>
>
> On my inbox I see four different versions of this patch 2 but on
> patchwork I only see one, but with a different date than rest of the
> patches in this series and hence is wrong order. What happened, did you
> perhaps delete some of the patches from patchwork?
>
> But anyway, if there are accidental multiple patch submissions please
> always submit the whole series again as v2. Resubmitting is the most
> reliable method to make sure that I apply the correct version of
> patches, anything is else is just confusing me and increases the chances
> that I apply the wrong version.

Hehe, so I think I now understand what happened:

<linux-wireless@vger.kernel.org>: host vger.kernel.org[209.132.180.67] said:
    550 5.7.1 Content-Policy reject msg: The capital Triple-X in subject is way
    too often associated with junk email, please rephrase.  BF:<H 0>;
    S1751112AbdFEOtn (in reply to end of DATA command)

But anyway, please resubmit the whole series as v2.

-- 
Kalle Valo
