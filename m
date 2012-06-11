Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6221 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab2FKNMj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 09:12:39 -0400
Message-ID: <4FD5EEC1.9020206@qca.qualcomm.com> (sfid-20120611_151242_262029_0264F6FD)
Date: Mon, 11 Jun 2012 16:12:33 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Etay Luz <eluz@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath6kl: support changing dtim period on AP mode
References: <1338366908-4654-1-git-send-email-kvalo@qca.qualcomm.com>
In-Reply-To: <1338366908-4654-1-git-send-email-kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/30/2012 11:35 AM, Kalle Valo wrote:
> From: Etay Luz <eluz@qca.qualcomm.com>
> 
> This patch adds support for dtim_period configuration in beacon.
> 
> kvalo: add a comment about ignoring the error, use vif_idx,
> add \n to the warning message
> 
> Signed-off-by: Etay Luz <eluz@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Thanks, applied.

Kalle
