Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:42509 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab0LJTCE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 14:02:04 -0500
Received: by fxm18 with SMTP id 18so4115216fxm.2
        for <linux-wireless@vger.kernel.org>; Fri, 10 Dec 2010 11:02:03 -0800 (PST)
Message-ID: <4D02793E.2050004@lwfinger.net>
Date: Fri, 10 Dec 2010 13:02:22 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
	=?UTF-8?B?UmFmYQ==?= =?UTF-8?B?xYIgTWnFgmVja2k=?=
	<zajec5@gmail.com>, wireless <linux-wireless@vger.kernel.org>,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: b43 N PHY status report
References: <1291755360-21570-1-git-send-email-zajec5@gmail.com>	 <AANLkTikp9ErFopLZVmXMjN3tXF2L62SwEEcujKeOBLYC@mail.gmail.com>	 <4CFFA112.7030800@lwfinger.net>	 <885729A3-72D4-4EFC-AAFE-D2B573E00ED9@ing.unibs.it> <1292006874.3531.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1292006874.3531.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/10/2010 12:47 PM, Johannes Berg wrote:
> On Fri, 2010-12-10 at 19:30 +0100, Francesco Gringoli wrote:
> 
>> [ 1117.516031] unregister_netdevice: waiting for wlan1 to become free. Usage count = 1
>>
>> and the device is never release (by who?). I have to reboot.
> 
> That's a bug in the ipv6 code, upgrade your kernel :-)

I would not have seen that as IPv6 is disabled in my kernels.

Larry
