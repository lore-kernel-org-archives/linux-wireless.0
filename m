Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60063 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab2D2Xj4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2012 19:39:56 -0400
Received: by iadi9 with SMTP id i9so3416460iad.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2012 16:39:56 -0700 (PDT)
Message-ID: <4F9DD144.9030901@lwfinger.net> (sfid-20120430_014000_289564_4012496F)
Date: Sun, 29 Apr 2012 18:39:48 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: simple w8 <simplew8@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8192ce makes keyboard repeat and mouse freeze
References: <CAKVccoU7CnhVVQ82U23Yuww6VrTMU4FsjWcWVbk16LNKyQfvOQ@mail.gmail.com> <A872091605A443F48DE1814CF6FAFE25@realtek.com.tw> <CAKVccoUfER_m48BtyMjo3pix2_BmqBZ8kxij_RxDhOLEN5Q-9A@mail.gmail.com> <4F9AF76A.4040607@lwfinger.net> <CAKVccoUbcvO-X5w2pOuOyP=DhK+64opsJm5muznjsOWu==MUcQ@mail.gmail.com> <4F9B63CF.4010005@lwfinger.net> <CAKVccoW8GCE=QSC9db6EnoEOsnBkKNoEvqzRrn8orbkf=U66Dg@mail.gmail.com> <4F9BFA14.3070008@lwfinger.net> <CAKVccoWRdcB87DB22=hy9wvEuR7exB7LV8zEGwq1+ug6YK2Zig@mail.gmail.com>
In-Reply-To: <CAKVccoWRdcB87DB22=hy9wvEuR7exB7LV8zEGwq1+ug6YK2Zig@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/29/2012 05:51 PM, simple w8 wrote:
> 2012/4/28 Larry Finger<Larry.Finger@lwfinger.net>:
>> On 04/27/2012 11:30 PM, simple w8 wrote:
>>>
>>> 2012/4/28 Larry Finger<Larry.Finger@lwfinger.net>:
>>>>
>>>> On 04/27/2012 04:36 PM, simple w8 wrote:
>>>>>
>>>>>
>>>>>
>>>>> What details more i could provide, could you clarify please?
>>>>>
>>>>
>>>> What distro do you use? How do you control the wifi? Do you use
>>>> NetworkManager, or what? If you use wicd, then that is likely the
>>>> problem!
>>>> These are the kinds of details that should have been in your first
>>>> message.
>>>>
>>>> You need to get the compat-wireless source from
>>>> http://wireless.kernel.org/en/users/Download, and build it on your
>>>> system.
>>>
>>>
>>> In previous message i clarified that the distro uses NetworkManager
>>> NetworkManager (and networkmanager calls wpa_supplicant through dbus).
>>> The distro i use is Mageia, but when i run Ubuntu live cd i found the
>>> same exact problem.
>>>
>>> For what i see compat-wireless file arepart of the kernel, and the
>>> distro already provides the latest kernel available thats version
>>> 3.3.3.
>>
>>
>> I do not like your tone!! If you want help, please watch what you say.
>
> Hu?
> I dont understand why your saying this, seams your in a bad mood but
> thats certainly not my fault...
>
>> For your information, the latest compat-wireless has the wireless code that
>> will be in kernel 3.5. That is the reason I want you to try it.
>
> Anyway in the website you pointed i see this to download:
> http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
> but for what i read there this isnt for kernel-2.6 series?

 From the web page:

=======================================================

Linux wireless version table

The following is the latest release versions for code taken from linux-next.git 
and on compat-wireless.git. This is updated automatically every day. The version 
represents the git-describe output.

linux-next.git: <<CurrentLinuxNext>>

compat-wireless.git: <<CurrentCompatVersion: unknown>>

Where to download bleeding edge

You can get bleeding edge compat-wireless here:

compat-wireless-2.6.tar.bz2

This package is updated daily. It reflects the latest on linux-next.git tree.

===============================================================

As it says, it contains the latest wireless code. It will build and run on any 
kernel from 2.6.24 to 3.4-rc4.

It was OK to drop the Realtek addresses from this thread. They will ignore it 
anyway. I have added the wireless ML as a Cc. Please keep that with all further 
communications.

Larry





