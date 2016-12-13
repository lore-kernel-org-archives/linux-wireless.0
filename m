Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1618 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751769AbcLMNK6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 08:10:58 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v2 11/11] ath10k: Added sdio support
Date: Tue, 13 Dec 2016 13:10:53 +0000
Message-ID: <87pokwynxf.fsf@kamboji.qca.qualcomm.com> (sfid-20161213_141102_504952_151ED6EC)
References: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
        <1479496971-19174-12-git-send-email-erik.stromdahl@gmail.com>
In-Reply-To: <1479496971-19174-12-git-send-email-erik.stromdahl@gmail.com>
        (Erik Stromdahl's message of "Fri, 18 Nov 2016 20:22:51 +0100")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> Initial HIF sdio/mailbox implementation.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>

While testing this I noticed few new warnings:

drivers/net/wireless/ath/ath10k/sdio.c: In function ath10k_sdio_probe:
drivers/net/wireless/ath/ath10k/sdio.c:1723:6: warning: 'ret' may be used u=
ninitialized in this function [-Wuninitialized]
drivers/net/wireless/ath/ath10k/sdio.c:375:5: warning: symbol 'ath10k_sdio_=
mbox_rxmsg_pending_handler' was not declared. Should it be static?
drivers/net/wireless/ath/ath10k/sdio.c:1018:5: warning: symbol 'ath10k_sdio=
_hif_tx_sg' was not declared. Should it be static?
drivers/net/wireless/ath/ath10k/sdio.c:1415:5: warning: symbol 'ath10k_sdio=
_hif_exchange_bmi_msg' was not declared. Should it be static?
drivers/net/wireless/ath/ath10k/sdio.c:1555:5: warning: symbol 'ath10k_sdio=
_hif_map_service_to_pipe' was not declared. Should it be static?
drivers/net/wireless/ath/ath10k/sdio.c:1635:6: warning: symbol 'ath10k_sdio=
_hif_get_default_pipe' was not declared. Should it be static?
drivers/net/wireless/ath/ath10k/htc.c:265: line over 90 characters
drivers/net/wireless/ath/ath10k/htc.c:355: line over 90 characters

--=20
Kalle Valo=
