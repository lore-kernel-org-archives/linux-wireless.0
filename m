Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58629 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab1GYO7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 10:59:51 -0400
Received: by iyb12 with SMTP id 12so4695259iyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 07:59:51 -0700 (PDT)
Message-ID: <4E2D8478.4040701@lwfinger.net> (sfid-20110725_165955_275739_A18BB7C4)
Date: Mon, 25 Jul 2011 09:58:00 -0500
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

If you keep dropping the Cc'd recipients, I will not answer your Emails! Note, I 
also included linux-wireless here.

I do not care what distribution you use. I can use any. As the driver from the 
Realtek web site 
(ftp://WebUser:wK9xBuD5@202.134.71.21/cn/wlan/RTL8188RU_linux_v3.0.2164.20110715.zip) 
is only for kernel 2.6.38 or later, it would be better if I had a kernel that 
new; however, I could backport the system to an older one if necessary.

As I downloaded the Realtek driver while composing this Email, I need to look at 
the driver before making any commitment.

Larry


