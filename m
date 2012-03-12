Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:56294 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab2CLIAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 04:00:13 -0400
To: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
Message-ID: <4F5DAD01.9020008@qca.qualcomm.com> (sfid-20120312_090023_428342_F8D1CABE)
Date: Mon, 12 Mar 2012 10:00:01 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
CC: <ath6kl-devel@qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Fix merge error
References: <1331238302-4813-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
In-Reply-To: <1331238302-4813-1-git-send-email-aarthi.thiruvengadam@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/08/2012 10:25 PM, Aarthi Thiruvengadam wrote:
> Portion of the commit id 080eec4fb4 was overwritten by mistake due to a merge
> conflict. This patch fixes the code back to how it should be.
> 
> Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>

Thanks for catching this! I have applied the patch but did some changes
to the commit log:

commit 17a7b16df4ba8e71e149fcf31e0b639ff45ddf84
Author: Aarthi Thiruvengadam <aarthi.thiruvengadam@qca.qualcomm.com>
Date:   Thu Mar 8 12:25:02 2012 -0800

    ath6kl: Fix merge error in ath6kl_set_ies()

    Portion of the commit id 080eec4fb4 ("ath6kl: Clear the IE in firmware
    if not set") was overwritten by mistake due to a merge
    conflict. This patch fixes the code back to how it should be.

    kvalo: more details to the commit log

    Signed-off-by: Aarthi Thiruvengadam <athiruve@qca.qualcomm.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Kalle
