Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:35785 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdEDPkK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 11:40:10 -0400
Received: by mail-it0-f52.google.com with SMTP id c15so318808ith.0
        for <linux-wireless@vger.kernel.org>; Thu, 04 May 2017 08:40:10 -0700 (PDT)
Subject: Re: WARNING: CPU: 2 PID: 682 at net/wireless/util.c:1236
To: David Miller <davem@davemloft.net>
References: <240bae44-56e4-f342-0d1b-358a573e2eeb@kernel.dk>
 <20170504.112512.833061289089590605.davem@davemloft.net>
 <4ad7a627-62c7-be34-2dae-c54bb3ef0a15@kernel.dk>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linuxwifi@intel.com,
        johannes.berg@intel.com
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <b25325a9-ab93-1c57-3b59-2d52a76d279a@kernel.dk> (sfid-20170504_174118_120653_DEC5E392)
Date: Thu, 4 May 2017 09:40:08 -0600
MIME-Version: 1.0
In-Reply-To: <4ad7a627-62c7-be34-2dae-c54bb3ef0a15@kernel.dk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/04/2017 09:27 AM, Jens Axboe wrote:
> On 05/04/2017 09:25 AM, David Miller wrote:
>> From: Jens Axboe <axboe@kernel.dk>
>> Date: Thu, 4 May 2017 09:23:36 -0600
>>
>>> Running current -git on my laptop, and I see this spew every once
>>> in a while. This is new, haven't seen it in 4.11 or previously. Driver
>>> is iwlwifi:
>>
>> Please try:
>>
>> http://patchwork.ozlabs.org/patch/758364/
> 
> Will do, compiling...

Yep works, thanks.

-- 
Jens Axboe
