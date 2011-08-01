Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64316 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1HATBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Aug 2011 15:01:30 -0400
Received: by ywn13 with SMTP id 13so903374ywn.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Aug 2011 12:01:30 -0700 (PDT)
Message-ID: <4E36F805.7050108@lwfinger.net> (sfid-20110801_210134_039494_9DCB9378)
Date: Mon, 01 Aug 2011 14:01:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Lubomir Schmidt <gentoo.lubomir@googlemail.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	'George0505' <george0505@realtek.com>
Subject: Re: Support for Realtek 8188RU Chipset in rtl8192cu driver?
References: <CAHFBKjfHfAvpxGhhvRFwni9EVXdSC3HA1WxMJRzVm9SxvowmWQ@mail.gmail.com>
In-Reply-To: <CAHFBKjfHfAvpxGhhvRFwni9EVXdSC3HA1WxMJRzVm9SxvowmWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/25/2011 06:47 AM, Lubomir Schmidt wrote:
> What distribution did you mean?
>
> The old AWUS036H had the Realtek 8187L, yes. Then there came out before nearly
> an year the AWUS036NH and the AWUS036NEH. Both base on the Ralink 3070L Chipset
> and have till today the best range of all devices on the market.
> Now Alfa release the AWUS036NHR with the Realtek 8188RU and the AWUS036NHA with
> an Atheros AR9271.
>
> Last year i helped to get support for the Ralink Chipsets in the 2800usb driver.
> I got white papers and so on from the chipsets and the driver developer could
> connect to an laptop running 24/7 and make tests with the device.
>
> How can i help to get support? What distribution did you prefere on the notebook
> to connect to?

When I looked at the driver, it turned out to be the driver for the RTL8192CU 
with new additional device IDs. Please try the attached patch for any 2.6.39 or 
later kernel. Meanwhile, I will see what other changes have been made to the driver.

===========================================================================

I hate to nag, but I cannot push this patch upstream and make it available to 
others until you tell me that it works.

Larry
