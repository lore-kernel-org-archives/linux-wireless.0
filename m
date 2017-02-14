Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18954 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752616AbdBNRzn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 12:55:43 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/4] ath10k: fetch firmware images in a loop
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <148672959257.8556.14481306395015426550.stgit@potku.adurom.net>
References: <148672959257.8556.14481306395015426550.stgit@potku.adurom.net>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Message-ID: <6706de25e5b646fda1c44984addb3318@eusanexr01a.eu.qualcomm.com> (sfid-20170214_185547_029960_FA6DF509)
Date: Tue, 14 Feb 2017 09:55:38 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> From: Erik Stromdahl <erik.stromdahl@gmail.com>
> 
> To make it easier to handle minimum and maximum firmware API numbers convert
> the firmware fetch functionality to a loop. If no firmware image is found print
> an error with minimum and maximum API numbers and the name of firmware
> directory. This is needed when we switch to using request_firmware_direct()
> which doesn't print any errors anymore.
> 
> Also add a new function for creating the fw file name dynamically which makes it
> easier to add new bus support, for example SDIO and USB, later.
> 
> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
> [kvalo@qca.qualcomm.com: remove sdio/usb part, new error message, clarify commit log]
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

4 patches applied to ath-next branch of ath.git, thanks.

1c61bedc0a72 ath10k: fetch firmware images in a loop
310c01afae01 ath10k: add directory to board data error message
9f5bcfe93315 ath10k: silence firmware file probing warnings
7be52c03bbf7 ath10k: convert warning about non-existent OTP board id to debug message

-- 
https://patchwork.kernel.org/patch/9566667/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
