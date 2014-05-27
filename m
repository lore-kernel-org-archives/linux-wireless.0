Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51641 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbaE0U2b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 16:28:31 -0400
Message-ID: <5384F568.6030303@openwrt.org> (sfid-20140527_222847_686519_3AE70A74)
Date: Tue, 27 May 2014 22:28:24 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>, cprevotaux@nltinc.com
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix a memory leak on sta rate selection table
References: <1400866194-62234-1-git-send-email-nbd@openwrt.org> <5384BEAF.1030803@candelatech.com> <5384C00C.4020507@nltinc.com> <5384C4FA.90202@candelatech.com>
In-Reply-To: <5384C4FA.90202@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-05-27 19:01, Ben Greear wrote:
> On 05/27/2014 09:40 AM, Christophe Prevotaux wrote:
>> Hi Ben,
>> 
>> In terms of OpenWRT world, at least backfire, did not go further back in checking. I suspect it is much older than this though :) But I did
>> put on my spelunking head lamp and I am afraid of the dark :)
> 
> A quick look makes me think it is at least not relevant to 3.9 kernels,
> but I could be wrong about that.
Right, it applies to 3.10 and above.
Will resend with Cc stable.

- Felix

