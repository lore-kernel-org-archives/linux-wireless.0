Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:47024 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751188AbYHRNBv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 09:01:51 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ehud Gavron <gavron@wetwork.net>
Subject: Re: [PATCH RFT] b43: Rewrite PHY API for N-PHY/LP-PHY  -- good on 4311
Date: Mon, 18 Aug 2008 15:01:29 +0200
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
References: <200808160029.56876.mb@bu3sch.de> <48A87B5D.7010402@wetwork.net>
In-Reply-To: <48A87B5D.7010402@wetwork.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808181501.30057.mb@bu3sch.de> (sfid-20080818_150154_782511_4681A2BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 17 August 2008 21:26:21 Ehud Gavron wrote:
> Works fine here.  iperf same results as prior to patch. 
> 
> b43-phy0: Broadcom 4311 WLAN found
> b43-phy0 debug: Found PHY: Analog 4, Type 2, Revision 8
> b43-phy0 debug: Found Radio: Manuf 0x17F, Version 0x2050, Revision 2

Thanks a lot for testing.

I want to encourage people again to test this patch.
This really needs a lot of testing, because a regression caused by this
would really really be a bad thing.
Even if you think your card was already tested by somebody else, please test
it anyway. There are so many different cards with matching revision numbers
that really are slightly different.

Get wireless-testing.git:
git clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

and apply the patch
http://bu3sch.de/patches/wireless-testing/20080816-0023/patches/002-b43-phy-ops.patch

Please test basic features, throughput and longterm stability of the connection.

-- 
Greetings Michael.
