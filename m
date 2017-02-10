Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29281 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932069AbdBJTrT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 14:47:19 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [RFC,04/10] ath10k: new fw fetch functionality
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1484343309-6327-5-git-send-email-erik.stromdahl@gmail.com>
References: <1484343309-6327-5-git-send-email-erik.stromdahl@gmail.com>
To: Erik Stromdahl <erik.stromdahl@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
        "Erik Stromdahl" <erik.stromdahl@gmail.com>
Message-ID: <6c9dfcb8e55c49818f43492ac8641947@eusanexr01a.eu.qualcomm.com> (sfid-20170210_204722_998647_821C3861)
Date: Fri, 10 Feb 2017 04:45:43 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Erik Stromdahl <erik.stromdahl@gmail.com> wrote:
> A new function for creating the fw file name dynamically.
> 
> Since both SDIO and USB based chipsets will use different
> firmware from the PCIe and AHB chipsets, the fw file name
> is created dynamically.
> 
> The new firmware names are:
> 
> For PCIe and AHB:
> firmware-<api_version>.bin (same as before)
> 
> For SDIO:
> firmware-sdio-<api_version>.bin
> 
> For USB:
> firmware-usb-<api_version>.bin
> 
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>

Actually I needed this for something else so I took this into one of my
patchsets with small modifications:

ath10k: fetch firmware images in a loop
https://patchwork.kernel.org/patch/9566667/

-- 
https://patchwork.kernel.org/patch/9516551/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
