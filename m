Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:58118 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030816AbaDJNnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 09:43:09 -0400
Message-ID: <53469FD3.8040001@candelatech.com> (sfid-20140410_154314_290274_9EBA9132)
Date: Thu, 10 Apr 2014 06:42:43 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath10k: double check bmi xfer pointers
References: <53461A8A.4030209@candelatech.com> <1397124355-6321-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1397124355-6321-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/10/2014 03:05 AM, Michal Kazior wrote:
> If for some reason copy engine ring buffer became
> corrupt ath10k could crash the machine due to
> invalid pointer dereference. It's very unlikely
> but devices can never be fully trusted so verify
> if the bmi xfer pointer read back from copy engine
> matches the original pointer. The bug looked as
> follows:

Thanks for fixing this.  I'll add this patch to my
tree and run more tests today.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

