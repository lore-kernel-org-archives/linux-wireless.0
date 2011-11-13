Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63880 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab1KMKur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Nov 2011 05:50:47 -0500
Message-ID: <4EBFA0FC.1040303@qca.qualcomm.com> (sfid-20111113_115049_935106_E0630B35)
Date: Sun, 13 Nov 2011 12:50:36 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath6kl: Fix bug in setting default key index for
 tx in AP mode
References: <1321023781-387-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1321023781-387-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/11/2011 05:03 PM, Vasanthakumar Thiagarajan wrote:
> vif->def_txkey_index is set to key_index in ath6kl_cfg80211_add_key().
> If the interface is configured with multiple static wep keys,
> vif->def_txkey_index would be holding the index of the last key configured,
> not the default tx key index. Remove this unnecessary default key index setting
> in ath6kl_cfg80211_add_key() to configure the right key index in WEP thereby
> make it work when multiple wep keys are configured.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, both patches applied.

Kalle
