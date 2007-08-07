Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:58761 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756518AbXHGPrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 11:47:42 -0400
Message-ID: <46B8941C.5020807@lwfinger.net>
Date: Tue, 07 Aug 2007 10:47:40 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH] bcm43xx-mac80211: Make hwpctl optional (disabled by default)
References: <200708071733.11986.mb@bu3sch.de>
In-Reply-To: <200708071733.11986.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> This patch makes hardware power control optional through
> a module parameter, which is disabled by default.
> Hardware power control is broken, so we will drive with software
> based power control.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>

ACK: Larry Finger <Larry.Finger@lwfinger.net>
> 
> --
> 
> John, please apply to wireless-dev.
> With this patch we come into the region where we might consider
> going into production with bcm43xx-mac80211.
> The mac80211 rc algorithm is able to auto-scale up to 54M on
> my 4306 and the 4318(!).
> So the major TX problems seem mostly gone with this.
> 
> I am going to do more small patches that optimize software
> power adjustment and so on later. But the major stuff should
> be fixed.

I get auto-scaling to 54M on my 4311 as well. I agree that bcm43xx-mac80211 is now ready to start 
the process of getting it into mainstream in the 2.6.24 or -25 cycle. Any changes required by the 
reviewers will be mirrored in the bcm4301 code. It certainly looks as if we will be free of softmac 
very soon.

Larry
