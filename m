Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2686 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759119Ab2LIWfQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Dec 2012 17:35:16 -0500
Message-ID: <50C51219.2090900@broadcom.com> (sfid-20121209_233526_579140_E9892BF7)
Date: Sun, 9 Dec 2012 23:35:05 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Maximilian Engelhardt" <maxi@daemonizer.de>,
	brcm80211-dev-list@broadcom.com,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: WLAN not working anymore after changing the MAC address
References: <201212090940.38269.maxi@daemonizer.de>
 <50C4CFDA.5020900@broadcom.com>
 <1355077493.9878.0.camel@jlt4.sipsolutions.net> (
 sfid-20121209_192436_572441_F392233B)
 <1355077540.9878.1.camel@jlt4.sipsolutions.net>
In-Reply-To: <1355077540.9878.1.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/2012 07:25 PM, Johannes Berg wrote:
> On Sun, 2012-12-09 at 19:24 +0100, Johannes Berg wrote:
>> On Sun, 2012-12-09 at 18:52 +0100, Arend van Spriel wrote:
>>
>>>> After changing the MAC address of my wireless network interface it
>>>> doesn't work anymore. I would very much like to change the MAC
>>>> address to avoid being traceable by it. Steps how this can be
>>>> reproduced are shown below. Here is first some information about my
>>>> Hardware and test setup:
>>>>
>>>
>>> How is this supposed to be distributed to the driver? I have been
>>> looking in the mac80211 interface. The only callback that I can think
>>> is is the change_interface() callback although the documentation does
>>> state this is only for changing the interface type. Or is it to be
>>> done upon add_interface()?
>>
>> You should read the interface address in add_interface and basically
> 
> read ... well that came out wrong. I mean use vif->addr.

Thanks, Johannes

I got the idea of it.

Gr. AvS


