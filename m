Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.49.104]:49739 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751495AbdF1XUH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Jun 2017 19:20:07 -0400
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 885A615CE0
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jun 2017 17:57:53 -0500 (CDT)
Date: Wed, 28 Jun 2017 17:57:53 -0500
Message-ID: <20170628175753.Horde.jKsLaGOBj8-15rZyu1j0ooC@gator4166.hostgator.com> (sfid-20170629_012010_530443_905AE87F)
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: ti: wl18xx: add checks on wl18xx_top_reg_write() return value
References: <20170626230619.GA14831@embeddedgus>
 <20170628163844.56F26601EA@smtp.codeaurora.org>
In-Reply-To: <20170628163844.56F26601EA@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Quoting Kalle Valo <kvalo@codeaurora.org>:

> "Gustavo A. R. Silva" <garsilva@embeddedor.com> wrote:
>
>> Check return value from call to wl18xx_top_reg_write(),
>> so in case of error jump to goto label out and return.
>>
>> Also, remove unnecessary value check before goto label out.
>>
>> Addresses-Coverity-ID: 1226938
>> Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
>
> The prefix should be "wl18xx:", I'll fix that.
>

Thanks, Kalle.
--
Gustavo A. R. Silva
