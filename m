Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25806 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab2CFPit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 10:38:49 -0500
Message-ID: <4F562F84.6010107@qca.qualcomm.com> (sfid-20120306_163903_659575_1A6F6D68)
Date: Tue, 6 Mar 2012 17:38:44 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Bala Shanmugam <bkamatch@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Set background scan period.
References: <1330520884-15503-1-git-send-email-bkamatch@qca.qualcomm.com>
In-Reply-To: <1330520884-15503-1-git-send-email-bkamatch@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/29/2012 03:08 PM, Bala Shanmugam wrote:
> After connect command, send scan params WMI command to
> set background scan period. If period value is zero
> send 0xffff as bg scan period to disable bg scan.
> 
> This patch depends on below patch
> cfg80211: Add background scan period attribute.
> 
> Signed-off-by: Bala Shanmugam <bkamatch@qca.qualcomm.com>

I don't see the cfg80211 patch in wireless-next so I'm dropping this
patch. Please resend once the cfg80211 patch is applied.

Kalle
