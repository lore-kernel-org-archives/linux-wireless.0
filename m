Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751488AbeDGAuq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Apr 2018 20:50:46 -0400
Received: from mail-qk0-f170.google.com (mail-qk0-f170.google.com [209.85.220.170])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 830D12183A
        for <linux-wireless@vger.kernel.org>; Sat,  7 Apr 2018 00:50:45 +0000 (UTC)
Received: by mail-qk0-f170.google.com with SMTP id d206so3149638qkb.0
        for <linux-wireless@vger.kernel.org>; Fri, 06 Apr 2018 17:50:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1523015653-24106-1-git-send-email-siva8118@gmail.com>
References: <1523015653-24106-1-git-send-email-siva8118@gmail.com>
From: Josh Boyer <jwboyer@kernel.org>
Date: Fri, 6 Apr 2018 20:50:43 -0400
Message-ID: <CA+5PVA54mbWxPsJshpSntfrhENucHNPhnwEkGqDzFqP6BvCC8w@mail.gmail.com> (sfid-20180407_025049_852643_B04007DE)
Subject: Re: [PATCH] linux-firmware: rsi: update firmware images for Redpine
 9113 chipset
To: Siva Rebbagondla <siva8118@gmail.com>
Cc: Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sushant Mishra <sushant.mishra@redpinesignals.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 6, 2018 at 7:54 AM, Siva Rebbagondla <siva8118@gmail.com> wrote:
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
> ---
>  rsi/rs9113_ap_bt_dual_mode.rps   | Bin 0 -> 341860 bytes
>  rsi/rs9113_wlan_bt_dual_mode.rps | Bin 0 -> 331592 bytes
>  rsi/rs9113_wlan_qspi.rps         | Bin 199180 -> 201052 bytes
>  3 files changed, 0 insertions(+), 0 deletions(-)
>  create mode 100644 rsi/rs9113_ap_bt_dual_mode.rps
>  create mode 100644 rsi/rs9113_wlan_bt_dual_mode.rps

Could you please update WHENCE with the new files and version info?

If possible, a pull request is easier to deal with than a plain patch
but if that isn't something you can easily do then no worries.

josh
