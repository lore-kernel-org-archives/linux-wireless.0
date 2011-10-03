Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20320 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab1JCKfZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Oct 2011 06:35:25 -0400
Message-ID: <4E898F75.40209@qca.qualcomm.com> (sfid-20111003_123528_586235_A665549B)
Date: Mon, 3 Oct 2011 13:33:25 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH V2] ath6kl: Enable force foreground scan in connected
 state
References: <1317465756-5978-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1317465756-5978-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/01/2011 01:42 PM, Vasanthakumar Thiagarajan wrote:
> This was disabled beacause there was a network stall
> issue when scan is issued. This issue does not happen
> with the new firmware (3.1.1.609), enable it back.

Thanks, applied.

Kalle
