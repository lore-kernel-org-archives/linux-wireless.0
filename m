Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12796 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933113Ab1IBJK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Sep 2011 05:10:28 -0400
Date: Fri, 2 Sep 2011 14:40:45 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath9k_hw: Fix rx latency of 11a mode
Message-ID: <20110902091044.GA9912@vmraj-lnx.users.atheros.com> (sfid-20110902_111031_962762_8A94AD1D)
References: <1314767850-1112-1-git-send-email-rmanohar@qca.qualcomm.com>
 <20110831174512.GC2474@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110831174512.GC2474@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 31, 2011 at 01:45:12PM -0400, John W. Linville wrote:
> On Wed, Aug 31, 2011 at 10:47:30AM +0530, Rajkumar Manoharan wrote:
> > Rx latecy to start signal(usec) of 11a is 41 not 37 and
> > also corrected the rx delay in quarter rate.
> > 
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> 
> Do you still want 'ath9k_hw: Fix slottime with coverage class" merged
> as well?
>
As per the comments from the Felix, it was left intentionally to improve
the throughtput. So please drop that patch.

--
Rajkumar
