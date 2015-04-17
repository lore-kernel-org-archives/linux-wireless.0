Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:43642 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbDQALK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 20:11:10 -0400
Message-ID: <55304F9D.1060301@candelatech.com> (sfid-20150417_021114_321572_DF990F7F)
Date: Thu, 16 Apr 2015 17:11:09 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k to ath9k IBSS, ath9k has interface-combinations issue
References: <5523273F.4060803@candelatech.com> <CA+BoTQ=UUbfi5D9ZbN5Rxb20f5xpzuYQMo392=P++Qyhz8Hs+w@mail.gmail.com> <CALhHN=oCvQ=SvobWTvc3geK-66k2+YDzB1HqSguCxTeV0QzWwg@mail.gmail.com> <552406E4.50600@candelatech.com> <55241567.3010703@candelatech.com> <21796.40851.132919.363957@gargle.gargle.HOWL>
In-Reply-To: <21796.40851.132919.363957@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/07/2015 08:25 PM, Sujith Manoharan wrote:
> Ben Greear wrote:
>> For the third set, why limit to a single interface.  Can't we run IBSS + AP
>> (and plus stations, for that matter), all at the same time with ath9k?
> 
> TSF would jump around since the HW would sync with the
> received beacons and this will happen in both IBSS and station
> mode. Hence the limitation, but I think OpenWrt has a one-liner
> to remove this restriction...

It seems I can only do a single VAP on ath9k as well?

Is that per design?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

