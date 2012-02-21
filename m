Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from thalia-smout.broadpark.no ([80.202.8.21]:36317 "EHLO
	thalia-smout.broadpark.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab2BUVz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Feb 2012 16:55:58 -0500
MIME-version: 1.0
Content-type: text/plain; CHARSET=US-ASCII
Received: from ignis-smin.broadpark.no ([80.202.8.11])
 by thalia-smout.broadpark.no
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTP id <0LZR00BTKGSZZ020@thalia-smout.broadpark.no> for
 linux-wireless@vger.kernel.org; Tue, 21 Feb 2012 21:55:47 +0100 (CET)
Received: from [192.168.1.10] ([80.202.101.84]) by ignis-smin.broadpark.no
 (Sun Java(tm) System Messaging Server 7u3-15.01 64bit (built Feb 12 2010))
 with ESMTP id <0LZR00872GSZVBD0@ignis-smin.broadpark.no> for
 linux-wireless@vger.kernel.org; Tue, 21 Feb 2012 21:55:47 +0100 (CET)
Message-id: <4F4404E9.3030404@bakke.com> (sfid-20120221_225602_061989_9E3103D0)
Date: Tue, 21 Feb 2012 21:56:09 +0100
From: DagB <dag@bakke.com>
To: linux-wireless@vger.kernel.org
Subject: brcmsmac features/TODO?
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi.

Referring to:
http://linuxwireless.org/en/users/Drivers/brcm80211

I was wondering if there is a roadmap/plan to implement 40MHz channels
and powersave for the brcmsmac driver in the not too distant future.

brcmsmac is by far the single most powerhungry device in my MBA, if
powertop is to be trusted. Would be great to have that fixed. I guess
enabling hw encryption will contribute positively in this regard as well.

Not asking for hard commitments, just wondering if the Broadcom guys
have a plan...

Brett? Arend? Franky?


Thanks,

Dag B.
