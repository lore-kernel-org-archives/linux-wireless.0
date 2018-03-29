Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36774 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751146AbeC2Exb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Mar 2018 00:53:31 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: merez@codeaurora.org
Cc: Colin King <colin.king@canonical.com>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] wil6210: fix potential null dereference of ndev before null check
References: <20180328174027.31551-1-colin.king@canonical.com>
        <49ef31bc36217349a4801dc2eba4735c@codeaurora.org>
Date: Thu, 29 Mar 2018 07:53:25 +0300
In-Reply-To: <49ef31bc36217349a4801dc2eba4735c@codeaurora.org>
        (merez@codeaurora.org's message of "Wed, 28 Mar 2018 20:46:44 +0300")
Message-ID: <87bmf7mqii.fsf@kamboji.qca.qualcomm.com> (sfid-20180329_065352_854878_EB7B3539)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

merez@codeaurora.org writes:

> On 2018-03-28 20:40, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> The pointer ndev is being dereferenced before it is being null checked,
>> hence there is a potential null pointer deference. Fix this by only
>> dereferencing ndev after it has been null checked
>>
>> Detected by CoverityScan, CID#1467010 ("Dereference before null check")
>>
>> Fixes: e00243fab84b ("wil6210: infrastructure for multiple virtual
>> interfaces")
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>

[...]

> Reviewed-by: Maya Erez <merez@codeaurora.org>

Maya, as you are the wil6210 maintainer you can actually use Acked-by
instead of Reviewed-by. Not that it really matters which one you use,
both of them indicate me that you have checked and agree the patch, but
wanted to point out this anyway :)

-- 
Kalle Valo
