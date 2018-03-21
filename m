Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.50.164]:26529 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752064AbeCUOuP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 10:50:15 -0400
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 09CA499E9C
        for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2018 09:02:08 -0500 (CDT)
Subject: Re: [PATCH] mac80211: aes-cmac: remove VLA usage
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180321134247.GA1275@embeddedgus>
 <1521640094.2645.29.camel@sipsolutions.net>
 <b367cf76-e6c5-3d6d-5d81-a68ae245e6b9@embeddedor.com>
 <1521640687.2645.30.camel@sipsolutions.net>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <ab698dc1-55bc-11db-893b-eb1d8a25400c@embeddedor.com> (sfid-20180321_155020_045525_CEE61CDC)
Date: Wed, 21 Mar 2018 09:02:06 -0500
MIME-Version: 1.0
In-Reply-To: <1521640687.2645.30.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/21/2018 08:58 AM, Johannes Berg wrote:
> On Wed, 2018-03-21 at 08:57 -0500, Gustavo A. R. Silva wrote:
>>
>> SHA_DESC_ON_STACK is currently being used in multiple places. But, yeah,
>> I think we can define multiple macros of the same kind and adjust to the
>> characteristics of each the component.
>>
>> How big do you think tfm can get?
> 
> I have no idea, I guess you'll have to take that with Herbert.
> 
> johannes
> 

I see. I'll contact him then.

Thanks for the feedback.
--
Gustavo
