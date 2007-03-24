Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:62046 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934339AbXCXBl5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 21:41:57 -0400
Message-ID: <460481D8.5010905@lwfinger.net>
Date: Fri, 23 Mar 2007 20:41:44 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Stefano Brivio <stefano.brivio@polimi.it>
CC: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	wireless <linux-wireless@vger.kernel.org>,
	bcm43xx devel <Bcm43xx-dev@lists.berlios.de>
Subject: Re: RFC: Future plans for bcm43xx-softmac
References: <4604106F.7080003@lwfinger.net> <20070323204627.183d2c21@localhost>
In-Reply-To: <20070323204627.183d2c21@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stefano Brivio wrote:
> On Fri, 23 Mar 2007 12:37:51 -0500
> Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
>> I think we have a plan for the future of bcm43xx-softmac once the
>> bcm43xx-mac80211 version goes into mainline. Unfortunately it cannot just
>> be abandoned as there will be no support for 802.11b-only devices in
>> bcm43xx-mac80211.
>>
>> The steps to be done are as follows:
>>
>> 1. Change the namespace from bcm43xx to bcm4301. This will both reflect
>> the purpose of the changed driver as well as prevent namespace collisions
>> with the bcm43xx-mac80211 version in case both are built into the kernel.
> 
> I'm quite sure you know, bcm4301 isn't the only 802.11b-only device.
> There's bcm4303 too. Anyway, naming the driver bcm4301 sounds reasonable to
> me.

Yes, but bcm430x would have been more confusing as the 4306 and 4309 are covered by V4 firmware.
Other choices such as bcm43xx-old, etc. seemed a little clumsy.

Larry
