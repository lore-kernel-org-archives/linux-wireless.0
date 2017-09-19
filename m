Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44522 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750948AbdISOaM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Sep 2017 10:30:12 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ganapathi Bhat <gbhat@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Brian Norris" <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>
Subject: Re: [PATCH 2/2] mwifiex: use get_random_mask_addr() helper
References: <1505720537-13362-1-git-send-email-gbhat@marvell.com>
        <87o9q8kuy4.fsf@purkki.adurom.net>
        <3f3f5c9672a5421db05337a00d9578f2@SC-EXCH02.marvell.com>
Date: Tue, 19 Sep 2017 17:30:06 +0300
In-Reply-To: <3f3f5c9672a5421db05337a00d9578f2@SC-EXCH02.marvell.com>
        (Ganapathi Bhat's message of "Mon, 18 Sep 2017 14:13:41 +0000")
Message-ID: <87tvzyahht.fsf@kamboji.qca.qualcomm.com> (sfid-20170919_163015_400027_D455B000)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ganapathi Bhat <gbhat@marvell.com> writes:

> Hi Kalle,
>> 
>> > Avoid calculating random MAC address in driver. Instead make use of
>> > 'get_random_mask_addr()' function.
>> >
>> > Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
>> 
>> I don't see 1/2 anywhere. Did it get lost?
>
> Actually there is no 1/2. What I did is: 'git send-email'; CTRL + C
> (to correct a typo); and then tried sending it again. I think that
> created some problem here. Kindly let me know how to proceed.

Ok. I'll wait for review comments and if all goes well I'll apply it in
few days.

-- 
Kalle Valo
