Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4051 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967470Ab2EPN0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 09:26:33 -0400
Message-ID: <4FB3AB00.2080709@qca.qualcomm.com> (sfid-20120516_152636_618408_4C71C40A)
Date: Wed, 16 May 2012 16:26:24 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Naveen Singh <navesing@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Include match ssid list in scheduled scan
References: <1337164140-16098-1-git-send-email-kvalo@qca.qualcomm.com>
In-Reply-To: <1337164140-16098-1-git-send-email-kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2012 01:29 PM, Kalle Valo wrote:
> From: Naveen Singh <navesing@qca.qualcomm.com>
> 
> Scheduled scan implementation was only taking probed list into
> consideration. The matched list was dropped. This would cause
> FW not to report the AP as the list never had that AP's SSID
> populated. This was causing long connection time when supplicant
> would just issue a wild card SSID in probed list. As a part of
> this implementation, ath6kl driver would create a complete list
> by taking both probed and matched list and pass it to FW. FW would
> probe for the SSID that it needs to and would match against the
> relevant SSIDS that is been configured.
> 
> kvalo: whitespace changes, less indentation in the for loop, use ++
> 
> Signed-off-by: Naveen Singh <navesing@qca.qualcomm.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

Applied.

Kalle
