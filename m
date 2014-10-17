Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753059AbaJQBxi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 21:53:38 -0400
Message-ID: <1413510814.22769.6.camel@dcbw.local> (sfid-20141017_035341_213374_2D273849)
Subject: Re: iwlwifi: Reason 7 periodic disconnect
From: Dan Williams <dcbw@redhat.com>
To: =?UTF-8?Q?Lauren=C8=9Biu?= Nicola <lnicola@dend.ro>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 16 Oct 2014 20:53:34 -0500
In-Reply-To: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
References: <1413463736.1316541.179720977.4FD32021@webmail.messagingengine.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-10-16 at 15:48 +0300, Laurențiu Nicola wrote:
> Hello,
> 
> I'm using iwlwifi for a Centrino Ultimate-N 6300 on 3.14.4 and 3.17.1.
> Connect to my wireless network works, but I get disconnected every 60
> seconds or so. The dmesg output looks like
> https://bpaste.net/show/1623a8ae5dc6 .
> 
> I had the same issue on the three latest firmware versions:
> iwlwifi-6000-ucode-9.176.4.1
> iwlwifi-6000-ucode-9.193.4.1
> iwlwifi-6000-ucode-9.221.4.1
> 
> The dmesg log actually shows the driver loading the different versions
> above.
> 
> It's the first time I try to use wireless on Linux, so I might have made
> a dumb mistake.

Can you try to get debug output from wpa_supplicant, which is the
process that controls WiFi on Linux?  What distro and version do you
use, and do you know what WiFi management service is being used?
(NetworkManager, conman, plain wpa_supplicant, wicd, something else?)

Dan

