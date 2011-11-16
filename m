Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57639 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab1KPIpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Nov 2011 03:45:10 -0500
Message-ID: <4EC37784.3020006@qca.qualcomm.com> (sfid-20111116_094514_516302_2A061D48)
Date: Wed, 16 Nov 2011 10:42:44 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Raja Mani <rmani@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Clear WPS ctrl flag if zero length IE is received
 from CFG
References: <1321346696-6127-1-git-send-email-rmani@qca.qualcomm.com>
In-Reply-To: <1321346696-6127-1-git-send-email-rmani@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/2011 10:44 AM, Raja Mani wrote:
> Connect control flag CONNECT_WPS_FLAG has to be cleared
> by default even if the driver receives zero length IE
> from CFG.
> 
> Otherwise this flag would be always set after WPS exchange
> which would lead wpa_supplicant to fail to connect with
> the received WPS credentials. This issue is observed only
> in OPEN security.

Thanks, applied. But I did a s/CFG/cfg80211/ in the commit log.

Kalle
