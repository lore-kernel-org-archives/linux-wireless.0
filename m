Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44326 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbbBMOEP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 09:04:15 -0500
Date: Fri, 13 Feb 2015 19:33:54 +0530
From: SenthilKumar Jegadeesan <sjegadee@qti.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Increase AST table SKID length limit
Message-ID: <20150213140352.GA3958@senthilj-ThinkPad-L430> (sfid-20150213_150422_408229_B0AC8EC8)
References: <1423733322-31113-1-git-send-email-sjegadee@qti.qualcomm.com>
 <54DCA6F1.90909@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <54DCA6F1.90909@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 12, 2015 at 05:13:21AM -0800, Ben Greear wrote:
> 
> 
> On 02/12/2015 01:28 AM, SenthilKumar Jegadeesan wrote:
> >The current SKID length configuration causes firmware
> >to reject peer creation for not able to allocate
> >AST entries for peers. This issue is observed when
> >least significant 3 bytes are used ramdomly to create
> >client MAC addresses.
> >
> >AST table SKID length configuration is increased to
> >maximum value to fix this issue.
> 
> If your firmware is like 10.1, then probably AST length should
> really be same as config.num_peers?
> 
> 10.1 firmware definitely has same or similar issue in it's
> AST table handling, for what that is worth.
> 
> Thanks,
> Ben

I agree. New patch will address this case.

Thanks,
Senthil J
