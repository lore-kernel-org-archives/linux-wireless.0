Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:19185 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbcF3LAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 07:00:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: Enable beacon loss detection support for 10.4
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1466081684-8074-1-git-send-email-mohammed@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <mohammed@codeaurora.org>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Message-ID: <f1028a60ba004c749ae647ad38c7382a@euamsexm01a.eu.qualcomm.com> (sfid-20160630_130048_758998_8712EA43)
Date: Thu, 30 Jun 2016 13:00:05 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> Enable beacon loss detection support for 10.4 by handling
> roam event. With this change QCA99X0 station is able to
> detect beacon loss when the AP is powered off
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

343bf960f03c ath10k: enable beacon loss detection support for 10.4

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9180777/

