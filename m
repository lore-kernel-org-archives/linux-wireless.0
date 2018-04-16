Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:53810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753105AbeDPNoI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Apr 2018 09:44:08 -0400
Received: from mail-qk0-f181.google.com (mail-qk0-f181.google.com [209.85.220.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E36E421834
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 13:44:07 +0000 (UTC)
Received: by mail-qk0-f181.google.com with SMTP id c188so16553081qkg.2
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2018 06:44:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1522996476.4488.4.camel@coelho.fi>
References: <1522996476.4488.4.camel@coelho.fi>
From: Josh Boyer <jwboyer@kernel.org>
Date: Mon, 16 Apr 2018 09:44:06 -0400
Message-ID: <CA+5PVA6meJ+enpe0MyYsAfg4PFWNAMX7jxau=QfFaKNXsqP+Nw@mail.gmail.com> (sfid-20180416_154411_797628_422C7483)
Subject: Re: pull-request: iwlwifi firmwares update 2018-04-06
To: Luca Coelho <luca@coelho.fi>
Cc: Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        Kyle McMartin <kyle@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 6, 2018 at 2:34 AM, Luca Coelho <luca@coelho.fi> wrote:
> Hi,
>
> I have updated all the firmwares we currently support.
>
> Please pull or let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 8c1e439c967a50f0698d61aafdba3841aff10db0:
>
>   amdgpu: update vce firmware for Polaris (2018-04-02 09:26:24 -0400)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git tags/iwlwifi-fw-2018-04-06

Pulled and pushed out.

josh

>
> for you to fetch changes up to 50c132306e524dc9038d4a42205921730a3add24:
>
>   iwlwifi: update firmwares for 3160, 3168 and 7265 (2018-04-04 00:15:23 +0300)
>
> ----------------------------------------------------------------
> iwlwifi: updata all currently supported FWs
>
> * Update FWs for 3160, 7260 and 7265;
> * Update FWs for 3168 and 7265D;
> * Update FWs for 8000C and 8265;
> * Update FWs for 9000 and 9260.
>
> ----------------------------------------------------------------
> Luca Coelho (2):
>       iwlwifi: add some new FW versions and update older ones
>       iwlwifi: update firmwares for 3160, 3168 and 7265
>
>  WHENCE                            |  26 +++++++++++++++++++-------
>  iwlwifi-3160-17.ucode             | Bin 918268 -> 918268 bytes
>  iwlwifi-3168-29.ucode             | Bin 1036372 -> 1036276 bytes
>  iwlwifi-7260-17.ucode             | Bin 1049340 -> 1049340 bytes
>  iwlwifi-7265-17.ucode             | Bin 1180412 -> 1180412 bytes
>  iwlwifi-7265D-29.ucode            | Bin 1036528 -> 1036432 bytes
>  iwlwifi-8000C-36.ucode            | Bin 0 -> 2486572 bytes
>  iwlwifi-8265-36.ucode             | Bin 0 -> 2498044 bytes
>  iwlwifi-9000-pu-b0-jf-b0-38.ucode | Bin 0 -> 2520568 bytes
>  iwlwifi-9260-th-b0-jf-b0-38.ucode | Bin 0 -> 2521412 bytes
>  10 files changed, 19 insertions(+), 7 deletions(-)
>  create mode 100644 iwlwifi-8000C-36.ucode
>  create mode 100644 iwlwifi-8265-36.ucode
>  create mode 100644 iwlwifi-9000-pu-b0-jf-b0-38.ucode
>  create mode 100644 iwlwifi-9260-th-b0-jf-b0-38.ucode
