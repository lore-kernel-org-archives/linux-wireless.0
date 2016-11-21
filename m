Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hupie.dyndns.org ([80.101.237.101]:59929 "EHLO hupie.dyndns.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752318AbcKUJP2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Nov 2016 04:15:28 -0500
Subject: Re: [ath9k-devel] [RFC v2 2/2] ath9k: Reset chip on potential deaf
 state
To: Sven Eckelmann <sven.eckelmann@open-mesh.com>
References: <20161117083614.19188-1-sven.eckelmann@open-mesh.com>
 <20161117083614.19188-2-sven.eckelmann@open-mesh.com>
 <d23407cb-a1c0-860a-3436-5e72402a080b@hupie.com>
 <2358985.PI5q6nxgha@bentobox>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com,
        Simon Wunderlich <simon.wunderlich@open-mesh.com>
From: Ferry Huberts <mailings@hupie.com>
Message-ID: <e5b088be-c0e5-e749-6696-c407abb614a7@hupie.com> (sfid-20161121_101531_357483_1538269E)
Date: Mon, 21 Nov 2016 10:15:25 +0100
MIME-Version: 1.0
In-Reply-To: <2358985.PI5q6nxgha@bentobox>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 21/11/16 10:10, Sven Eckelmann wrote:
> On Montag, 21. November 2016 10:07:43 CET Ferry Huberts wrote:
> [...]
>>> v2:
>>>  - reduce amount of possible goto-raptor attacks by one (thanks Kalle Valo)
>>>
>>> This problem was discovered in mesh setups. It was noticed that some nodes
>>
>>
>> What kind of setup?
>> Using 802.11s?
>
> Unencrypted IBSS.
>

ok, thanks. that is different then.

I _can_ tell you that using the high priority queue (EF class traffic) 
seems to somehow 'unwedge' the chip during/after rekeying. Still have to 
verify this again, but that is what I saw last week.
