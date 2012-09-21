Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:14076 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab2IUQoU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 12:44:20 -0400
Message-ID: <505C995A.602@qca.qualcomm.com> (sfid-20120921_184423_651322_37AAD74C)
Date: Fri, 21 Sep 2012 19:44:10 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix reconnection issue after recovery
References: <1347345420-16216-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1347345420-16216-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/11/2012 09:37 AM, Vasanthakumar Thiagarajan wrote:
> Disallowing any wmi commands while re-initializing the
> firmware results in connection failures after recovery
> is done in open/WEP mode. To fix this, clear WMI_READY,
> to make sure no wmi command is tried while fw is down.
> Remove ATH6KL_STATE_RECOVERY state check in ath6kl_control_tx()
> so that any configuration during fw init time will go through
> using wmi commands.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
