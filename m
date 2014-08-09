Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34810 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaHIUud (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2014 16:50:33 -0400
Message-ID: <53E68995.1020005@candelatech.com> (sfid-20140809_225037_969631_7E72C268)
Date: Sat, 09 Aug 2014 13:50:29 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v6 0/8] ath10k: firmware crash dump
References: <20140809180552.29215.58612.stgit@potku.adurom.net>
In-Reply-To: <20140809180552.29215.58612.stgit@potku.adurom.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 08/09/2014 11:07 AM, Kalle Valo wrote:
> Next version of ath10k firmware crash dump feature, based on Ben's patches but
> heavily modified.
>
> v6:

I see no obvious problems.  If it passes basic testing, poke it upstream
and I'll start making my decode tool able to parse it (and package my CT
firmware with the BSS addrs/lengths..it is currently using a slightly
different IE format.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
