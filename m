Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:52690 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753981AbdLGOcs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 09:32:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [2/3] ath9k: move spectral scan support under a separate config
 symbol
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1c982c915065a9b5ed3232eedb567f589eca261b.1511804622.git.mschiffer@universe-factory.net>
References: <1c982c915065a9b5ed3232eedb567f589eca261b.1511804622.git.mschiffer@universe-factory.net>
To: Matthias Schiffer <mschiffer@universe-factory.net>
CC: <ath9k-devel@qca.qualcomm.com>, <ath10k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nbd@nbd.name>
Message-ID: <39b862cad21f42aa9cf855c465216cab@euamsexm01a.eu.qualcomm.com> (sfid-20171207_153327_158450_CB4974C2)
Date: Thu, 7 Dec 2017 15:32:36 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Matthias Schiffer <mschiffer@universe-factory.net> wrote:

> At the moment, spectral scan support, and with it RELAY, is always enabled
> with ATH9K[_HTC]_DEBUGFS. Spectral scan support is currently the only user
> of RELAY in ath9k, and it unconditionally reserves a relay channel.
> 
> Having debugfs support in ath9k is often useful even on very small embedded
> routers, where we'd rather like to avoid the code size and RAM usage of the
> relay support.
> 
> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

2 patches applied to ath-next branch of ath.git, thanks.

9df7ddc3ed25 ath9k: move spectral scan support under a separate config symbol
42e01cb9cb10 ath10k: move spectral scan support under a separate config symbol

-- 
https://patchwork.kernel.org/patch/10077735/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
