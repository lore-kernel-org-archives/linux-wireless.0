Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36065 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbdBSOCI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 09:02:08 -0500
Received: by mail-lf0-f66.google.com with SMTP id o140so600216lff.3
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2017 06:02:07 -0800 (PST)
Subject: Re: [RFC v3 0/8] ath10k sdio support
References: <7b204d34-b791-ea78-cf4e-90e8fe1b79fb@gmail.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: ryanhsu@qca.qualcomm.com, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <5a3ad65a-8cc0-ab1a-dc95-a5fd31035bd7@gmail.com> (sfid-20170219_150213_269061_561E70ED)
Date: Sun, 19 Feb 2017 14:52:14 +0100
MIME-Version: 1.0
In-Reply-To: <7b204d34-b791-ea78-cf4e-90e8fe1b79fb@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hej,

I just noticed that Ryan Hsu submitted two patches containing similar
functionality to what I have in my tree on github. They have not been
integrated in the ath master yet, but they have been added to master-pending.

Below are the commits I am talking about

bc1054a15be3c962c83aa22476a3e9c1266da792 ath10k: improve the firmware download time for QCA9377
db5af2a25bd8c1410ec4456d1d4f4e6ded2649ca ath10k: improve the firmware download time for QCA6174

Since some of my patches overlap with these I think it would be best if
I add these to my tree and rewrite my patches.

If they haven't made it into master before I submit my updated patch series
I will include them in my set.

Is this OK?

If they will be added to master soon there is no issue since I will of course
rebase to the latest ath-YYYYMMDDHHmm before I submit anything.

/Erik

On 2017-02-19 00:57, Valo, Kalle wrote:
> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>
>> I was actually about to email you about this.
>>
>> I have made a few more updates to the sdio code so I think it would be
>> best if I could submit a new series of patches based on this code (v4).
>>
>> Then you can tweak it (v5).
>>
>> It is only minor updates to the HIF layer (added QCA9377 support) and
>> a setup of some pll registers.
>
> Ok, that sounds good. I'll wait for v4.
>
>> btw, should I still mark them as RFC or should it be PATCH this time?
>>
>> If I go for PATCH, should the version be v4 or should I start from v1?
>
> v4 would be fine. Thanks.
>
