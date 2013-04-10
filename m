Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:44737 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936837Ab3DJO4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 10:56:07 -0400
Received: by mail-qa0-f49.google.com with SMTP id i13so321520qae.15
        for <linux-wireless@vger.kernel.org>; Wed, 10 Apr 2013 07:56:06 -0700 (PDT)
Message-ID: <51657D84.2080308@lwfinger.net> (sfid-20130410_165616_036278_DBA9D907)
Date: Wed, 10 Apr 2013 09:56:04 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Davide Marchi <danjde@msw.it>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: realtek usb wifi based on "rtl8192cu"
References: <516539DC.8060004@msw.it>
In-Reply-To: <516539DC.8060004@msw.it>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/10/2013 05:07 AM, Davide Marchi wrote:
> Hi friends,
> on realtek usb wifi based on "rtl8192cu",
> using kernel 3.8.3.x or 3.8.6 the device seem work good, but is unable to
> connect. Infinitely it ask me the wep/wpa key..
>
> I've tested using kernel "Linux  3.8.3-103.fc17.x86_64 #1 SMP Mon Mar 18
> 15:46:01 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux"
> and 3.8.6 vanilla (from kernel.org)
>
> Asking to Larry Finger he says that from kernel 3.8.5 this issues is fixed, but
> is not so, for my experience.
>
> lsusb:
> Bus 001 Device 003: ID 0bda:8178 Realtek Semiconductor Corp. RTL8192CU 802.11n
> WLAN Adapter

If 3.8.6 does not fix it, then try the kernel from the wireless-testing git 
tree. There were a number of other fixes in the code that will go into kernel 
3.10, and my rtl8192cu devices (3 different models) work fine here with that 
kernel. Unfortunately, those changes are not yet available in a compat-drivers 
release.

Otherwise, you need to produce more definitive logging of what is failing.

Larry

