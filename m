Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2282 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753424Ab2DCS3M (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 14:29:12 -0400
Message-ID: <4F7B4120.8060406@broadcom.com> (sfid-20120403_202915_302086_FA733491)
Date: Tue, 3 Apr 2012 20:27:44 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Francesco Schiavarelli" <fschiava@libero.it>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] brcm80211: smac: do not mute tx in driver for
 restricted channels
References: <1332759460-4288-1-git-send-email-arend@broadcom.com>
 <4F762C1E.5050709@libero.it>
In-Reply-To: <4F762C1E.5050709@libero.it>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/30/2012 11:56 PM, Francesco Schiavarelli wrote:
> On 03/26/2012 12:57 PM, Arend van Spriel wrote:
>> The channels 12 and 13 were giving issues for user. It turned out
>> that channels 12 and 13 are considered restricted in brcmsmac and
>> as such the tx path was suspended. It should resume upon seeing
>> beacons on those channels, but this was not properly handled. This
>> patch removes mute of tx path.
>>
>> Cc: Francesco Saverio Schiavarelli<fschiava@libero.it>
>> Signed-off-by: Arend van Spriel<arend@broadcom.com>
> I applied your patch on top of compat-wireless and it fixes the
> reported problem, now I can successfully connect to my AP
> on channel 13.
>
> Is this patch going to be applied upstream?
> If you don't mind I would post it on the ml so that others can
> benefit from your fix.

Not yet applied. I will sent the fix out in a couple of days. Thanks for 
testing this.

Gr. AvS

