Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:58836 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760979AbXG0Ogt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2007 10:36:49 -0400
Message-ID: <46AA02FF.5020401@lwfinger.net>
Date: Fri, 27 Jul 2007 09:36:47 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	Bcm43xx-dev@lists.berlios.de
Subject: Re: A problem with shared interrupts
References: <46a90082./TQABjOfVYW1o6lY%Larry.Finger@lwfinger.net> <1185530070.4006.46.camel@johannes.berg>
In-Reply-To: <1185530070.4006.46.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2007-07-26 at 15:13 -0500, Larry Finger wrote:
>> Michael,
>>
>> When I try the -mb tree on my old i386 notebook, I get an "irq 11: nobody cared"
>> message and interrupts for the bcm43xx-mac80211 device are not initialized.
> 
> Hm. Just a thought about something related: do you have 'debug shared
> interrupts' on?

No I didn't. Thanks for the suggestion.

Larry
