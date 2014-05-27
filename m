Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:40012 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaE0RBr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 13:01:47 -0400
Message-ID: <5384C4FA.90202@candelatech.com> (sfid-20140527_190150_035749_94290093)
Date: Tue, 27 May 2014 10:01:46 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: cprevotaux@nltinc.com
CC: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: fix a memory leak on sta rate selection table
References: <1400866194-62234-1-git-send-email-nbd@openwrt.org> <5384BEAF.1030803@candelatech.com> <5384C00C.4020507@nltinc.com>
In-Reply-To: <5384C00C.4020507@nltinc.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/27/2014 09:40 AM, Christophe Prevotaux wrote:
> Hi Ben,
> 
> In terms of OpenWRT world, at least backfire, did not go further back in checking. I suspect it is much older than this though :) But I did
> put on my spelunking head lamp and I am afraid of the dark :)

A quick look makes me think it is at least not relevant to 3.9 kernels,
but I could be wrong about that.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

