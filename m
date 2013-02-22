Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41429 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755730Ab3BVEme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2013 23:42:34 -0500
Message-ID: <5126F732.6040007@candelatech.com> (sfid-20130222_054241_518186_2411CE2A)
Date: Thu, 21 Feb 2013 20:42:26 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [RFC] ath9k:  Detect and work-around tx-queue hang.
References: <1361498797-14361-1-git-send-email-greearb@candelatech.com> <20774.62475.588131.344540@gargle.gargle.HOWL>
In-Reply-To: <20774.62475.588131.344540@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/21/2013 08:28 PM, Sujith Manoharan wrote:
> Hi,
>
> This is definitely a work-around. :)
> I think we should debug a bit more to find out the actual bug rather than
> add more hacks to the already hackish TX poll routine.

I'll be happy to test patches, but I'm not sure how to go about
debugging the real problem on my own.  Maybe some stats could
be added to the xmit debugfs file to help diagnose the problem,
or maybe some other debugfs info will help?

I can't reproduce the problem with ath9k debugging set at the
previous suggested level, so it would have to be something
less invasive.

As for just stations going out of range, it remains locked up
even with signal level goes back to -20, so it's not just a simple
station-out-of range issues..

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

