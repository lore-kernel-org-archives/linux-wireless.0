Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34100 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752206AbdG1OYm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Jul 2017 10:24:42 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,01/21] rsi: use BUILD_BUG_ON check for fsm_state
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1499351844-2046-2-git-send-email-amitkarwar@gmail.com>
References: <1499351844-2046-2-git-send-email-amitkarwar@gmail.com>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Message-Id: <20170728142441.6E22F6128F@smtp.codeaurora.org> (sfid-20170728_162450_652712_2BAD6B5F)
Date: Fri, 28 Jul 2017 14:24:36 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <amitkarwar@gmail.com> wrote:

> From: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> 
> Whenever new fsm_state enum element is added, fsm_state array
> also needs to be updated. If this change is missed, we may end
> up doing invalid access in array. BUILD_BUG_ON check will help
> to avoid this problem.
> 
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

21 patches applied to wireless-drivers-next.git, thanks.

e0d0ae8a4304 rsi: use BUILD_BUG_ON check for fsm_state
09cfb41f3579 rsi: changes in eeprom read frame
f95bbd979df7 rsi: fix sdio card reset problem
49ddac0d4b80 rsi: chip reset for SDIO interface
f746606a51ed rsi: correct SDIO disconnect path handling
ea0676c47085 rsi: card reset for USB interface
ed833be6faa0 rsi: USB tx headroom cleanup
ac6107caa0d8 rsi: correct the logic of deriving queue number
5d16a1c1ae11 rsi: rename USB endpoint macros
d1f69e418f66 rsi: choose correct endpoint based on queue.
015240018b0a rsi: set immediate wakeup bit
de2dea16ec9f rsi: management frame descriptor preparation cleanup
6507de6df900 rsi: separate function for management packet descriptor
af1930977678 rsi: data packet descriptor code cleanup
0eb42586cf87 rsi: data packet descriptor enhancements
ceb2e4eab994 rsi: separate function for data packet descriptor
5f6ae7cae211 rsi: rename variable in_sdio_litefi_irq
72bccf51d459 rsi: Optimise sdio claim and release host
ebf084ea0ec7 rsi: SDIO Rx packet processing enhancement
6c409cad3d2b rsi: use separate mutex lock for receive thread
cb16453565f8 rsi: Rename mutex tx_rxlock to the tx_lock.

-- 
https://patchwork.kernel.org/patch/9828403/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
