Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51726 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949Ab1HATux (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 15:50:53 -0400
Received: by wwe5 with SMTP id 5so5994067wwe.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Aug 2011 12:50:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E36F805.7050108@lwfinger.net>
References: <CAHFBKjfHfAvpxGhhvRFwni9EVXdSC3HA1WxMJRzVm9SxvowmWQ@mail.gmail.com>
	<4E36F805.7050108@lwfinger.net>
Date: Mon, 1 Aug 2011 21:50:51 +0200
Message-ID: <CAHFBKjcwfGT2JUXE68PHarzP6azF+yaZYtVjoxHUao35RJAAGg@mail.gmail.com> (sfid-20110801_215056_284275_7FA29232)
Subject: Re: Support for Realtek 8188RU Chipset in rtl8192cu driver?
From: Lubomir Schmidt <gentoo.lubomir@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, george0505@realtek.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was not in Germany for some days and had no time. I will test that
next hours. Sorry for waiting.

2011/8/1 Larry Finger <Larry.Finger@lwfinger.net>:
> On 07/25/2011 06:47 AM, Lubomir Schmidt wrote:
>>
>> What distribution did you mean?
>>
>> The old AWUS036H had the Realtek 8187L, yes. Then there came out before
>> nearly
>> an year the AWUS036NH and the AWUS036NEH. Both base on the Ralink 3070L
>> Chipset
>> and have till today the best range of all devices on the market.
>> Now Alfa release the AWUS036NHR with the Realtek 8188RU and the AWUS036NHA
>> with
>> an Atheros AR9271.
>>
>> Last year i helped to get support for the Ralink Chipsets in the 2800usb
>> driver.
>> I got white papers and so on from the chipsets and the driver developer
>> could
>> connect to an laptop running 24/7 and make tests with the device.
>>
>> How can i help to get support? What distribution did you prefere on the
>> notebook
>> to connect to?
>
> When I looked at the driver, it turned out to be the driver for the
> RTL8192CU with new additional device IDs. Please try the attached patch for
> any 2.6.39 or later kernel. Meanwhile, I will see what other changes have
> been made to the driver.
>
> ===========================================================================
>
> I hate to nag, but I cannot push this patch upstream and make it available
> to others until you tell me that it works.
>
> Larry
>
