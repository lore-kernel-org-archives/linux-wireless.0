Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:56812 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0KKJDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 04:03:25 -0500
Received: by iwn10 with SMTP id 10so1908882iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 01:03:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CDAB99D.7030100@lwfinger.net>
References: <AANLkTi=+0BOUaTs73jRMnJ=9qyNkqnBvMuKVTG4od9_+@mail.gmail.com>
	<0022152d6729673f6a0494b1f2e6@google.com>
	<AANLkTi=PYCwTtNmt9Baw=mYPqzyUQsiBNDOBXGic++5_@mail.gmail.com>
	<4CDAB99D.7030100@lwfinger.net>
Date: Thu, 11 Nov 2010 10:03:24 +0100
Message-ID: <AANLkTi=nhm11E=iOjoyDFmMQKDyrJja7QAkWKZ8DV29A@mail.gmail.com>
Subject: Re: Question about Edimax 7811Un
From: "miloofr@gmail.com" <miloofr@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The device as shown in lsusb is:
0x7392:0x7811

The vendor id seems to be different as those recognized by the  r8712u
driver. How could I try the driver to confirm that the 7811 device
works with this driver?

Eric

2010/11/10 Larry Finger <Larry.Finger@lwfinger.net>:
> On 11/10/2010 06:25 AM, miloofr@gmail.com wrote:
>> Hi,
>> I would want to know what is the current state of the 8191su wireless
>> driver. I have a wifi USB stick from EDIMAX, the 7811Un model, which is
>> supposed to have a 8192su chip inside.
>> It is not recognized neither from latest Ubuntu 10.10 nor openSUSE
>> 11.3 . However I have been able to make it work by compiling the
>> drivers proposed on the EDIMAX website, but this is only available for
>> 32 bits systems/kernels.
>> I saw that there were some discussion 2 months ago about this port
>> from 32 to 64 bits, what is the current state today?
>
> What are the USB IDs for this device as shown by lsusb?
>
> If the numbers are 0x7392:0x7611, 0x7392:0x7612, or 0x7392:0x7622, the device is
> supported by the r8712u driver in staging and is present in mainline kernel
> 2.6.37-rc1. I can assure you that the driver works for both 32- and 64-bit systems.
>
> Larry
>
>
