Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62352 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab1IWHvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Sep 2011 03:51:11 -0400
Message-ID: <4E7C3A66.7040509@qca.qualcomm.com> (sfid-20110923_095114_416739_B6552C09)
Date: Fri, 23 Sep 2011 10:51:02 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2] ath6kl: Fix disconnect event reporting
References: <1316755670-1795-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1316755670-1795-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2011 08:27 AM, Vasanthakumar Thiagarajan wrote:
> Driver does not report disconnect event properly when in connecting state,
> this leads to issues failures in starting reconnection. Send a disconnect
> command to target when a disconnect event is received with reason code
> other than 3 (DISCONNECT_CMD - disconnect request from host) to make the
> frimware stop trying to connect even after giving disconnect event. There
> will be one more disconnect event for this disconnect command with reason
> code DISCONNECT_CMD which will be notified to cfg80211.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
> ---
> 
> V2 -- Add commands in code and change in commit log

Perfect, thanks. Patch applied.

Kalle
