Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost02.isp.att.net ([204.127.217.102]:40375 "EHLO
	fmailhost02.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbZGRPCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 11:02:54 -0400
Message-ID: <4A61E436.9060808@lwfinger.net>
Date: Sat, 18 Jul 2009 10:03:18 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: WARN_ON at minstrel_get_rate (include/net/mac80211.h:2111) with
 p54usb
References: <4A611FC0.9040507@lwfinger.net> <200907181433.47985.chunkeey@web.de>
In-Reply-To: <200907181433.47985.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:
> On Saturday 18 July 2009 03:05:04 Larry Finger wrote:
>> Johannes and Christian,
>>
>> I am getting a WARN_ON from mac80211 in the location stated in the
>> subject. I put in some test prints and got the following:
>>
>> sband->n_bitrates 8, Band 1, supp_rates 0x0
> hmm, so something decides to talk to a 5GHz network here?
> But the AP doesn't have any available rates in that band!?

Ah, band 1 is 5GHz, not 2.4. There are no 802.11a AP's in my neighborhood.

> If my memory serves my right some people have triggered the same WARN_ON
> with the ath5k driver as well...
> unfortunately, I didn't follow the thread and now I can't find it anymore.
>  
> (btw: is your b43 11a capable as well?)

Yes it is, but that section is software crippled.

Thanks for the patch. I'll let you know what happens.

Larry
