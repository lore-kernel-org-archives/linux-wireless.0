Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.13]:55243 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752484AbdGDP7I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Jul 2017 11:59:08 -0400
Subject: Re: [PATCH] rtl8723bs: fix build when DEBUG_RTL871X is defined
To: Kalle Valo <kvalo@codeaurora.org>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
References: <20170703122733.28512-1-sassmann@kpanic.de>
 <874lus31qr.fsf@purkki.adurom.net>
From: Stefan Assmann <sassmann@kpanic.de>
Message-ID: <49f8f9e7-54cf-29d3-71b3-da3006a7cd49@kpanic.de> (sfid-20170704_175923_906482_23251F78)
Date: Tue, 4 Jul 2017 17:58:58 +0200
MIME-Version: 1.0
In-Reply-To: <874lus31qr.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04.07.2017 13:01, Kalle Valo wrote:
> Stefan Assmann <sassmann@kpanic.de> writes:
> 
>> Defining DEBUG_RTL871X in rtw_debug.h causes the following compile error:
>>   CC [M]  drivers/staging/rtl8723bs/core/rtw_mlme.o
>> In file included from drivers/staging/rtl8723bs/core/rtw_mlme.c:18:0:
>> drivers/staging/rtl8723bs/core/rtw_mlme.c: In function ‘rtw_restruct_sec_ie’:
>> drivers/staging/rtl8723bs/core/rtw_mlme.c:2502:19: error: ‘ndissecuritytype’ undeclared (first use in thisfunction)
>>
>> Remove the no longer existing parameter.
>>
>> Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
> 
> Please use prefix "staging:" for staging patches.
> 

OK, will keep that in mind next time.
Thanks!

  Stefan
