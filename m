Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:50650 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab1ECOpI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 10:45:08 -0400
Subject: Re: iwlagn: crash when unloading the module
From: wwguy <wey-yi.w.guy@intel.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <87iptsgk5y.fsf@purkki.adurom.net>
References: <87iptsgk5y.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 May 2011 07:42:07 -0700
Message-ID: <1304433727.5744.107.camel@wwguy-ubuntu> (sfid-20110503_164512_782430_D6ED552C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-05-03 at 03:20 -0700, Kalle Valo wrote:
> Hi,
> 
> I noticed today a crash when removing iwlagn module. I can see the
> crash everytime on my lenovo x201 (x86 64bit, i5) with this wireless
> chip:
> 
> [   19.484551] iwlagn 0000:02:00.0: Detected Intel(R) Centrino(R)
> Ultimate-N 6300 AGN, REV=0x74
> 
> As I'm travelling I only have two bad quality screenshots and 40 MB
> video of the crash :) From the stacktrace it looks that this is iommu
> related:
> 
> http://www.adurom.com/~kvalo/tmp/iwlagn/rmmod-iommu-crash/1.png
> http://www.adurom.com/~kvalo/tmp/iwlagn/rmmod-iommu-crash/2.png
> 
> This is a new laptop and most likely I haven't removed iwlagn module
> before. So this shouldn't be a regression.
> 

it is new to me as well, I never see that happen on my system. Could you
share some more information with me? such as laptop model, kernel
version, 32 or 64 bits.

Also is there any activity while you unload the iwlagn, is it in connect
state or not? 

Thanks
Wey

