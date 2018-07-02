Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway36.websitewelcome.com ([50.116.125.2]:35787 "EHLO
        gateway36.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751581AbeGBNtZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jul 2018 09:49:25 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway36.websitewelcome.com (Postfix) with ESMTP id 6D611401015EA
        for <linux-wireless@vger.kernel.org>; Mon,  2 Jul 2018 07:02:45 -0500 (CDT)
Subject: Re: [PATCH] wlcore: Fix memory leak in
 wlcore_cmd_wait_for_event_or_timeout
To: Tony Lindgren <tony@atomide.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180628130809.GA8147@embeddedor.com>
 <20180702113008.GV112168@atomide.com>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <f6b4f549-1b14-4212-d81b-1201f0ce6b3d@embeddedor.com> (sfid-20180702_154930_152655_41113C46)
Date: Mon, 2 Jul 2018 08:01:32 -0500
MIME-Version: 1.0
In-Reply-To: <20180702113008.GV112168@atomide.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07/02/2018 06:30 AM, Tony Lindgren wrote:
> * Gustavo A. R. Silva <gustavo@embeddedor.com> [180628 13:11]:
>> In case memory resources for *events_vector* were allocated, release
>> them before return.
>>
>> Addresses-Coverity-ID: 1470194 ("Resource leak")
>> Fixes: 4ec7cece87b3 ("wlcore: Add missing PM call for wlcore_cmd_wait_for_event_or_timeout()")
>> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> 
> Thanks for catching this one:
> 
> Acked-by: Tony Lindgren <tony@atomide.com>
> 

Glad to help. :)

Thanks
--
Gustavo
