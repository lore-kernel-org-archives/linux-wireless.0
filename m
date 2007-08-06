Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:42888 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764285AbXHFXZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2007 19:25:50 -0400
Message-ID: <46B7ADFC.3010005@lwfinger.net>
Date: Mon, 06 Aug 2007 18:25:48 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] bcm43xx-mac80211: Hack to turn automatic pctl off
References: <46b792a0.FdNEyH1qMrUgo6oh%Larry.Finger@lwfinger.net> <200708062335.48546.mb@bu3sch.de> <200708062356.58782.mb@bu3sch.de>
In-Reply-To: <200708062356.58782.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch wrote:
> On Monday 06 August 2007 23:35:48 Michael Buesch wrote:
>>
>> I am currently doing a patch for this.
>>
> 
> That's it
> http://bu3sch.de/patches/wireless-dev/20070806-1186437386/patches/bcm43xx-mac80211-hwpctl-optional.patch
>

It looks good. I'll test it later tonight.

I see where the ioctl to set txpower needs to be. It has not yet been coded, but I'll do that soon.

Larry



