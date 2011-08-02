Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64873 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab1HBUWQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2011 16:22:16 -0400
Received: by wyg8 with SMTP id 8so95544wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2011 13:22:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAHFBKjcwfGT2JUXE68PHarzP6azF+yaZYtVjoxHUao35RJAAGg@mail.gmail.com>
References: <CAHFBKjfHfAvpxGhhvRFwni9EVXdSC3HA1WxMJRzVm9SxvowmWQ@mail.gmail.com>
	<4E36F805.7050108@lwfinger.net>
	<CAHFBKjcwfGT2JUXE68PHarzP6azF+yaZYtVjoxHUao35RJAAGg@mail.gmail.com>
Date: Tue, 2 Aug 2011 22:22:13 +0200
Message-ID: <CAHFBKjf6hZKsB_5bWoSECvtXNEB5rPx_v_EAOGrx5abdSPGPjg@mail.gmail.com> (sfid-20110802_222219_387525_2AF7256D)
Subject: Re: Support for Realtek 8188RU Chipset in rtl8192cu driver?
From: Lubomir Schmidt <gentoo.lubomir@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, george0505@realtek.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yesterday my HDD i took to test everything with dies and i have to get
an other one...

I added the two lines with the usb id's and the driver load fine and
see networks. Also monitor mode and injection is working fine.
The build in networkmanager from ubuntu 11.10 Alpha 2(with an "apt-get
update && apt-get upgrade") does not connect to the wpa2 network i use
at home. I think the problem would be the networkmanager. I just
wonder why the adapter is named now "Obda ALFA AWUS036NHR" - why obda
and what is obda?

Thanks for adding the usb-id's and the name into the driver :)

2011/8/1 Lubomir Schmidt <gentoo.lubomir@googlemail.com>:
> I was not in Germany for some days and had no time. I will test that
> next hours. Sorry for waiting.
>
> 2011/8/1 Larry Finger <Larry.Finger@lwfinger.net>:
>> On 07/25/2011 06:47 AM, Lubomir Schmidt wrote:
>>>
>>> What distribution did you mean?
>>>
>>> The old AWUS036H had the Realtek 8187L, yes. Then there came out before
>>> nearly
>>> an year the AWUS036NH and the AWUS036NEH. Both base on the Ralink 3070L
>>> Chipset
>>> and have till today the best range of all devices on the market.
>>> Now Alfa release the AWUS036NHR with the Realtek 8188RU and the AWUS036NHA
>>> with
>>> an Atheros AR9271.
>>>
>>> Last year i helped to get support for the Ralink Chipsets in the 2800usb
>>> driver.
>>> I got white papers and so on from the chipsets and the driver developer
>>> could
>>> connect to an laptop running 24/7 and make tests with the device.
>>>
>>> How can i help to get support? What distribution did you prefere on the
>>> notebook
>>> to connect to?
>>
>> When I looked at the driver, it turned out to be the driver for the
>> RTL8192CU with new additional device IDs. Please try the attached patch for
>> any 2.6.39 or later kernel. Meanwhile, I will see what other changes have
>> been made to the driver.
>>
>> ===========================================================================
>>
>> I hate to nag, but I cannot push this patch upstream and make it available
>> to others until you tell me that it works.
>>
>> Larry
>>
>
