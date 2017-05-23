Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:51517 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031487AbdEWVxw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 May 2017 17:53:52 -0400
Date: Tue, 23 May 2017 14:53:51 -0700
From: Kyle McMartin <kyle@infradead.org>
To: Maya Erez <qca_merez@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
        linux-firmware@kernel.org
Subject: Re: [PATCH] linux-firmware: add wil6210 firmware 4.1.0.55
Message-ID: <20170523215351.GX13400@bombadil.infradead.org> (sfid-20170523_235515_725582_73526BE9)
References: <1495370937-5369-1-git-send-email-qca_merez@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1495370937-5369-1-git-send-email-qca_merez@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, May 21, 2017 at 03:48:57PM +0300, Maya Erez wrote:
> This is the latest firmware from wil6210 4.1 firmware branch.
> 
> Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
> ---
>  WHENCE      |  10 ++++++++++
>  wil6210.brd | Bin 0 -> 3588 bytes
>  wil6210.fw  | Bin 0 -> 350748 bytes
>  3 files changed, 10 insertions(+)
>  create mode 100644 wil6210.brd
>  create mode 100644 wil6210.fw

Sigh, I wish this was under a subdirectory, but since the kernel driver
is already upstream, I guess we're SOL.

Applied.

--Kyle

> 
> diff --git a/WHENCE b/WHENCE
> index f95798d..ab8cbc1 100644
> --- a/WHENCE
> +++ b/WHENCE
> @@ -3571,3 +3571,13 @@ File: netronome/nic_AMDA0097-0001_8x10.nffw
>  Version: v0.6.1
>  
>  Licence: Redistributable. See LICENCE.Netronome for details
> +
> +--------------------------------------------------------------------------
> +
> +Driver: wil6210 - Qualcomm Atheros support for 11ad family of chips
> +
> +File: wil6210.fw
> +File: wil6210.brd
> +Version: 4.1.0.55
> +
> +Licence: Redistributable. See LICENSE.QualcommAtheros_ath10k for details
[...]
