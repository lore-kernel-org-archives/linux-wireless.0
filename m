Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:52438 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065Ab1AGPxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Jan 2011 10:53:20 -0500
Message-ID: <4D2736DA.5090105@candelatech.com>
Date: Fri, 07 Jan 2011 07:52:58 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Peter Stuge <peter@stuge.se>
CC: "Luis R. Rodriguez" <lrodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] [PATCH 3/3] ath9k: Keep track of stations for	debugfs.
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com> <1294361165-15308-3-git-send-email-greearb@candelatech.com> <AANLkTikjjKe96Ok09Yz1R_nqsoO+n-9X-abeF8VUoOwQ@mail.gmail.com> <4D267E4D.7000608@candelatech.com> <20110107024909.GD20431@tux> <4D2685CC.7020502@candelatech.com> <20110107153607.11061.qmail@stuge.se>
In-Reply-To: <20110107153607.11061.qmail@stuge.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/07/2011 07:36 AM, Peter Stuge wrote:
> Ben Greear wrote:
>>> but at least other clueless users would not go over stable limit
>>> you have found.
>>
>> I think it's very likely that the problems I find are general
>> issues that are just much easier to hit with lots of stations.
>
> I strongly support this. I recognize several of your problems from my
> attempts at using ath9k with only a single STA which was all but stable.

Please do (re)post the info against the latest wireless-testing.  It might
help me and others see something we're missing when trying to debug
problems we see ourselves.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
