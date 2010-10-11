Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:60252 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925Ab0JKSsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 14:48:53 -0400
Message-ID: <4CB35C11.6050705@candelatech.com>
Date: Mon, 11 Oct 2010 11:48:49 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] wireless:  Support wiphy_renamed hook for drivers.
References: <1286822537-28756-1-git-send-email-greearb@candelatech.com>	 <1286822639.3634.84.camel@jlt3.sipsolutions.net> <1286822771.3634.85.camel@jlt3.sipsolutions.net>
In-Reply-To: <1286822771.3634.85.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/11/2010 11:46 AM, Johannes Berg wrote:
> I think you should just do this (untested):

That seems fine to me..I guess any existing users of ath5k debugfs
should just not admit they are using it in the first place and silently fix
their scripts? :)

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

