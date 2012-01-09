Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:9503 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933046Ab2AITrT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 14:47:19 -0500
Message-ID: <4F0B43DF.4090703@qca.qualcomm.com> (sfid-20120109_204722_963674_2AD58647)
Date: Mon, 9 Jan 2012 21:45:35 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 7/8] ath6kl: Removed unused ATH6KL_CONF_SUSPEND_CUTPOWER
 macro
References: <1326098182-9103-1-git-send-email-rmani@qca.qualcomm.com> <1326098182-9103-8-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1326098182-9103-8-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/09/2012 10:36 AM, rmani@qca.qualcomm.com wrote:
> From: Raja Mani <rmani@qca.qualcomm.com>
> 
> Title says everything.

You can fold this with patch 1 where you remove the code using this define.

Kalle
