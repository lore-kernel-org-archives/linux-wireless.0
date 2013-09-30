Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:49305 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab3I3J2o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 05:28:44 -0400
Received: from [192.168.2.100] ([93.218.116.97]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0LdZAI-1W9IXD0ULK-00ihiH for
 <linux-wireless@vger.kernel.org>; Mon, 30 Sep 2013 11:28:43 +0200
Message-ID: <5249443E.3080700@rempel-privat.de> (sfid-20130930_112853_427233_A96227A9)
Date: Mon, 30 Sep 2013 11:28:30 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Bruno Randolf <br1@einfach.org>, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, sujith@msujith.org
CC: Ingo Randolf <ingo.randolf@qupik.com>
Subject: Re: ath9k AR9287 status?
References: <52492FB0.3010201@einfach.org>
In-Reply-To: <52492FB0.3010201@einfach.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bruno,

Am 30.09.2013 10:00, schrieb Bruno Randolf:
> Hello!
> 
> What is the status of AR9287 support in ath9k?

It works at least for me, as AP and as STA...
But some people have different issues, looks like, mostly with old kernels.
You can find some of them:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/838016
http://pleph.appspot.com/init/posts/view/2657865

Check:
- PCIe related power managment - ASPM.
- WiFi related PM. "iw dev wlan0 get power_save"
- defect device?

> I have a AR9287 PCI-Express card which is behaving more than weird with
> kernel 3.2 and with the current (3.10.4-1) backports drivers: It can't
> connect to APs (many reconnects), with hostap it _seems_ to work as an
> AP, but no beacons are seen and no stations can connect, similar in
> ad-hoc mode, and when bringing the interface down the whole system
> freezes...

Is it regression? Are there any working kernel version?

> I've seen some related bugs in the bugtracker, but I wonder what the
> experiences with this chipset are in general?

actually not so bad :) like i said it works for me rally good.

> Or - can anyone recommend a good half size PCI-Express card that works
> well with ath9k?

If you wont to bay some new toy, then take a look here:
http://wikidevi.com/wiki/Atheros
I would take AR9462, there are some interesting highlights ;) (suddenly
I do not have it right now)

-- 
Regards,
Oleksij
