Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:61196 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab2AIKrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 05:47:49 -0500
Message-ID: <4F0AC59E.6090008@qca.qualcomm.com> (sfid-20120109_114752_386951_DB6019EC)
Date: Mon, 9 Jan 2012 12:46:54 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Change ielen in ath6kl_add_new_sta() from u8
 to size_t
References: <1325584733-7854-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1325584733-7854-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/03/2012 11:58 AM, Vasanthakumar Thiagarajan wrote:
> Otherwise if (ielen <= ATH6KL_MAX_IE) is dead code. It looks safe to
> change the type of ielen from u8 to size_t instead of removing this
> if check, this ielen can have the length of more than one ies in future.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
