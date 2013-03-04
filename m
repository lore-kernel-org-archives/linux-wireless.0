Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3489 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373Ab3CDIaf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 03:30:35 -0500
Message-ID: <51345B80.3020108@broadcom.com> (sfid-20130304_093047_103707_7C50FD6E)
Date: Mon, 4 Mar 2013 09:29:52 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 05/13] brcmfmac: only do auth_type workaround when
 no WPA or RSN IE is provided
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
 <1362311132-29561-6-git-send-email-arend@broadcom.com> (
 sfid-20130303_124611_530276_DB95CBBF)
 <1362331252.8226.2.camel@jlt4.sipsolutions.net>
 <5133A8D2.9090100@broadcom.com>
 <1362342943.8226.3.camel@jlt4.sipsolutions.net>
In-Reply-To: <1362342943.8226.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/03/13 21:35, Johannes Berg wrote:
> On Sun, 2013-03-03 at 20:47 +0100, Arend van Spriel wrote:
>> On 03/03/13 18:20, Johannes Berg wrote:
>>> On Sun, 2013-03-03 at 12:45 +0100, Arend van Spriel wrote:
>>>> The workaround is only needed when auth_type is automatic AND there is
>>>> no WPA or RSN information element provided by cfg80211.
>>>
>>> Does this really actually happen? Why would wpa_s select automatic when
>>> it knows it's going to be open?
>>>
>
>> You are right and it does not happen with wpa_s. However, it does
>> 'actually really happen' :-)
>
> :-)
> Just curious.
>
>> when using iw to connect to an unsecure AP.
>
> Right but then checking for RSN/WPA won't make a difference? I guess I
> don't really understand the code, so you better ignore me ;-)

Hi Johannes,

I would not go that far. I guess what you are really asking is whether 
auth_type will ever be set to automatic when we do get a RSN/WPA ie and 
I have to admit you got a point there.

John,

Can you pull this patch out of the series.

Regards,
Arend

