Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:41338 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab3F0Pc6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jun 2013 11:32:58 -0400
Received: by mail-ea0-f178.google.com with SMTP id l15so479223eak.23
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jun 2013 08:32:56 -0700 (PDT)
Message-ID: <51CC5B26.50605@gmail.com> (sfid-20130627_173301_539352_B9D4636F)
Date: Thu, 27 Jun 2013 17:32:54 +0200
From: "shiki.biomernok" <shiki.biomernok@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: Re: TP-Link 8200ND - rtl8192cu module not loading / working
References: <51A77433.2060702@lwfinger.net> <51CAD0B8.3010303@gmail.com> <51CB1356.80306@lwfinger.net> <51CB250A.3060900@gmail.com> <51CB4E31.50502@lwfinger.net> <51CC0CD1.5000801@gmail.com> <51CC3F6E.4050308@gmail.com> <51CC5541.8010003@lwfinger.net>
In-Reply-To: <51CC5541.8010003@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

So I already wanted to write a letter about how the new driver won't do 
anything. Then I got Larry's message and applied the patch immediately.

- The device starts up with no led activity (it should blink (slow) if 
plugged in)
^This is an annoying "feature", but... yeah.

- LED goes off if you disconnect. (Actually I like this behavior a lot 
more.)

- With this driver, I can actually connect and get a password wrong 
dialog. (it's correct.) So I suppose it's the same thing.. auth failed, 
just now I have my proper Nm-applet dialog, asking for a new password. 
(Oh, and finally this driver shows activity in the tray, as in, you can 
see it tries to connect. You know, that green orb going around. But only 
one of them is green and you will get prompted for a new password.)

Here is the dmesg (hope it helps.):
http://pastebin.com/uUsp7edb

I tried to compile the Linus git version of the kernel, but it comes 
with an even older wireless code than the "wireless-next" one. (Well, 
obviously, but you know.)

Could I go more verbose somehow?
Maybe with THIS driver? Or somehow fiddle with my router?

Ps.: That  really sucks Larry. I mean, you are the wireless wizard for 
Realtek and you don't get devices? Just what the... why? All of my why, 
man...



On 2013-06-27 17:07, Larry Finger wrote:
> On 06/27/2013 08:34 AM, Xose Vazquez Perez wrote:
>> On 06/27/2013 11:58 AM, shiki.biomernok wrote:
>>
>>> @Xose: What does that mean for me? Am I trying the wrong driver?
>>
>> No, that should be the correct driver.
>> But it looks like rtl8192cu wasn't tested enough with 2T2R(RTL8192CUS)
>> devices.
>
> The code in wireless-testing works fine on my Edimax EW-7811Un, which 
> reports as an RTL8192CUS. If someone wants to send me an 8200ND, I'll 
> make it work. Note: Realtek does not supply me with samples of USB 
> devices.
>
> Larry
>
>

