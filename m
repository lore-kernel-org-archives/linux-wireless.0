Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60056 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729044AbeHWOhB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Aug 2018 10:37:01 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <nicolas.ferre@microchip.com>,
        <ganesh.krishna@microchip.com>, <adham.abozaeid@microchip.com>,
        <aditya.shankar@microchip.com>
Subject: Re: feedback on mainlining wilc1000 staging driver
References: <20180816015243.545cd009@ajaysk-VirtualBox>
        <87sh3etwoj.fsf@purkki.adurom.net> <87o9e2twe9.fsf@purkki.adurom.net>
        <20180817100233.7f1c00d9@ajaysk-VirtualBox>
        <8736vdv3f5.fsf@kamboji.qca.qualcomm.com>
        <5B768574.6060009@broadcom.com>
        <87y3d5tmod.fsf@kamboji.qca.qualcomm.com>
        <20180817143911.5f0ee545@ajaysk-VirtualBox>
Date: Thu, 23 Aug 2018 14:07:45 +0300
In-Reply-To: <20180817143911.5f0ee545@ajaysk-VirtualBox> (Ajay Singh's message
        of "Fri, 17 Aug 2018 14:39:11 +0530")
Message-ID: <87r2ipnxxa.fsf@kamboji.qca.qualcomm.com> (sfid-20180823_130755_773206_C7678743)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ajay Singh <ajay.kathat@microchip.com> writes:

>> >>> We need help to review and identify if there are any pending items
>> >>> for wilc1000 driver, so we can address those issues and make it
>> >>> ready to move to the wireless subsystem.  
>> >>
>> >> I think the best way to get that forward is to submit a patch (or
>> >> patchset) to linux-wireless, that's the easiest for reviewers.  
>> >
>> > For brcm80211 drivers we used a single patch introducing it under
>> > the wireless drivers folder. Because it was quite a sizable patch we
>> > parked it on the wireless wiki page. Had a few iterations doing it
>> > like that.  
>> 
>> Another option is to split it so that there's one patch per file,
>> should be even pretty easy to automate that. It's just so much easier
>> to comment on a patch submitted by email compared to the reviewer
>> manually copying code and then commenting it, yuck.
>> 
>
> Sure. I will prepare a patch per file send for review as its easy to
> review.
>
> As Greg suggested, I will wait for the merge window to close and
> after completing pending patches to staging, I will start the review.
>
> For my understanding, the patches for review will be based on
> wireless-testing branch.

In this case I think wireless-drivers-next is the safest choise,
wireless-testing also has other trees which might cause conflicts etc.

> And the fixes will be submitted to staging tree in parallel. right?

I don't think the fixes matter in the initial review. So yeah, Greg can
apply fixes as he sees fit for now. At some point we need to do a cut
off period and freeze the driver for the last review round before it
will be (hopefully) moved to drivers/net/wireless, but let's coordinate
with Greg once we are at that stage.

-- 
Kalle Valo
