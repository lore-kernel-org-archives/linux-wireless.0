Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5053 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab1I1Nwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Sep 2011 09:52:34 -0400
Date: Wed, 28 Sep 2011 17:08:05 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath9k: Update rate control for better performance at
 higer rates
Message-ID: <20110928113804.GA3412@vmraj-lnx.users.atheros.com> (sfid-20110928_155253_124135_C8551D07)
References: <1317135241-3523-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1317135241-3523-1-git-send-email-rmanohar@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 27, 2011 at 08:24:01PM +0530, Rajkumar Manoharan wrote:
> The rate control algorithm is updated as follows in order to improve
> the performance at higher rates. Probe the next allowed phy state
> only when current rate is max phy and current PER is lower enough.
> If the current rate is at max phy and current rate's expected throughput
> is lower than next lower rate's expected throughput then drop the rate.
> 
> Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/rc.c |   23 ++++++++++++++++++++---
>  1 files changed, 20 insertions(+), 3 deletions(-)
>
Please drop this patch. Need to do some more testing with this patch,
will send v2 patch.

--
Rajkumar
