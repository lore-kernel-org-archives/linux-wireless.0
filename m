Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56540 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753296AbeDRNQM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Apr 2018 09:16:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: govinds@codeaurora.org
Cc: Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        linux-wireless@vger.kernel.org, pillair@codeaurora.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v2 4/4] ath10k: Enable sta idle power save
References: <1523966821-21903-1-git-send-email-pillair@codeaurora.org>
        <1523966821-21903-5-git-send-email-pillair@codeaurora.org>
        <946e582c-2438-872b-eec8-25d9dcb994d9@dd-wrt.com>
        <7a06a34a5fcb97e07a8d79b4d689e781@codeaurora.org>
Date: Wed, 18 Apr 2018 16:16:07 +0300
In-Reply-To: <7a06a34a5fcb97e07a8d79b4d689e781@codeaurora.org>
        (govinds@codeaurora.org's message of "Wed, 18 Apr 2018 18:37:26
        +0530")
Message-ID: <87604oodt4.fsf@kamboji.qca.qualcomm.com> (sfid-20180418_151615_914242_826D67F1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(fixing top posting)

govinds@codeaurora.org writes:

> On 2018-04-18 12:36, Sebastian Gottschall wrote:
>> from my point of view powersave should be optional and not forced.
>>
>> consider :
>> iw dev <devname> set power_save on/off
>>
>> so there is already a config option made for that purpose,
>
> Thanks Sebastian for your review. Agree this should not be forced with
> in driver.
>
> I will check if i can set the idle ps at the end of
> ath10k_mac_vif_setup_ps by checking arvif->ps.
> I will update the patch accordingly.

So what power save is this exactly? I assumed it's some bus level power
save (turning of clocks etc) but is it actually 802.11 power save?

-- 
Kalle Valo
