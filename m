Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36022 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834Ab2B1Iml (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Feb 2012 03:42:41 -0500
Message-ID: <4F4C9358.1070800@qca.qualcomm.com> (sfid-20120228_094246_177625_DD7F7ED7)
Date: Tue, 28 Feb 2012 10:42:00 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Make foreground scan a deterministic one
References: <1329818442-5095-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1329818442-5095-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/21/2012 12:00 PM, Vasanthakumar Thiagarajan wrote:
> This makes the device get into scan state as soon as a
> scan request is received, instead of blocking the scan
> request till the traffic comes down. It is  necessary
> for the deterministic foreground scan particularly when
> having multiple vif operating where, if the scan is non-
> deterministic, scan on one interface will not start
> as long as there are traffic on the other interface. This
> change passes 50 msec as foreground scan interval to fix this.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
