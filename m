Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51425 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab1FCXBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2011 19:01:30 -0400
Received: by iyb14 with SMTP id 14so1737246iyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 03 Jun 2011 16:01:29 -0700 (PDT)
Message-ID: <4DE967C6.4050207@lwfinger.net> (sfid-20110604_010137_554655_FF64F724)
Date: Fri, 03 Jun 2011 18:01:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arif Ali <mail@arif-ali.co.uk>
CC: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
	linux-wireless@vger.kernel.org
Subject: Re: r8192se_pci or rtlwifi/rtl8192ce
References: <4DE7D5FD.2050707@arif-ali.co.uk>	<20110603130308.GB2379@nautilus.holoscopio.com>	<4DE8E4F5.7010009@arif-ali.co.uk> <BANLkTimLuM4rpfYmTtxA3-6LXyEE4JqqdQ@mail.gmail.com>
In-Reply-To: <BANLkTimLuM4rpfYmTtxA3-6LXyEE4JqqdQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/03/2011 12:29 PM, Arif Ali wrote:
> For some reason the rc1 kernel didn't work from the mainline kernels from
> ubuntu, I downloaded the latest kernel from mainline, (although it says it is
> for oneiric)
>
> i.e. The kernel below for me works
>
> http://kernel.ubuntu.com/~kernel-ppa/mainline/daily/2011-06-02-oneiric/
>
> i.e. 3.0.0-999-generic
>
> The driver being used here is rtl8192se, and the stability issues I had are now
> gone, will test for a few more days and see how it goes.
>
> Thanks for all those people who replied

Sorry that I did not reply earlier, but I was traveling without access to Email.

The driver rtl8192se in kernel 3.0-rc1 is the correct one as you noted. For me, 
it has been very stable. There is one fix that is in the pipeline, in 
wireless-testing, but not yet in the mainline tree. The symptoms are kernel 
panics due to excessive fragmentation causing buffer allocation failures. This 
problem affects both rtl8192ce and rtl8192se. As it took a long time for me to 
have problems with the drivers, you will likely not see the problem. The fix 
should be in 3.0-rc2. If you want, I can send you the patches.

Larry

