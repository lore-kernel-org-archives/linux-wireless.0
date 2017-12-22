Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:56582 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752458AbdLVPqW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 10:46:22 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [RFC v3 08/11] ath10k: add QCA9377 usb hw_param item
Date: Fri, 22 Dec 2017 15:46:17 +0000
Message-ID: <87bmiqahpz.fsf@kamboji.qca.qualcomm.com> (sfid-20171222_164625_938472_A14B88A9)
References: <20170917194013.8658-1-erik.stromdahl@gmail.com>
        <20170917194013.8658-9-erik.stromdahl@gmail.com>
In-Reply-To: <20170917194013.8658-9-erik.stromdahl@gmail.com> (Erik
        Stromdahl's message of "Sun, 17 Sep 2017 21:40:10 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> writes:

> Hardware parameters for QCA9377 usb devices.
>
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/hw.h
> +++ b/drivers/net/wireless/ath/ath10k/hw.h
> @@ -127,6 +127,7 @@ enum qca9377_chip_id_rev {
>  /* QCA9377 1.0 definitions */
>  #define QCA9377_HW_1_0_FW_DIR          ATH10K_FW_DIR "/QCA9377/hw1.0"
>  #define QCA9377_HW_1_0_BOARD_DATA_FILE "board.bin"
> +#define QCA9377_HW_1_0_BOARD_DATA_FILE_USB "board-usb.bin"
>  #define QCA9377_HW_1_0_PATCH_LOAD_ADDR	0x1234

Not sure if we need board-usb.bin. board-2.bin already has a bus
attribute and board.bin is supposed to be used only by developers etc.

--=20
Kalle Valo=
