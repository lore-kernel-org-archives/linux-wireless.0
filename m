Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-ca-4.exch022.serverdata.net ([64.78.56.56]:59731 "EHLO
	HUB022-ca-4.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755554Ab3DJJzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 05:55:39 -0400
Message-ID: <51653716.1080804@posedge.com> (sfid-20130410_115543_264077_03B41B83)
Date: Wed, 10 Apr 2013 15:25:34 +0530
From: Vivekananda Holla <vivekanandah@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Patch] mac80211: SMPS for AP Mode
References: <516528C8.90509@posedge.com>  (sfid-20130410_105443_117821_9F07C071) <1365584151.8388.0.camel@jlt4.sipsolutions.net>  <5165326C.7010706@posedge.com>  <1365587182.8388.2.camel@jlt4.sipsolutions.net>  (sfid-20130410_114635_305806_9CD71018) <1365587230.8388.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1365587230.8388.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi Johannes,

thanks for the clarification.
I will update the patch and send it again.

thanks and regards
Vivek
 
On 04/10/2013 03:17 PM, Johannes Berg wrote:
> On Wed, 2013-04-10 at 11:46 +0200, Johannes Berg wrote:
>> On Wed, 2013-04-10 at 15:05 +0530, Vivekananda Holla wrote:
>>> hi Johannes,
>>>
>>> do you mean the IEEE80211_TX_RC_USE_RTS_CTS flag to set RTS/CTS
>>> protection for the packet?
>>>
>>> I did not use this based on the below understanding
>>>
>>> my understanding for SMPS is that a station system does not need to
>>> send an RTS packet before frame transmission for SMPS however an AP
>>> system needs to send out an RTS frame.
>> No? Where did you get that idea? It's wrong, it doesn't matter whether
>> it's AP or not.
> Of course, APs will rarely use SMPS, so stations almost never have to
> deal with an AP that uses it ...
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

