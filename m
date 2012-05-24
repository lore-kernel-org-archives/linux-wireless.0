Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57351 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787Ab2EXHNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 03:13:08 -0400
Message-ID: <4FBDDF7E.3050104@qca.qualcomm.com> (sfid-20120524_091339_270163_8C9C89FA)
Date: Thu, 24 May 2012 10:13:02 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix missing gpio pin 9 configuration
References: <1337671370-32519-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1337671370-32519-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/22/2012 10:22 AM, Vasanthakumar Thiagarajan wrote:
> GPIO pin 9 also needs to be configured along with other gpio
> pins to avoid sdio crc errors. I've not experienced any issue
> with missing this particular gpio pin configuration, found dunring
> code review. This can potentially improve rx performance.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, applied.

Kalle
