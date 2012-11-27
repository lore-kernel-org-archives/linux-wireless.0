Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:63459 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879Ab2K0Tpv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 14:45:51 -0500
Cc: <ath6kl-devel@qca.qualcomm.com>, <linux-wireless@vger.kernel.org>,
	wei-jen jlin <jenlin@qca.qualcomm.com>
Message-ID: <50B51866.7050803@qca.qualcomm.com> (sfid-20121127_204554_891619_59F84D0E)
Date: Tue, 27 Nov 2012 21:45:42 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: Re: [PATCH 1/8] ath6kl: Remove erroneous flag clearing
References: <1353070301-5902-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1353070301-5902-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/16/2012 02:51 PM, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> WLAN_ENABLED is vif specific, not part of
> the driver's struct ath6kl. Proper clearing
> of this flag is already taken care in
> ath6kl_cleanup_vif.
> 
> Cc: wei-jen jlin <jenlin@qca.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Thanks, all eight patches applied.

Kalle
