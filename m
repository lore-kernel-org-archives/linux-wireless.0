Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:34492 "EHLO
        mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752741AbdEDP1f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 May 2017 11:27:35 -0400
Received: by mail-io0-f176.google.com with SMTP id k91so26775714ioi.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 May 2017 08:27:35 -0700 (PDT)
Subject: Re: WARNING: CPU: 2 PID: 682 at net/wireless/util.c:1236
To: David Miller <davem@davemloft.net>
References: <240bae44-56e4-f342-0d1b-358a573e2eeb@kernel.dk>
 <20170504.112512.833061289089590605.davem@davemloft.net>
Cc: kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linuxwifi@intel.com,
        johannes.berg@intel.com
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <4ad7a627-62c7-be34-2dae-c54bb3ef0a15@kernel.dk> (sfid-20170504_172937_727985_DE7114A0)
Date: Thu, 4 May 2017 09:27:30 -0600
MIME-Version: 1.0
In-Reply-To: <20170504.112512.833061289089590605.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/04/2017 09:25 AM, David Miller wrote:
> From: Jens Axboe <axboe@kernel.dk>
> Date: Thu, 4 May 2017 09:23:36 -0600
> 
>> Running current -git on my laptop, and I see this spew every once
>> in a while. This is new, haven't seen it in 4.11 or previously. Driver
>> is iwlwifi:
> 
> Please try:
> 
> http://patchwork.ozlabs.org/patch/758364/

Will do, compiling...

-- 
Jens Axboe
