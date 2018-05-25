Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.50.71]:31248 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S967453AbeEYSiZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 May 2018 14:38:25 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 5690B21CBE
        for <linux-wireless@vger.kernel.org>; Fri, 25 May 2018 13:14:07 -0500 (CDT)
Subject: Re: [PATCH] ath6kl: mark expected switch fall-throughs
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180524231322.GA22704@embeddedor.com>
 <060f93a0-7210-79b6-37a7-cd8900719d40@cogentembedded.com>
 <871sdzc16l.fsf@kamboji.qca.qualcomm.com>
 <e777af5c-8d56-aef7-a4b6-f93f12378049@embeddedor.com>
 <87k1rr8v3l.fsf@kamboji.qca.qualcomm.com>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <b43bfff8-889d-c167-a902-bc44518bf1f3@embeddedor.com> (sfid-20180525_203829_023684_85D70A58)
Date: Fri, 25 May 2018 13:14:03 -0500
MIME-Version: 1.0
In-Reply-To: <87k1rr8v3l.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/25/2018 01:10 PM, Kalle Valo wrote:
>>> Yeah, I was wondering the same. Was there a particular reason for this?
>>>
>>
>> Sometimes people use this style for a one-line code block.
>>
>> I can change it to the traditional style. No problem.
> 
> I would prefer that. So if you can send v2 that would be great.
> 

Yep. No problem. I'll send it shortly.

Thanks
--
Gustavo
