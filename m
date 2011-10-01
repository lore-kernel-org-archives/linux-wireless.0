Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47749 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004Ab1JAJ0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 05:26:34 -0400
Message-ID: <4E86DCC2.4020008@qca.qualcomm.com> (sfid-20111001_112643_580288_100C955A)
Date: Sat, 1 Oct 2011 12:26:26 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: Enable force foreground scan in connected state
References: <1317461107-5611-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1317461107-5611-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/01/2011 12:25 PM, Vasanthakumar Thiagarajan wrote:
> This was disabled beacause there was a network stall
> issue when scan is issued. This issue does not happen
> with the new firmware, enable it back.

Please mention the firmware version which has the fix in the commit log.

Kalle
