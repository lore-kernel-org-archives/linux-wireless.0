Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45783 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754012AbcLPBOM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 20:14:12 -0500
Date: Thu, 15 Dec 2016 18:13:41 -0700
From: Mark Greer <mgreer@animalcreek.com>
To: Geoff Lansberry <geoff@kuvee.com>
Cc: linux-wireless@vger.kernel.org, lauro.venancio@openbossa.org,
        aloisio.almeida@openbossa.org, sameo@linux.intel.com,
        robh+dt@kernel.org, mark.rutland@arm.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        justin@kuvee.com
Subject: Re: [PATCH 2/3] NFC: trf7970a: Add device tree option of 1.8 Volt IO
 voltage
Message-ID: <20161216011341.GB25227@animalcreek.com> (sfid-20161216_021444_800305_B2EB6918)
References: <1481841044-4314-1-git-send-email-glansberry@gmail.com>
 <1481841044-4314-2-git-send-email-glansberry@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1481841044-4314-2-git-send-email-glansberry@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2016 at 05:30:43PM -0500, Geoff Lansberry wrote:
> From: Geoff Lansberry <geoff@kuvee.com>

Missing commit description.

> diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
> index 2d2a077..b4c37ab 100644
> --- a/drivers/nfc/trf7970a.c
> +++ b/drivers/nfc/trf7970a.c

> @@ -1048,6 +1049,11 @@ static int trf7970a_init(struct trf7970a *trf)
>  	if (ret)
>  		goto err_out;
>  
> +	ret = trf7970a_write(trf, TRF7970A_REG_IO_CTRL,
> +			trf->io_ctrl|TRF7970A_REG_IO_CTRL_VRS(0x1));

s/l|T/l | T/

Otherwise, looks good.

Mark
--
