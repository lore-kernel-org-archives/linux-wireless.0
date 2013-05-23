Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f66.google.com ([209.85.160.66]:48298 "EHLO
	mail-pb0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab3EWMVW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 08:21:22 -0400
Received: by mail-pb0-f66.google.com with SMTP id md12so1180523pbc.9
        for <linux-wireless@vger.kernel.org>; Thu, 23 May 2013 05:21:22 -0700 (PDT)
Message-ID: <519E09BE.6060802@pdm.ac.in> (sfid-20130523_142126_182888_7B632D51)
Date: Thu, 23 May 2013 17:51:18 +0530
From: Mohit <mt1037ag11@pdm.ac.in>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Ralink RT3290 proprietary drivers causing kernel panic
References: <519D0D44.1040901@pdm.ac.in> <14ECE0C4-AE53-4CC5-B6B6-42930C2C26FB@gmail.com>
In-Reply-To: <14ECE0C4-AE53-4CC5-B6B6-42930C2C26FB@gmail.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 23 May 2013 01:25 AM, Gertjan van Wingerde wrote:
> Hi Mohit,
>
> Sent from my iPad
>
> On 22 mei 2013, at 20:24, Mohit <mt1037ag11@pdm.ac.in> wrote:
>
>> Hello,
>>
>>           I am on openSUSE 12.3 with kernel 3.7.10-1.4-desktop, i wanted to try out the proprietary drivers for Ralink RT3290 so i downloaded the drivers from http://www.mediatek.com/_en/07_downloads/01_windows.php?sn=501 and compiled the drivers as mentioned on my thread here : https://forums.opensuse.org/english/get-technical-help-here/wireless/486975-rt3290-wireless-proprietary-drivers-not-working.html#post2557514. Everything compiled fine, openSUSE was able to scan and connect to access points after installation, but when i access the internet a kernel panic occurs after ~5sec (time varies based on the data usage). So i humbly request you to please provide the solution for the same, you can reach me through email or reply to my thread (probably faster as i don't check my email everyday).
>>
> You'll have to contact Mediatek about the drivers that you downloaded from their web site.
> None of us on this mailing list have created this driver, nor are we supporting it.
>
> Note that the standard kernel does contain support for the RT3290 chipset in its rt2x00 driver since kernel version 3.6 or 3.7, so you might give that a try.
>
> ---
> Gertjan
The drivers work in kernel 3.2 but stop working from either kernel ver. 
3.3, 3.4 or 3.5.

The drivers included in the kernel work, but they are a buggy, have low 
range, connection drops etc.
I switched from Linux mint 13 kernel 3.2, installed the proprietary 
driver and it is way better than rt2800pci drivers interms of signal 
strength, latency, speed etc. I think the proprietary drivers use 
rt2860pci driver instead of a dedicated rt3290sta driver.

Can the drivers included in the kernel be tweaked to match the 
proprietary driver?

Can the future kernels support the drivers?

-- 









--
******************************************************************************************************************************************************************
"This e-Mail may contain proprietary and confidential information and is 
sent for the intended  recipient(s) only. If, by an addressing or 
transmission error, this mail has been misdirected to you, you are 
requested to delete this mail immediately.You are also hereby notified that 
any use, any form of reproduction, dissemination, copying, disclosure, 
modification, distribution and/or publication of this e-mail 
message,contents or its attachment(s) other than by its intended 
recipient(s) is strictly prohibited.Any opinions expressed in this email 
are those of the individual and not necessarily of the organization.Before 
opening attachment(s), please scan for viruses."
**********************************************************************************************************************************************************************

