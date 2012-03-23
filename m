Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:54780 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab2CWJPd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2012 05:15:33 -0400
Message-ID: <4F6C3F32.7040700@tieto.com> (sfid-20120323_101536_746751_1F793E8F)
Date: Fri, 23 Mar 2012 10:15:30 +0100
From: =?UTF-8?B?TWljaGHFgiBLYXppb3I=?= <michal.kazior@tieto.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 11/12] mac80211: split offchannel functions to per-vif
References: <ccb26d54-38f2-478e-95d9-85fa1aea62c2@FIVLA-EXHUB02.eu.tieto.com>	 (sfid-20120320_154026_591857_E0DB8EEA) <1332492804.3506.7.camel@jlt3.sipsolutions.net>
In-Reply-To: <1332492804.3506.7.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> This seems very odd. Why would one vif be off-channel, and the other be
> on-channel? That makes no sense, off-channel is a global state.

Should mac80211 care if the device does channel-hopping? What if it's 
possible for off-channel to be done simultaneously because the device 
has two radios?

Maybe off-channel should also be reworked more to support multiple 
scenarios?


> My thinking here right now is that mac80211-based off-channel and
> scanning will only be supported for devices that don't implement
> multi-channel, since all others really need to do the channel scheduling
> themselves.

Software off-channel isn't used only for scanning, or is it?


-- Pozdrawiam / Best Regards, Michal Kazior.
