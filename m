Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33167 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753732AbcFTUEX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 16:04:23 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/1] ath6kl: Fix SDIO broken scatter hif-scatter
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <6EA3E0BCC03CC34B89B01BD57ECBC718B17AFE41@POBOX.postoffice.danego.net>
To: =?utf-8?q?Robert_Deli=C3=ABn?= <robert@delien.nl>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kvalo@qca.qualcomm.com" <kvalo@qca.qualcomm.com>
Message-Id: <20160620200402.02AA861223@smtp.codeaurora.org> (sfid-20160620_220428_530245_3C37077E)
Date: Mon, 20 Jun 2016 20:04:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Robert Deliën wrote:

> This patch fixes broken hif-scatter in ath6kl SDIO. It is not my work; I have
> found it as a difference between two Digi distributed Kernel source trees. No
> commit comment was recorded. I am sure there are better/nicer/cleaner way,
> but copying it as I found it is yet another difference less in the future.
> Feel free to use it in any way you see fit.

Robert told me privately that this is fixed in latest versions. The patch has
been dropped.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/7567481/

