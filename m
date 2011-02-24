Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:43973 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173Ab1BXD3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Feb 2011 22:29:05 -0500
Received: by vxi39 with SMTP id 39so109041vxi.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Feb 2011 19:29:04 -0800 (PST)
Message-ID: <4D65D223.5070405@gmail.com>
Date: Thu, 24 Feb 2011 11:36:03 +0800
From: Xiao Jiang <jgq516@gmail.com>
MIME-Version: 1.0
To: Xiao Jiang <jgq516@gmail.com>, wey-yi.w.guy@intel.com,
	johannes@sipsolutions.net
CC: linux-wireless@vger.kernel.org
Subject: Re: Help about Intel Centrino Advanced-N 6205 wifi card
References: <AANLkTikkdtE0NNN57C3zWhL6BDRSJn3Z9qnXKhNKhwGq@mail.gmail.com>
In-Reply-To: <AANLkTikkdtE0NNN57C3zWhL6BDRSJn3Z9qnXKhNKhwGq@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xiao Jiang 写道:
> Hello all,
>
> I have one Intel Centrino Advanced-N 6205 wifi card which need 
> firmware iwlwifi-6000g2a-4.ucode to support it, but in intel website 
> http://intellinuxwireless.org/?n=Downloads, only 
> iwlwifi-6000g2a-5.ucode firmware exists, where can I download the 
> official version
> 4 firmware? Thanks in advance!
>
> I also got iwlwifi-6000g2a-4.ucode from one website but maybe it has 
> some problems, this firmware works well with kernel 2.6.37-rc1,
> but it seems can't compatible with 2.6.36, there are some "Microcode 
> SW error detected" when enable the card, pls see the following
> logs, why this error exist with 2.6.36 kernel but disappeared in 
> 2.6.37-rc1 kernel? and unfortunately, I want to work with 2.6.36 kernel:(.
Hi Wey and johannes

Finally, I got this card work in 2.6.35+ kernel, and the last commit is 
670245.

commit ed4515cbc5e39e39d44965cb7add2c8aa9
Author: Johannes Berg <johannes.berg@intel.com>
Date: Mon Aug 23 07:56:55 2010 -0700

iwlagn: implement advance BT config command

Thanks for your help!

Best Regards,
Xiao
