Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56030 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754379AbeAIPFa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 10:05:30 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [v2,01/10] qtnfmac: check that MAC exists in regulatory notifier
References: <20171219112856.22463-2-sergey.matyukevich.os@quantenna.com>
        <20180109121247.C95116081B@smtp.codeaurora.org>
        <20180109130951.2vowioqa3vcwnqv2@bars>
Date: Tue, 09 Jan 2018 17:05:26 +0200
In-Reply-To: <20180109130951.2vowioqa3vcwnqv2@bars> (Sergey Matyukevich's
        message of "Tue, 9 Jan 2018 16:09:53 +0300")
Message-ID: <87incbysw9.fsf@kamboji.qca.qualcomm.com> (sfid-20180109_160536_157668_7CE687E9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Thanks Kalle,
>
>> > It is possible that regulatory notifier is called before MAC data
>> > was allocated. We need to verify that MAC data exists before trying
>> > to send a regulatory change event.
>> >
>> > Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
>> 
>> 10 patches applied to wireless-drivers-next.git, thanks.
>> 
>> 4fd045cdb239 qtnfmac: check that MAC exists in regulatory notifier
>> 5bf374ab91ad qtnfmac: pass complete channel data between driver and firmware
>> b05ee456fd21 qtnfmac: add support for radar detection and CAC
>> e6ef8cd05145 qtnfmac: change default interface mode from AP to STA
>> e6e594aff26a qtnfmac: check for passed channel being NULL in MGMT_TX command
>> fbad963a28e4 qtnfmac: fix rssi data passed to wireless core
>> 9cbd599966d8 qtnfmac: fill wiphy's extended capabilities
>> 4d2a7a1cfa68 qtnfmac: modify GET_STA_STATS cmd format for back/forward compatibility
>> 7a4d3a3bc84e qtnfmac: keeping track of "generation" for STA info
>> f1398fd2dd8c qtnfmac: support MAC address based access control
>
> Just to understand the timelines... Could you please clarify if these patches
> are still going to make it into 4.16 merge window ?

They should, but of course I can't promise anything.

My deadline is that when merge window opens the patches need to be in
net-next. You can follow the predictions for the schedule here:

http://phb-crystal-ball.org/

-- 
Kalle Valo
