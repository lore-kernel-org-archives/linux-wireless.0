Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:49298 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab2DSSuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 14:50:46 -0400
Received: from mac.home (mnch-5d85d887.pool.mediaWays.net [93.133.216.135])
	by eazy.amigager.de (Postfix) with ESMTPA id 02679C8C0C7
	for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 20:50:44 +0200 (CEST)
Date: Thu, 19 Apr 2012 20:50:55 +0200
From: tino <tino.keitel@tikei.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: Power saving features for iwl4965
Message-ID: <20120419185055.GA1266@mac.home> (sfid-20120419_205049_735027_37B025A4)
References: <20120418203543.GA16000@x61.home>
 <4F90204D.3060801@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------- Original message -------
> From: Johannes Berg <johannes@sipsolutions.net>
> To: tino.keitel@tikei.de
> Cc: linux-wireless@vger.kernel.org
> Sent: 19.4.'12,  16:25
>
> On 4/18/2012 1:35 PM, Tino Keitel wrote:
>> up to 2.6.38, the iwl4965 driver was able to use power saving features
>> by invoking "iwconfig<interface>  power on", at least when unsetting
>> the broken_powersave variable.
>
> This isn't quite correct. Yes, power saving was enabled there, but 
> relatively frequently it caused the device to crash. Therefore, it was 
> disabled as a stability fix, not to remove powersaving from you :)

Hi,

I was aware that it was disabled because of stability issues in certain 
setups. I never experienced any issue when running with power saving 
enabled, though. Other people did the same and even suggested patches to 
clear broken_powersave with a module parameter.

Regards,
Tino

