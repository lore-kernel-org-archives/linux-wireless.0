Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726819AbeIMU63 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 16:58:29 -0400
MIME-Version: 1.0
References: <20180905155146.28556-1-Larry.Finger@lwfinger.net>
In-Reply-To: <20180905155146.28556-1-Larry.Finger@lwfinger.net>
From: Josh Boyer <jwboyer@kernel.org>
Date: Thu, 13 Sep 2018 11:48:12 -0400
Message-ID: <CA+5PVA6JMGwo94NMuS+u_1hTWtE1CjbGD1Te1u-0m4BP5BU45g@mail.gmail.com> (sfid-20180913_174831_300665_3DCD0E48)
Subject: Re: [PATCH] Subject: [PATCH] rtl_bt: Add firmware and configuration
 files for the Bluetooth part of RTL8822CU
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?6ZmG5pyx5Lyf?= <alex_lu@realsil.com.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 5, 2018 at 11:52 AM Larry Finger <Larry.Finger@lwfinger.net> wr=
ote:
>
> These devices are new models from Realtek. Updates to driver btrtl will
> soon be submitted to the kernel.
>
> These files were provided by the Realtek developer.
>
> Signed-off-by: =E9=99=86=E6=9C=B1=E4=BC=9F <alex_lu@realsil.com.cn>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  WHENCE                  |   2 ++
>  rtl_bt/rtl8822cu_fw.bin | Bin 0 -> 22412 bytes
>  2 files changed, 2 insertions(+)
>  create mode 100644 rtl_bt/rtl8822cu_fw.bin
>

Applied (with fixed Subject), and pushed out.

josh
