Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:21553 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab2ABRrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 12:47:07 -0500
Message-ID: <4F01D838.1000909@qca.qualcomm.com> (sfid-20120102_184711_380614_CF42F828)
Date: Mon, 2 Jan 2012 18:15:52 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Add del_station cfg80211_ops
References: <20111227090256.GA14371@jouni.qca.qualcomm.com>
In-Reply-To: <20111227090256.GA14371@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/27/2011 11:02 AM, Jouni Malinen wrote:
> hostapd/wpa_supplicant AP mode uses this operation to flush the station
> entries. Implement this in ath6kl to avoid unnecessary warnings from
> NL80211_CMD_DEL_STATION failing.
> 
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>

Thanks, applied.

Kalle
