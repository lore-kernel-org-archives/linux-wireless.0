Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:53767 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753390AbXHGEsq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 00:48:46 -0400
Message-ID: <46B7F9AC.10706@lwfinger.net>
Date: Mon, 06 Aug 2007 23:48:44 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
Subject: Re: [RFC] bcm43xx-mac80211: Hack to turn automatic pctl off
References: <46b792a0.FdNEyH1qMrUgo6oh%Larry.Finger@lwfinger.net> <200708062335.48546.mb@bu3sch.de> <200708062356.58782.mb@bu3sch.de>
In-Reply-To: <200708062356.58782.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> 
> That's it
> http://bu3sch.de/patches/wireless-dev/20070806-1186437386/patches/bcm43xx-mac80211-hwpctl-optional.patch
> 

This patch makes my BCM4311 positively hum even with the power set at the default 18.5 dBm. I get 
the same performance as was seen using the PHY code ported from softmac. Congratulations - you found 
the secret. Of course, the system will probably be even better when hardware power control is 
working, but we can now afford to wait until the reverse engineers have time.

I still have not tested with the BCM4318 and the BCM4306.

Larry

