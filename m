Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1069 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab1BEMoq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Feb 2011 07:44:46 -0500
To: "Alim Akhtar" <alim.akhtar@gmail.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Suspend/Resume Doesnot work with brcmfmac driver
References: <AANLkTinq6_GVzD3hF4krxdBTn2gwgiu_8EuaOFCuEaq4@mail.gmail.com>
Date: Sat, 5 Feb 2011 13:44:25 +0100
MIME-Version: 1.0
From: "Arend van Spriel" <arend@broadcom.com>
Message-ID: <op.vqfj0pud3ri7v4@arend-laptop>
In-Reply-To: <AANLkTinq6_GVzD3hF4krxdBTn2gwgiu_8EuaOFCuEaq4@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed;
 delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alim,

On Sat, 05 Feb 2011 10:21:41 +0100, Alim Akhtar <alim.akhtar@gmail.com>  
wrote:

> Dear Arend Van Spriel
>
> I am using BCM4329 chip and downloaded the driver for google chromium  
> git repo (2.6.36 kernel version).
> I am facing a problem, suspend/resume does not works with this driver.
> I have seem your commit in the staging tree on 22th Jan "staging:  
> brcm80211: fix suspend/resume in brcmsmac" but i cannt find the fix for  
> brcmfmac. Can you please till suspend/resume for brcmfmac driver is  
> already fixed or it is work in progress? Also if fixed, please till me  
> patch location or send me the patch it self.

The suspend/resume changes for brcmfmac is work in progress at the moment  
as I was told by colleagues working on that driver. I assume the patch  
will be included in the chromium repo and also in the staging repo  
(git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git -  
staging-next branch).

For the staging repo you can keep an eye on the mailing list:  
http://driverdev.linuxdriverproject.org/pipermail/devel/

> Any help will be appreciated.
>
> Regards,
> Alim
>
>
> --
>

Gr. AvS
-- 
"The most merciful thing in the world, I think, is the inability of the  
human
mind to correlate all its contents." - "The Call of Cthulhu"

