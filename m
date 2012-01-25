Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52073 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab2AYQDo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 11:03:44 -0500
Date: Wed, 25 Jan 2012 21:33:22 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V2 1/6] ath6kl: Make sure to delete rx aggregation timer
 in aggr_reset_state()
Message-ID: <20120125160320.GA4888@chvasanth-lnx> (sfid-20120125_170348_052482_AF9C35E6)
References: <1327139573-7435-1-git-send-email-vthiagar@qca.qualcomm.com>
 <4F1EA5F0.50908@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4F1EA5F0.50908@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 24, 2012 at 02:37:04PM +0200, Kalle Valo wrote:
> On 01/21/2012 11:52 AM, Vasanthakumar Thiagarajan wrote:
> > The timer which is used to flush rx aggregation frames needs to
> > be disabled when resetting the aggregation state. This is found
> > in code review.
> > 
> > Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> 
> Thanks, all six patches applied.

I'm really sorry that this patch set introduces a crash in accessing
invalid pointer through vif->aggr_cntxt. I'll send the next version
fixing this.

Vasanth
