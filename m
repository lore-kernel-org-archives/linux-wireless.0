Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:50828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965286AbeBMSMB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Feb 2018 13:12:01 -0500
MIME-Version: 1.0
In-Reply-To: <20180211180615.31788-1-Larry.Finger@lwfinger.net>
References: <20180211180615.31788-1-Larry.Finger@lwfinger.net>
From: Josh Boyer <jwboyer@kernel.org>
Date: Tue, 13 Feb 2018 13:11:58 -0500
Message-ID: <CA+5PVA6DCvPjxKi4FY4GzW01hOaEk6+tfYsjNt745hKwirQrXQ@mail.gmail.com> (sfid-20180213_191209_182172_83A4EA80)
Subject: Re: [PATCH] rtl_bt: Add firmware and configuration files for the
 Bluetooth parts of RTL8821C and RTL8723D
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?6ZmG5pyx5Lyf?= <alex_lu@realsil.com.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 11, 2018 at 1:06 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> These devices are new models from Realtek. Updates to driver btrtl will
> soon be submitted to the kernel.
>
> These files were provided by the Realtek developer.
>
> Signed-off-by: 陆朱伟 <alex_lu@realsil.com.cn>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
>  WHENCE                     |   5 +++++
>  rtl_bt/rtl8723d_config.bin | Bin 0 -> 10 bytes
>  rtl_bt/rtl8723d_fw.bin     | Bin 0 -> 47028 bytes
>  rtl_bt/rtl8821c_config.bin | Bin 0 -> 10 bytes
>  rtl_bt/rtl8821c_fw.bin     | Bin 0 -> 37356 bytes
>  5 files changed, 5 insertions(+)
>  create mode 100644 rtl_bt/rtl8723d_config.bin
>  create mode 100644 rtl_bt/rtl8723d_fw.bin
>  create mode 100644 rtl_bt/rtl8821c_config.bin
>  create mode 100644 rtl_bt/rtl8821c_fw.bin

Applied and pushed out.  Thanks!

josh
