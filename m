Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57362 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751568AbdITLi4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 07:38:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Xinming Hu <huxinming820@gmail.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>, rajatja@google.com,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxm@marvell.com>
Subject: Re: [PATCH] mwifiex: add device specific ioctl handler
References: <1505889853-20493-1-git-send-email-huxinming820@gmail.com>
        <59C22949.9030304@broadcom.com>
Date: Wed, 20 Sep 2017 14:38:49 +0300
In-Reply-To: <59C22949.9030304@broadcom.com> (Arend van Spriel's message of
        "Wed, 20 Sep 2017 10:39:37 +0200")
Message-ID: <87ingda9bq.fsf@kamboji.qca.qualcomm.com> (sfid-20170920_133900_873319_4E92BA88)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 9/20/2017 8:44 AM, Xinming Hu wrote:
>> From: Xinming Hu <huxm@marvell.com>
>>
>> Add net_dev ndo_do_ioctl handler, which could be used for
>> downloading host command by utility in manufactory test
>
> Not sure if we want ioctls in upstream wireless drivers.

Yeah, patches adding ioctls to wireless drivers are automatically
rejected.

> You could look at nl80211 vendor commands, but that is also under
> scrutiny if common wifi functionality is provided by it. I am pretty
> sure Kalle has his ideas about this :-)

For manufacturing tests we have nl80211 testmode command and event.
There are upstream drivers already using it so you even have examples.

-- 
Kalle Valo
