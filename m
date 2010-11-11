Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:62839 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab0KKTPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 14:15:02 -0500
Received: by gyh4 with SMTP id 4so1434837gyh.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 11:15:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CDC049C.90005@lwfinger.net>
References: <AANLkTi=+0BOUaTs73jRMnJ=9qyNkqnBvMuKVTG4od9_+@mail.gmail.com>
	<0022152d6729673f6a0494b1f2e6@google.com>
	<AANLkTi=PYCwTtNmt9Baw=mYPqzyUQsiBNDOBXGic++5_@mail.gmail.com>
	<4CDAB99D.7030100@lwfinger.net>
	<AANLkTik9=-8bXNOvrY-JnFuVJr1wZG24o8m8JzJVD8tQ@mail.gmail.com>
	<4CDC049C.90005@lwfinger.net>
Date: Thu, 11 Nov 2010 20:14:56 +0100
Message-ID: <AANLkTi=JG=5tX2zcXOCdtUMHcASaZOWppZzb4vLyJSxc@mail.gmail.com>
Subject: Re: Question about Edimax 7811Un
From: "miloofr@gmail.com" <miloofr@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you.

In fact I successfully compiled this driver (latest 1126 version) with
a 2.6.35 kernel from ubuntu 10.10 . It seems to work ok, except some
freezing sometimes while booting with the stick installed on the PC.
It also compiles with the same kernel on a 64 bits system, with a lot
of errors, but does not work at all (freezes immediately). It is
precised in the doc of the realtek linux driver that this is a 32 bits
driver.
Can you warn if the usb stick is in the samples sent from Realtek?
If necessary, I can test your 64 bits converted driver on my system
and give you the results in order to fix it.

Eric

PS: sorry for the reply-to-all forgetting. I realized that one minute
after and resent my email to the ML also ;).


2010/11/11 Larry Finger <Larry.Finger@lwfinger.net>:
> On 11/11/2010 02:55 AM, miloofr@gmail.com wrote:
>> The device as shown in lsusb is:
>> 0x7392:0x7811
>>
>> The vendor id seems to be different as those recognized by the  r8712u
>> driver. How could I try the driver to confirm that the 7811 device
>> works with this driver?
>
> Please use the "Reply-to-all" when you respond to an email. I want to keep the
> wireless mailing list informed about what we are doing.
>
> Driver r8712u does not appear to work with your device. I could not get the
> Linux driver source for the 7811 to download from the Edimax site, but I found
> it on the Realtek site as RTL8192CU_v2.0.1126.zip. There is a tarball inside
> that zip file with the Linux driver. It does not compile under 2.6.37-rc1. From
> the warnings, I can see that it needs work to get it to run on a 64-bit system,
> but it is likely to work in the 32-bit version.
>
> Realtek is sending me some sample devices. If one of these nano USB devices is
> included, I will convert the driver to 64 bits and send the modifications back
> to Realtek. If/when that happens, I'll let you know.
>
> Larry
>
