Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:59293 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932494AbZHUXPf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 19:15:35 -0400
Message-ID: <4A8F2A96.6070408@gmx.de>
Date: Sat, 22 Aug 2009 01:15:34 +0200
From: Joerg Albert <jal2@gmx.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mac80211: reassociate in STA mode after AP was power-cycled
References: <4A8F0D8D.7000508@gmx.de> <1250889836.4600.21.camel@johannes.local>
In-Reply-To: <1250889836.4600.21.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/21/2009 11:23 PM, Johannes Berg wrote:
> On Fri, 2009-08-21 at 23:11 +0200, Joerg Albert wrote:
>> I had a ar9170usb device in STA mode associated to an AP and power-cycled the AP - slowly enough to get the
>> STA disassociated. 
>>
>> I wonder why the STA doesn't re-associate again to the AP once it's up again. Waited for 5+ minutes.
> 
> It told userspace that it disconnected, and as such it can't do anything
> any more. Just run wpa_supplicant.

Thanks, that helped. I wasn't aware that wpa_supplicant controls non-wpa connections, too.

Jörg.
