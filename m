Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:38927 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809Ab2LMP15 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 10:27:57 -0500
Received: by mail-qa0-f53.google.com with SMTP id a19so3105911qad.19
        for <linux-wireless@vger.kernel.org>; Thu, 13 Dec 2012 07:27:57 -0800 (PST)
Message-ID: <50C9F3FA.6000906@gmail.com> (sfid-20121213_162802_568366_86DA4A36)
Date: Thu, 13 Dec 2012 10:27:54 -0500
From: Jonathan Bither <jonbither@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: Yogesh Ashok Powar <yogeshp@marvell.com>,
	linux-wireless@vger.kernel.org
Subject: Re: ACS and Hostapd
References: <20121123081444.GA6028@markyou.marvell.com> <20121211194249.GT15974@pogo>
In-Reply-To: <20121211194249.GT15974@pogo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/11/2012 02:42 PM, Luis R. Rodriguez wrote:
> On Fri, Nov 23, 2012 at 01:44:51PM +0530, Yogesh Ashok Powar wrote:
>> Hi Luis,
>>
>> I was looking at your patches on the linux-wireless mailing list
>> regarding ACS feature addition in hostapd.
>>
>> It is seen that you went till v8 patches and still the patches are not
>> seen upstream?
> Correct.
>
>> Is there any specific reason for this patches not being accepted?
> It didn't get good test coverage and by the time I got results from Jouni
> on his test I already lost interest on the code. If anyone wants to work
> on it and enhance it feel free to do so.
>
>> I am refering http://marc.info/?l=linux-wireless&m=131257363303693 seems
>> like all in one patch. But I have trouble finding correct git base for
>> it; since patch doens't apply cleanly even when I take hostap.git back
>> to Jul end of 2011. For v7, 1 through 3 apply cleanly but not 4th.
>>
>> Or I am I looking at some wrong hostapd git?
> It should have been the same date / tag around when I submitted it. Sorry
> I do not recall the exact commit.
>
>    Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hello Yogesh,
     I myself was curious about the status of ACS. Thank you for 
following up about it. I have interest in this functionality and I would 
be happy to help test and assist with the implementation. I have devices 
which use ath5k, ath9k, and some misc broadcom chips.

Thanks,
Jonathan Bither
