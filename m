Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:38530 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933191AbaEGNgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2014 09:36:45 -0400
Message-ID: <536A36E5.6040100@candelatech.com> (sfid-20140507_153652_587170_9A66FC40)
Date: Wed, 07 May 2014 06:36:37 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Michal Kazior <michal.kazior@tieto.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	apenwarr@gmail.com
Subject: Re: [PATCH 0/2] ath10k: 2014-05-07 fixes
References: <1399466006-5556-1-git-send-email-michal.kazior@tieto.com>
In-Reply-To: <1399466006-5556-1-git-send-email-michal.kazior@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/07/2014 05:33 AM, Michal Kazior wrote:
> Hi,
> 
> These 2 patches address kernel panics reported by
> Avery recently. One of them was most likely
> reported by Ben some time ago already.
> 
> I've never seen these panics myself. It'd be great
> if you guys could give it a try and (assuming
> you're capable of reproducing) see if it actually
> helps.

I'll add these to my tree today and we'll run them through
our test harness.

I have not been able to repeat any crashes like this recently...but
I'll let you know if I see anything strange after applying
the patches.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

