Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f199.google.com ([209.85.210.199]:42931 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbZI2H3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 03:29:50 -0400
Received: by yxe37 with SMTP id 37so5882152yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2009 00:29:54 -0700 (PDT)
Subject: Re: Question on general wireless testing tree compilation.
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
From: Balaji Ravindran <b@w1an.in>
In-Reply-To: <3ace41890909281452x3170c8c6g5dc56cff85663099@mail.gmail.com>
Date: Tue, 29 Sep 2009 00:29:50 -0700
Cc: Linux Wireless <linux-wireless@vger.kernel.org>
Message-Id: <54F789C6-4B8F-46F0-9E67-5FE03BD6ACB4@w1an.in>
References: <16D9C5FD-4A2A-4061-9C26-FF5C0B0CDFBA@w1an.in> <3ace41890909281452x3170c8c6g5dc56cff85663099@mail.gmail.com>
To: Hin-Tak Leung <hintak.leung@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thanks for this info, i shall try to keep the old *working* config  
option. Though, with the README help file, I was successfully able to  
make and *select* my new target kernel, i had a kernel panic, and was  
not able to boot to it, also i noticed that my USB keybd and mouse  
connected to my monitor's usb port did not come up, so i guess  
something bad happened while doing make modules_install install, or  
while setting up the configurations before making.

I shall try to re-compile with my known good configuration.

Thanks again for the info.

Thanks

Balaji R


On Sep 28, 2009, at 2:52 PM, Hin-Tak Leung wrote:

>
> Also, compat-wireless (which just replaces the wireless-related kernel
> modules) is sometimes a quicker/easier alternative to the whole
> wireless-testing.

