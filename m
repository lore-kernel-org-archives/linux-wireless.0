Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:42286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751099AbeACU6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Jan 2018 15:58:09 -0500
MIME-Version: 1.0
In-Reply-To: <20180103004442.947-1-Larry.Finger@lwfinger.net>
References: <20180103004442.947-1-Larry.Finger@lwfinger.net>
From: Josh Boyer <jwboyer@kernel.org>
Date: Wed, 3 Jan 2018 15:58:07 -0500
Message-ID: <CA+5PVA6XXQaY9q2jG+dgrhk7M1YN1DZX2kcNs6pcHtG3GL7W2w@mail.gmail.com> (sfid-20180103_215818_182327_4B2F5C09)
Subject: Re: [PATCH] rtlwifi: rtl8723de: Add firmware for new driver/device
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-firmware@kernel.org, linux-wireless@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 2, 2018 at 7:44 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> A driver for the RTL8723DE is nearing submission to staging. This commit supplies
> the firmware for it.
>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: Ping-Ke Shih <pkshih@realtek.com>
> ---
>  WHENCE                  |   9 +++++++++
>  rtlwifi/rtl8723defw.bin | Bin 0 -> 27726 bytes
>  2 files changed, 9 insertions(+)
>  create mode 100644 rtlwifi/rtl8723defw.bin

Applied and pushed out.  Thanks.

josh
