Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:24403 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753017AbZKTB0d (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 20:26:33 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 19 Nov 2009 17:26:40 -0800
Subject: Re: master-2009-11-19 busted? can't hold network connection for
 more than 1 second
From: Felix Bitterli <Felix.Bitterli@atheros.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1258678718.5323.8.camel@darkslate>
References: <1258678718.5323.8.camel@darkslate>
Content-Type: text/plain
Date: Thu, 19 Nov 2009 17:26:39 -0800
Message-ID: <1258680399.6345.3.camel@darkslate>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-11-19 at 16:58 -0800, Felix Bitterli wrote:
> Hi,
> 
> does anybody else see this?(sorry I can't bisect today, might have time
> tomorrow)
> 
> Wireless testing kernel master-2009-11-19 can't hold a network
> connection for more than 1 second, master-2009-11-18 is fine.
> 
> H/W Thinkpad T43, Atheros AR9280 Rev:2 mem=0xf89e0000, irq=21
> 
> Network office Wpa2/psk, tons of traffic/aps/clients.
> 
> Thanks guys.
> Felix

Sorry, was a H/W issue. Fine after 2nd reboot.

And miniPCI hotplug is the answer to the popular question (don't do
this).

On each reboot I need to do a miniPCI hotplug once boot passes bios
check (at grub menu I plug the card back in). It's kind of neat that the
laptop still works after about 300 hotplugs. Guess why I like suspend.

Thanks guys.
Felix

