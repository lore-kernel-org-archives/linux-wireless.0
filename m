Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2754 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753583Ab3B0MsR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 07:48:17 -0500
Message-ID: <512E0087.4070006@broadcom.com> (sfid-20130227_134821_749316_FED26147)
Date: Wed, 27 Feb 2013 13:48:07 +0100
From: "Piotr Haber" <phaber@broadcom.com>
MIME-Version: 1.0
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] cfg80211: advertise extended capabilities to
 userspace
References: <1360677682-3694-1-git-send-email-johannes@sipsolutions.net>
 <512DFC54.60602@broadcom.com> (sfid-20130227_133040_714989_9A702E8E)
 <1361968360.8172.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1361968360.8172.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/27/13 13:32, Johannes Berg wrote:
> On Wed, 2013-02-27 at 13:30 +0100, Piotr Haber wrote:
> 
>> seems like this patch pushed wiphy info length over the limit
>> for dual band devices.
>> So userspace cannot get any info about phy capabilities.
> 
> Yeah ... was it this patch? I did revert some others, but I guess it
> depends.
did not bisect, but that was the last big thing added there

>> I know there is a patch for nl80211 and iw to allow splitting of this info,
>> but it is not in 3.8
>> Should we not revert it for stable then?
> 
> Yeah we can revert this too, a la the patches already in to remove TCP
> wakeup and radar info. What kernel are you testing?
> 
i have one built from wireless-testing master-2013-02-19

