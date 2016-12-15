Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:7596 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756171AbcLOQka (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 11:40:30 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v2 11/11] ath10k: Added sdio support
Date: Thu, 15 Dec 2016 16:40:24 +0000
Message-ID: <87oa0duow8.fsf@kamboji.qca.qualcomm.com> (sfid-20161215_174033_696682_38CFF114)
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
> ---
>  drivers/net/wireless/ath/ath10k/Kconfig  |    6 +
>  drivers/net/wireless/ath/ath10k/Makefile |    3 +
>  drivers/net/wireless/ath/ath10k/sdio.c   | 1860 ++++++++++++++++++++++++=
++++++
>  drivers/net/wireless/ath/ath10k/sdio.h   |  276 +++++
>  4 files changed, 2145 insertions(+)
>  create mode 100644 drivers/net/wireless/ath/ath10k/sdio.c
>  create mode 100644 drivers/net/wireless/ath/ath10k/sdio.h

AFAIK the sdio firmware binary is different from pci and usb. And as all
the firmware images need to coexist in the same repository I suspect we
can't continue to use firmware-N.bin for both pcie and sdio (and in
future usb). So should we somehow rename the sdio firmware filename to
something else, like firmware-sdio-N.bin?

--=20
Kalle Valo=
