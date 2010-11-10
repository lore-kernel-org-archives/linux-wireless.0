Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59342 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab0KJPcL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 10:32:11 -0500
Received: by fxm16 with SMTP id 16so450611fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 07:32:09 -0800 (PST)
Message-ID: <4CDAB99D.7030100@lwfinger.net>
Date: Wed, 10 Nov 2010 09:26:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "miloofr@gmail.com" <miloofr@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Question about Edimax 7811Un
References: <AANLkTi=+0BOUaTs73jRMnJ=9qyNkqnBvMuKVTG4od9_+@mail.gmail.com>	<0022152d6729673f6a0494b1f2e6@google.com> <AANLkTi=PYCwTtNmt9Baw=mYPqzyUQsiBNDOBXGic++5_@mail.gmail.com>
In-Reply-To: <AANLkTi=PYCwTtNmt9Baw=mYPqzyUQsiBNDOBXGic++5_@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/2010 06:25 AM, miloofr@gmail.com wrote:
> Hi,
> I would want to know what is the current state of the 8191su wireless
> driver. I have a wifi USB stick from EDIMAX, the 7811Un model, which is
> supposed to have a 8192su chip inside.
> It is not recognized neither from latest Ubuntu 10.10 nor openSUSE
> 11.3 . However I have been able to make it work by compiling the
> drivers proposed on the EDIMAX website, but this is only available for
> 32 bits systems/kernels.
> I saw that there were some discussion 2 months ago about this port
> from 32 to 64 bits, what is the current state today?

What are the USB IDs for this device as shown by lsusb?

If the numbers are 0x7392:0x7611, 0x7392:0x7612, or 0x7392:0x7622, the device is
supported by the r8712u driver in staging and is present in mainline kernel
2.6.37-rc1. I can assure you that the driver works for both 32- and 64-bit systems.

Larry

