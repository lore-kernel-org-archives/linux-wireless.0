Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34376 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbeIKTrO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Sep 2018 15:47:14 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Brian Norris <briannorris@chromium.org>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Zhi Chen <zhichen@codeaurora.org>,
        ath10k@lists.infradead.org
Subject: Re: [for -stable] commit "c82919888064 ath10k: fix scan crash due to incorrect length calculation"
References: <20180906213620.GA72542@ban.mtv.corp.google.com>
Date: Tue, 11 Sep 2018 17:47:31 +0300
In-Reply-To: <20180906213620.GA72542@ban.mtv.corp.google.com> (Brian Norris's
        message of "Thu, 6 Sep 2018 14:36:22 -0700")
Message-ID: <87lg88t7jw.fsf@codeaurora.org> (sfid-20180911_164803_405952_A6C7CDAE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Norris <briannorris@chromium.org> writes:

> Hi Greg / stable maintainer(s),
>
> IIUC, this commit is a good candidate for -stable. I just hit the bug on
> 4.14, because of new vendor firmware that noticed the mismatched length
> (an internal "assert"), but it seems like this is equally problematic
> from the kernel side for as long as this code existed [1]:
>
> commit c8291988806407e02a01b4b15b4504eafbcc04e0
> Author: Zhi Chen <zhichen@codeaurora.org>
> Date:   Mon Jun 18 17:00:39 2018 +0300
>
>     ath10k: fix scan crash due to incorrect length calculation
>
> Thanks,
> Brian
>
> [1] I guess that would be:
>
> Fixes: ca996ec56608 ("ath10k: implement wmi-tlv backend")
>
> which was in v4.0.

FWIW:

Acked-by: Kalle Valo <kvalo@codeaurora.org>

Thanks Brian!

-- 
Kalle Valo
