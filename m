Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61482 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab2H0ONU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 10:13:20 -0400
Message-ID: <503B8079.6020802@qca.qualcomm.com> (sfid-20120827_161324_781693_E234ADDF)
Date: Mon, 27 Aug 2012 17:13:13 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] Revert "ath6kl: protect firmware from excessive WoW pattern
 length"
References: <1346076721-32081-1-git-send-email-kvalo@qca.qualcomm.com>
In-Reply-To: <1346076721-32081-1-git-send-email-kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/27/2012 05:12 PM, Kalle Valo wrote:
> This reverts commit d9070af7d48985324c1896a4758230c2bfe59f3c.
> 
> Thomas requested this in 20120820181837.GA4695@pista as Johannes
> pointed out that cfg80211 already checks this.

Applied to ath6kl.git.

Kalle
