Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46994 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1L3PRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Dec 2011 10:17:51 -0500
Message-ID: <4EFDD61D.6050008@candelatech.com> (sfid-20111230_161754_735863_18FD154D)
Date: Fri, 30 Dec 2011 07:17:49 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Naoyuki Tai <ntai@smartfruit.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: ath9k: Failed to stop TX DMA!, DMA failed to stop in 10 ms
References: <4EFD5E40.3020606@smartfruit.com>
In-Reply-To: <4EFD5E40.3020606@smartfruit.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/29/2011 10:46 PM, Naoyuki Tai wrote:
> Hello,
>
> I've spent some time on ath9k driver getting stuck.
> I set up a new system with OpenWRT, and the atheros AR922X had the problem.
> I've gone through http://linuxwireless.org/en/users/Drivers/ath9k/bugs, and decided to give a go around with newer driver.
> I went the route of Debian wheezy, so that I can use the updated compat-wireless more easily.
> The current system is
> Linux ntai11d 3.1.0-1-486 #1 Sun Dec 11 19:52:34 UTC 2011 i586 GNU/Linux

Did you try any older kernels, maybe stock 3.0, to see if it's a recently
added problem?

The scan and off-channel optimizations that I did originally helped
work around these problems in my own testing, but my optimizations were
complex and had some other bugs and were removed recently.  It's possible
that helps expose the DMA issues again...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
