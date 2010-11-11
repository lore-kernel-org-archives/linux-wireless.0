Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63291 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab0KKO57 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 09:57:59 -0500
Received: by gxk23 with SMTP id 23so1185266gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 11 Nov 2010 06:57:59 -0800 (PST)
Message-ID: <4CDC049C.90005@lwfinger.net>
Date: Thu, 11 Nov 2010 08:58:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "miloofr@gmail.com" <miloofr@gmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Question about Edimax 7811Un
References: <AANLkTi=+0BOUaTs73jRMnJ=9qyNkqnBvMuKVTG4od9_+@mail.gmail.com>	<0022152d6729673f6a0494b1f2e6@google.com>	<AANLkTi=PYCwTtNmt9Baw=mYPqzyUQsiBNDOBXGic++5_@mail.gmail.com>	<4CDAB99D.7030100@lwfinger.net> <AANLkTik9=-8bXNOvrY-JnFuVJr1wZG24o8m8JzJVD8tQ@mail.gmail.com>
In-Reply-To: <AANLkTik9=-8bXNOvrY-JnFuVJr1wZG24o8m8JzJVD8tQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/11/2010 02:55 AM, miloofr@gmail.com wrote:
> The device as shown in lsusb is:
> 0x7392:0x7811
> 
> The vendor id seems to be different as those recognized by the  r8712u
> driver. How could I try the driver to confirm that the 7811 device
> works with this driver?

Please use the "Reply-to-all" when you respond to an email. I want to keep the
wireless mailing list informed about what we are doing.

Driver r8712u does not appear to work with your device. I could not get the
Linux driver source for the 7811 to download from the Edimax site, but I found
it on the Realtek site as RTL8192CU_v2.0.1126.zip. There is a tarball inside
that zip file with the Linux driver. It does not compile under 2.6.37-rc1. From
the warnings, I can see that it needs work to get it to run on a 64-bit system,
but it is likely to work in the 32-bit version.

Realtek is sending me some sample devices. If one of these nano USB devices is
included, I will convert the driver to 64 bits and send the modifications back
to Realtek. If/when that happens, I'll let you know.

Larry
