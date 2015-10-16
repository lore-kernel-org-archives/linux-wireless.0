Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:46639 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbbJPNBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Oct 2015 09:01:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <c_traja@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2 v2] ath10k: Make fw stats prints specific to firmware version
References: <1444812821-11138-1-git-send-email-c_traja@qti.qualcomm.com>
Date: Fri, 16 Oct 2015 16:01:34 +0300
In-Reply-To: <1444812821-11138-1-git-send-email-c_traja@qti.qualcomm.com> (c.
	traja's message of "Wed, 14 Oct 2015 14:23:41 +0530")
Message-ID: <87lhb3ge6p.fsf@kamboji.qca.qualcomm.com> (sfid-20151016_150216_784145_DEF2A177)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<c_traja@qti.qualcomm.com> writes:

> From: Manikanta <c_mpubbi@qti.qualcomm.com>
>
> The patch makes debug stats prints fw specific by adding a new member
> in wmi_ops
>
> Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>

This patch added few checkpatch warnings, I fixed them in the pending
branch.

drivers/net/wireless/ath/ath10k/wmi-ops.h:1297: Alignment should match open parenthesis
drivers/net/wireless/ath/ath10k/wmi.c:6628: Missing a blank line after declarations
drivers/net/wireless/ath/ath10k/wmi.c:6638: Missing a blank line after declarations

Also I fixed Manikanta's name and added his Signed-off-by line which you
had accidentally dropped.

-- 
Kalle Valo
