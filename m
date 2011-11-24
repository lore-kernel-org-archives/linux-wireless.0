Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38190 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab1KXTRC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 14:17:02 -0500
Message-ID: <4ECE9825.8070208@candelatech.com> (sfid-20111124_201706_747578_B3FB92D8)
Date: Thu, 24 Nov 2011 11:16:53 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v10 2/2] mac80211:  Support ht-cap over-rides.
References: <1321644720-8245-1-git-send-email-greearb@candelatech.com>  <1321644720-8245-2-git-send-email-greearb@candelatech.com>  (sfid-20111118_203218_329178_9FB3658A) <1321648257.10266.77.camel@jlt3.sipsolutions.net>  <4EC6C36D.4070900@candelatech.com> <1322142597.5366.19.camel@jlt3.sipsolutions.net>
In-Reply-To: <1322142597.5366.19.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2011 05:49 AM, Johannes Berg wrote:
> Please fix:
>
> net/mac80211/ht.c:31:6: warning: symbol '__check_htcap_disable' was not
> declared. Should it be static?

I sent a patch to make this static, but I do not see the warning.  Are you
running something other than a standard 'make bzImage modules' to
see this warning?

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
