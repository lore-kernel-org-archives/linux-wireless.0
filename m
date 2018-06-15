Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:39800 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965126AbeFOASE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Jun 2018 20:18:04 -0400
Subject: Re: [PATCH v2] ath10k: Update the phymode along with bandwidth change
 request
To: Kalle Valo <kvalo@codeaurora.org>
References: <1528482759-12604-1-git-send-email-ryanhsu@codeaurora.org>
 <87h8m5ag8l.fsf@kamboji.qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        timur.kristof@gmail.com
From: Ryan Hsu <ryanhsu@codeaurora.org>
Message-ID: <4735b5f6-702c-d26e-a9d8-24f4c0e66a82@codeaurora.org> (sfid-20180615_021808_690368_B1A13E18)
Date: Thu, 14 Jun 2018 17:16:19 -0700
MIME-Version: 1.0
In-Reply-To: <87h8m5ag8l.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/14/2018 02:07 AM, Kalle Valo wrote:

> BTW, I don't recommend using "---" or similar delimeters in the actual
> commit log. Git uses that string as a separator between the commit log
> and actual patch and that broke my patchwork script. I fixed the commit
> log manually in the pending branch, and added Timur's Tested-by, please
> check (I hope I got UTF-8 correct!):
>
> https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=master-pending&id=5aee6aeda5dae74e1c79256fc1df2e7599038fa7
>

Thanks Kalle, patch looks good to me, will avoid use "---".

-- 
Ryan Hsu
