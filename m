Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43902 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751304AbdEIPEZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 11:04:25 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
        Dmitrii Lebed <dlebed@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Bindu Therthala <btherthala@quantenna.com>,
        Huizhao Wang <hwang@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH v5] qtnfmac: announcement of new FullMAC driver for Quantenna chipsets
References: <1489262657-8191-1-git-send-email-igor.mitsyanko.os@quantenna.com>
        <c80e4171-d433-6f31-f279-94aa5d238dc7@quantenna.com>
Date: Tue, 09 May 2017 18:04:19 +0300
In-Reply-To: <c80e4171-d433-6f31-f279-94aa5d238dc7@quantenna.com> (Igor
        Mitsyanko's message of "Fri, 28 Apr 2017 00:22:40 -0700")
Message-ID: <878tm69imk.fsf@purkki.adurom.net> (sfid-20170509_170458_574918_36877C51)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Igor Mitsyanko <igor.mitsyanko.os@quantenna.com> writes:

> On 03/11/2017 12:04 PM, Igor Mitsyanko wrote:
>> This patch adds support for new FullMAC WiFi driver for Quantenna
>> QSR10G chipsets.
>
> Hi all,
> this patch is pending for a while now, does it require more work
> (except for what Christian mentioned)?

I just did a diff between v4 and v5 and looking good at least to me. Do
others have more comments/concerns?

Now would be a very good time to submit a new driver as we are getting
close to the rc1 release. This way it gets plenty of testing time in
linux-next. So sooner you can submit v6 the better.

>> QSR10G (aka Pearl) is Quantenna's 8x8, 160M, 11ac offering.
>> QSR10G supports 2 simultaneous WMACs - one 5G and one 2G.
>> 5G WMAC supports 160M, 8x8 configuration. FW supports
>> up to 8 concurrent virtual interfaces on each WMAC.
>>
>> Patch introduces 2 new drivers:
>> - qtnfmac.ko for interfacing with kernel wireless core
>> - qtnfmac_pearl_pcie.ko for interfacing with hardware over PCIe interface

Please mention in the commit log also what modes (AP, managed, monitor
etc) are supported.

But PLEASE edit your quotes, the insane 8000 line quote makes my use of
patchwork[1] difficult:

https://patchwork.kernel.org/patch/9619075/

[1] And I do almost all of my maintainer work via patchwork so this
    habit of not editing quotes is a big hindrance for me. And
    unfortunately it's getting more popular :(

-- 
Kalle Valo
