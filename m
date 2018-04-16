Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:56780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755146AbeDPNyk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:54:40 -0400
Received: from mail-qk0-f173.google.com (mail-qk0-f173.google.com [209.85.220.173])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5578421834
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 13:54:40 +0000 (UTC)
Received: by mail-qk0-f173.google.com with SMTP id f9so8670753qkm.12
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 06:54:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1523262987-4650-1-git-send-email-siva8118@gmail.com>
References: <1523262987-4650-1-git-send-email-siva8118@gmail.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Mon, 16 Apr 2018 09:54:39 -0400
Message-ID: <CA+5PVA40XQLMa2wY2JwNQCC0GkNL2Bu6XHYDRsb5QKs8kUPYyA@mail.gmail.com> (sfid-20180416_155443_689135_4D14DBA1)
Subject: Re: [PATCH v2] linux-firmware: rsi: update firmware images for
 Redpine 9113 chipset
To: Siva Rebbagondla <siva8118@gmail.com>
Cc: Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 9, 2018 at 4:36 AM, Siva Rebbagondla <siva8118@gmail.com> wrote:
> From: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>
> These images will be loaded by rsi driver based on operating mode.
> Firmware version is 1.6.1
>
> rs9113_ap_bt_dual_mode.rps - AP and BT functionality
> rs9113_wlan_bt_dual_mode.rps - station and BT functionality
> rs9113_wlan_qspi.rps - AP and station functionality
>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> ---
> v2: Updated WHENCE file [Josh Boyer]
> ---
>  WHENCE                           |   8 +++++++-
>  rsi/rs9113_ap_bt_dual_mode.rps   | Bin 0 -> 341860 bytes
>  rsi/rs9113_wlan_bt_dual_mode.rps | Bin 0 -> 331592 bytes
>  rsi/rs9113_wlan_qspi.rps         | Bin 199180 -> 201052 bytes
>  4 files changed, 7 insertions(+), 1 deletion(-)
>  create mode 100644 rsi/rs9113_ap_bt_dual_mode.rps
>  create mode 100644 rsi/rs9113_wlan_bt_dual_mode.rps

Thanks.  Applied and pushed out.

josh
