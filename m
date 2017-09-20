Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59626 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751561AbdITLnM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Sep 2017 07:43:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Xinming Hu <huxm@marvell.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Brian Norris <briannorris@google.com>,
        Dmitry Torokhov <dtor@google.com>,
        "rajatja\@google.com" <rajatja@google.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        Tim Song <songtao@marvell.com>, Cathy Luo <cluo@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: [PATCH] mwifiex: add device specific ioctl handler
References: <429692343ed64d759eef2aa014a87fbb@SC-EXCH02.marvell.com>
Date: Wed, 20 Sep 2017 14:43:07 +0300
In-Reply-To: <429692343ed64d759eef2aa014a87fbb@SC-EXCH02.marvell.com> (Xinming
        Hu's message of "Wed, 20 Sep 2017 10:04:22 +0000")
Message-ID: <87efr1a94k.fsf@kamboji.qca.qualcomm.com> (sfid-20170920_134315_954446_DD456AD8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xinming Hu <huxm@marvell.com> writes:

>> You could look at
>> nl80211 vendor commands, but that is also under scrutiny if common wifi
>> functionality is provided by it. I am pretty sure Kalle has his ideas about this :-)
>> 
>
> Yes, the new utility should use nl80211 interface.
> But we have lots of legacy utility based on ioctl, it will be helpful
> to reduce massive work on refactoring.

That's not an excuse to implement bad interfaces. It's not really that
hard to convert ioctl based tools to use nl80211 testmode command, I
even have myself done that.

-- 
Kalle Valo
