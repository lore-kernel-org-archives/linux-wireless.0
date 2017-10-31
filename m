Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from snoopy.schmut.com ([185.37.248.246]:49138 "EHLO
        snoopy.schmut.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932641AbdJaTZd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Oct 2017 15:25:33 -0400
Subject: Re: iwlwifi crash with hostapd
Cc: linux-wireless@vger.kernel.org
References: <6e51916a-6178-5620-8f45-54705c1b4d98@schmut.com>
 <20171012212454.GB4362@us.netrek.org>
 <b985bbb0-ec49-0506-871e-b65837b05be2@schmut.com>
 <20171016033727.GB13209@us.netrek.org>
 <2f83cea3-1760-1557-c0ff-0d40ab20f9e8@schmut.com>
 <20171017233558.GD6841@us.netrek.org> <20171018213337.GA5595@us.netrek.org>
 <bc6a9aa0-8f13-4e8e-0c40-c19246ad2934@schmut.com>
 <20171019205933.GB7281@us.netrek.org>
 <8b961054-0b13-771b-387e-b47837c493ca@schmut.com>
 <20171024210157.GA19317@us.netrek.org>
From: Mario Theodoridis <mario@schmut.com>
Message-ID: <b6155f5b-4319-ba12-6b32-47d014304570@schmut.com> (sfid-20171031_202556_829265_06EC162A)
Date: Tue, 31 Oct 2017 20:25:25 +0100
MIME-Version: 1.0
In-Reply-To: <20171024210157.GA19317@us.netrek.org>
Content-Type: text/plain; charset=utf-8; format=flowed
To: unlisted-recipients:; (no To-header on input)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,


On 24.10.2017 23:01, James Cameron wrote:
> But it is only a warning.  If connections aren't dying, it may not be
> important to you.

Regarding whether wifi hangs, it's usually takes a while to get going 
and then disappears. Sunday night i ended up rebooting into the 4.4-79 
kernel because the 4.13 just got too ridiculous.
I.e. Wlan off, wlan on no longer worked.


> Please check you are using the most recent linux-firmware?

Just in case i haven't answered that it's at 1.169


>>> Several methods, though by far the most common seems to be personal
>>> experience with offsets.
>>>
>>> When you don't have that personal experience, the methods are;
>>>
>>> 1.  using GDB against the .o file,
>>>
>>> 2.  using binutils objdump to disassemble .o file or vmlinuz,
>>>
>>> 3.  using GCC to generate assembly listings,
>>>
>>> See https://wiki.ubuntu.com/Kernel/KernelDebuggingTricks right down
>>> the end of page for the GDB method.
>>
>> I have gotten around to that part, yet, as i was busy with the
>> above, but it seems later versions have issues, too.
> 
> However, you're still testing old source code.
> 
> Several changes made since are worth testing, please either
> cherry-pick the patches or test a 4.14 rc kernel, and without
> involving dkms or virtualbox.
> 
> Or, if new firmware fixes the problem, go with that instead.

I just managed to patch the 5.1.30 dkms package so i wouldn't need to 
update to virtualbox-5.2.


Here are the results with the 4.14-rc7 kernel.
As last time i appended what fills my syslog now.


-- 
Mit freundlichen Grüßen/Best regards

Mario Theodoridis
