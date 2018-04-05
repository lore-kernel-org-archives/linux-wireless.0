Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([192.185.198.13]:22096 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750726AbeDEQyD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 12:54:03 -0400
Received: from cm10.websitewelcome.com (cm10.websitewelcome.com [100.42.49.4])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id A3CD241655EF3
        for <linux-wireless@vger.kernel.org>; Thu,  5 Apr 2018 11:33:17 -0500 (CDT)
Subject: Re: [PATCH] qtnfmac: pearl: pcie: fix memory leak in
 qtnf_fw_work_handler
To: Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180405154949.GA32223@embeddedor.com>
 <20180405163100.cuaedftds47pxdrn@bars>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <123880c0-25f0-f53e-8c75-2a01c2756b4e@embeddedor.com> (sfid-20180405_185406_695093_A032EEAC)
Date: Thu, 5 Apr 2018 11:33:15 -0500
MIME-Version: 1.0
In-Reply-To: <20180405163100.cuaedftds47pxdrn@bars>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sergey,

On 04/05/2018 11:31 AM, Sergey Matyukevich wrote:
> Hello Gustavo,
> 
>> In case memory resources for fw were succesfully allocated, release
>> them before jumping to fw_load_fail.
>>
>> Addresses-Coverity-ID: 1466092 ("Resource leak")
>> Fixes: c3b2f7ca4186 ("qtnfmac: implement asynchronous firmware loading")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
>> ---
>>   drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 4 ++++
>>   1 file changed, 4 insertions(+)
> 
> Thanks for the patch!
> 

Glad to help. :)

> Reviewed-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> 

Thanks
--
Gustavo
