Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43062 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938Ab2HNO3Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2012 10:29:25 -0400
Message-ID: <502A60BB.7000106@qca.qualcomm.com> (sfid-20120814_162936_602813_68B73A4A)
Date: Tue, 14 Aug 2012 17:29:15 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH V2 1/2] ath6kl: Fix potential skb double free in ath6kl_wmi_sync_point()
References: <1344919234-5012-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1344919234-5012-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/14/2012 07:40 AM, Vasanthakumar Thiagarajan wrote:
> skb given to ath6kl_control_tx() is owned by ath6kl_control_tx().
> Calling function should not free the skb for error cases.
> This is found during code review.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, both applied. There was a checkpatch warning about parenthesis
alignment in the first patch but I fixed it.

Kalle
