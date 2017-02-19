Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36769 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751382AbdBSQav (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 11:30:51 -0500
Received: by mail-lf0-f66.google.com with SMTP id o140so775275lff.3
        for <linux-wireless@vger.kernel.org>; Sun, 19 Feb 2017 08:30:38 -0800 (PST)
Subject: Re: [RFC v3 0/8] ath10k sdio support
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
References: <7b204d34-b791-ea78-cf4e-90e8fe1b79fb@gmail.com>
 <5a3ad65a-8cc0-ab1a-dc95-a5fd31035bd7@gmail.com>
 <87y3x2ff7y.fsf@kamboji.qca.qualcomm.com>
Cc: "Hsu, Ryan" <ryanhsu@qca.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <c004b837-ccb6-f87b-ce49-bd685f9272c1@gmail.com> (sfid-20170219_173055_964137_AF5221D5)
Date: Sun, 19 Feb 2017 17:30:36 +0100
MIME-Version: 1.0
In-Reply-To: <87y3x2ff7y.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 2017-02-19 15:05, Valo, Kalle wrote:
> Erik Stromdahl <erik.stromdahl@gmail.com> writes:
>
>> I just noticed that Ryan Hsu submitted two patches containing similar
>> functionality to what I have in my tree on github. They have not been
>> integrated in the ath master yet, but they have been added to master-pending.
>>
>> Below are the commits I am talking about
>>
>> bc1054a15be3c962c83aa22476a3e9c1266da792 ath10k: improve the firmware
>> download time for QCA9377
>> db5af2a25bd8c1410ec4456d1d4f4e6ded2649ca ath10k: improve the firmware
>> download time for QCA6174
>>
>> Since some of my patches overlap with these I think it would be best if
>> I add these to my tree and rewrite my patches.
>>
>> If they haven't made it into master before I submit my updated patch series
>> I will include them in my set.
>>
>> Is this OK?
>>
>> If they will be added to master soon there is no issue since I will of course
>> rebase to the latest ath-YYYYMMDDHHmm before I submit anything.
>
> That's ok, just mention this in the cover letter.
>
> Even better is that if you can use master-pending from ath.git as the
> baseline (compared to the master branch normally recommended), Ryan's
> patches are there now. That way you don't need to apply anything extra
> to your tree. But I'm hoping to apply Ryan's patches soon anyway.
>

Ok, I'll make it so.
