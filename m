Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:56762 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754056AbdEDP7b (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 11:59:31 -0400
Date: Thu, 04 May 2017 11:59:27 -0400 (EDT)
Message-Id: <20170504.115927.311620488504377288.davem@davemloft.net> (sfid-20170504_180015_518214_26D24DB4)
To: axboe@kernel.dk
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linuxwifi@intel.com,
        johannes.berg@intel.com
Subject: Re: WARNING: CPU: 2 PID: 682 at net/wireless/util.c:1236
From: David Miller <davem@davemloft.net>
In-Reply-To: <b25325a9-ab93-1c57-3b59-2d52a76d279a@kernel.dk>
References: <20170504.112512.833061289089590605.davem@davemloft.net>
        <4ad7a627-62c7-be34-2dae-c54bb3ef0a15@kernel.dk>
        <b25325a9-ab93-1c57-3b59-2d52a76d279a@kernel.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 4 May 2017 09:40:08 -0600

> On 05/04/2017 09:27 AM, Jens Axboe wrote:
>> On 05/04/2017 09:25 AM, David Miller wrote:
>>> From: Jens Axboe <axboe@kernel.dk>
>>> Date: Thu, 4 May 2017 09:23:36 -0600
>>>
>>>> Running current -git on my laptop, and I see this spew every once
>>>> in a while. This is new, haven't seen it in 4.11 or previously. Driver
>>>> is iwlwifi:
>>>
>>> Please try:
>>>
>>> http://patchwork.ozlabs.org/patch/758364/
>> 
>> Will do, compiling...
> 
> Yep works, thanks.

Thanks for testing.
