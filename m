Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32147 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755227Ab2AYQWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jan 2012 11:22:54 -0500
Message-ID: <4F202C59.9020800@qca.qualcomm.com> (sfid-20120125_172257_940856_FAA9088D)
Date: Wed, 25 Jan 2012 18:22:49 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V2 1/6] ath6kl: Make sure to delete rx aggregation timer
 in aggr_reset_state()
References: <1327139573-7435-1-git-send-email-vthiagar@qca.qualcomm.com> <4F1EA5F0.50908@qca.qualcomm.com> <20120125160320.GA4888@chvasanth-lnx>
In-Reply-To: <20120125160320.GA4888@chvasanth-lnx>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/25/2012 06:03 PM, Vasanthakumar Thiagarajan wrote:
> On Tue, Jan 24, 2012 at 02:37:04PM +0200, Kalle Valo wrote:
>> On 01/21/2012 11:52 AM, Vasanthakumar Thiagarajan wrote:
>>> The timer which is used to flush rx aggregation frames needs to
>>> be disabled when resetting the aggregation state. This is found
>>> in code review.
>>>
>>> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
>>
>> Thanks, all six patches applied.
> 
> I'm really sorry that this patch set introduces a crash in accessing
> invalid pointer through vif->aggr_cntxt. I'll send the next version
> fixing this.

Sorry, it's too late as I have already applied the patches. You need to
create a new patch on top of ath6kl.git which fixes the issue.

Kalle
