Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1278 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab2IEQWI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 12:22:08 -0400
Message-ID: <50477C1C.6020209@broadcom.com> (sfid-20120905_182212_827776_2139C3A1)
Date: Wed, 5 Sep 2012 18:21:48 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wext: include wireless event id when it has a size
 problem
References: <1345812212-18778-1-git-send-email-arend@broadcom.com> (
 sfid-20120824_144347_019489_948E84F3)
 <1346854421.4364.21.camel@jlt4.sipsolutions.net>
In-Reply-To: <1346854421.4364.21.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2012 04:13 PM, Johannes Berg wrote:
> On Fri, 2012-08-24 at 14:43 +0200, Arend van Spriel wrote:
>> The wext code checks is the event data is within size limits.
>> When this check fails a message is logged with violating size.
>> This patch adds the event id to put us on the right track for
>> resolving that violation.
>>
>> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>> ---
>> Maybe wext is not popular, but I found the change helpful debugging
>> so others may benefit from it. Still some wireless apps default to
>> it, eg. wpa_supplicant.
>
> I don't even want to know what you're debugging, but I applied it
> anyway.
>
> FWIW, wext isn't just "not popular", it's "pretty much dead" :-)
>
> johannes
>
>

We got the "Wireless Event too big" message and were wondering what 
event from our driver was causing it. I agree wext is pretty much dead 
although wpa_supplicant still defaults to that driver. At least in most 
distro's it seems to be so.

Gr. AvS

