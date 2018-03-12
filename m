Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751419AbeCLNP2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Mar 2018 09:15:28 -0400
Received: from mail-qk0-f175.google.com (mail-qk0-f175.google.com [209.85.220.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A04121796
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2018 13:15:26 +0000 (UTC)
Received: by mail-qk0-f175.google.com with SMTP id s78so1735544qkl.8
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2018 06:15:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1519988289.6017.11.camel@coelho.fi>
References: <1519988289.6017.11.camel@coelho.fi>
From: Josh Boyer <jwboyer@kernel.org>
Date: Mon, 12 Mar 2018 09:15:25 -0400
Message-ID: <CA+5PVA5kF-VkuUgfVNXesmsc+A4Hgq0OYjAu0bQuhDpDNb-vWw@mail.gmail.com> (sfid-20180312_141819_678017_9B597217)
Subject: Re: pull-request: iwlwifi firmwares update 2018-03-02
To: Luca Coelho <luca@coelho.fi>
Cc: Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        linuxwifi <linuxwifi@intel.com>,
        Kyle McMartin <kyle@infradead.org>,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 2, 2018 at 5:58 AM, Luca Coelho <luca@coelho.fi> wrote:
> Hi,
>
> I have updated the firmwares for the 9000 series.
>
> Please pull or let me know if there are any issues.
>
> Cheers,
> Luca.
>
>
> The following changes since commit 7344ec9e1df9e27d105ed48d2db99e22370236de:
>
>   Merge branch 'ath10k-20180219' of git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/linux-firmware into ath10k (2018-02-22 06:42:59 -0500)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git tags/iwlwifi-fw-2018-03-02
>
> for you to fetch changes up to e27d4b7e5c2e948dff36ed5c8ac90da94e317067:
>
>   iwlwifi: update firmware version 34 for 9000 series (2018-03-02 12:38:35 +0200)
>
> ----------------------------------------------------------------
> iwlwifi: update FWs for 9000 series
>
> * Update FW version 34 for 9000 series;
>
> ----------------------------------------------------------------
> Luca Coelho (1):
>       iwlwifi: update firmware version 34 for 9000 series
>
>  WHENCE                            |   4 ++--
>  iwlwifi-9000-pu-b0-jf-b0-34.ucode | Bin 2677620 -> 2678284 bytes
>  iwlwifi-9260-th-b0-jf-b0-34.ucode | Bin 2677772 -> 2678092 bytes
>  3 files changed, 2 insertions(+), 2 deletions(-)

Pulled and pushed out.  Thanks.

josh
