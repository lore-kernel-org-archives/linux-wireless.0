Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53424 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752281AbeF1Ivv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Jun 2018 04:51:51 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Matthew Wilcox <willy@infradead.org>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the xarray tree with the wireless-drivers-next tree
References: <20180628145900.4ca1e648@canb.auug.org.au>
        <1530172269.4988.1.camel@sipsolutions.net>
Date: Thu, 28 Jun 2018 11:51:40 +0300
In-Reply-To: <1530172269.4988.1.camel@sipsolutions.net> (Johannes Berg's
        message of "Thu, 28 Jun 2018 09:51:09 +0200")
Message-ID: <87in63s38j.fsf@kamboji.qca.qualcomm.com> (sfid-20180628_105210_168969_033F012C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Thu, 2018-06-28 at 14:59 +1000, Stephen Rothwell wrote:
>> Hi all,
>> 
>> Today's linux-next merge of the xarray tree got a conflict in:
>> 
>>   lib/Kconfig.debug
>> 
>> between commit:
>> 
>>   0e2dc70e3d0d ("bitfield: add tests")
>> 
>> from the wireless-drivers-next tree and commit:
>> 
>>   d968f529e39f ("xarray: Add XArray load operation")
>> 
>> from the xarray tree.
>
> Thanks for the heads-up! Not really sure where/how we'll be able to get
> that resolved before it hits Linus, but as the conflict seems rather
> easy (overlapping additions), I guess it's not such a big deal.

Yeah, I would assume this is business as usual for Linus and we don't
need to do anything. But please do let me know if that's not the case.

-- 
Kalle Valo
