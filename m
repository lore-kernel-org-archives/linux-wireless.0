Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from postler.einfach.org ([91.250.116.113]:49132 "EHLO
	postler.einfach.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab3I3KjC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 06:39:02 -0400
Message-ID: <524954BE.8060603@einfach.org> (sfid-20130930_123907_978819_834E94D0)
Date: Mon, 30 Sep 2013 11:38:54 +0100
From: Bruno Randolf <br1@einfach.org>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org, sujith@msujith.org
CC: Ingo Randolf <ingo.randolf@qupik.com>
Subject: Re: ath9k AR9287 status?
References: <52492FB0.3010201@einfach.org> <5249443E.3080700@rempel-privat.de>
In-Reply-To: <5249443E.3080700@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/2013 10:28 AM, Oleksij Rempel wrote:
> It works at least for me, as AP and as STA...

Thanks, good to hear! :)

> Check:
> - PCIe related power managment - ASPM.

That sounds most suspicious. Will try to see what can be done in the 
BIOS or if disabling ASPM in the kernel helps.

> - WiFi related PM. "iw dev wlan0 get power_save"

That would only affect STA and IBSS mode, right?

> - defect device?

Having the same problem on two setups... maybe but it's unlikely...

>> I have a AR9287 PCI-Express card which is behaving more than weird with
>> kernel 3.2 and with the current (3.10.4-1) backports drivers: It can't
>> connect to APs (many reconnects), with hostap it _seems_ to work as an
>> AP, but no beacons are seen and no stations can connect, similar in
>> ad-hoc mode, and when bringing the interface down the whole system
>> freezes...
>
> Is it regression? Are there any working kernel version?

I have tried with 3.2 clean (Ubuntu 12.04 default) and with the 
mentioned backports version. If you point me to a known working 
backports version I can try it.

>> Or - can anyone recommend a good half size PCI-Express card that works
>> well with ath9k?
>
> If you wont to bay some new toy, then take a look here:
> http://wikidevi.com/wiki/Atheros
> I would take AR9462, there are some interesting highlights ;) (suddenly
> I do not have it right now)

integrated bluetooth 4.0; 8bit Spectral Scan?

Thanks!

bruno

