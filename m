Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:33768 "EHLO
        alexa-out-lv-01.qualcomm.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752610AbdHKOAP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Aug 2017 10:00:15 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,02/20] ath6kl: constify usb_device_id
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1502295823-20824-3-git-send-email-arvind.yadav.cs@gmail.com>
References: <1502295823-20824-3-git-send-email-arvind.yadav.cs@gmail.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
CC: <kvalo@codeaurora.org>, <petkan@nucleusys.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
Message-ID: <e5102d3d94654b16b3c57455dd1c6991@euamsexm01a.eu.qualcomm.com> (sfid-20170811_160031_220056_107AF1D9)
Date: Fri, 11 Aug 2017 15:59:37 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:

> usb_device_id are not supposed to change at runtime. All functions
> working with usb_device_id provided by <linux/usb.h> work with
> const usb_device_id. So mark the non-const structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
> Reviewed-by: Steve deRosier <derosier@gmail.com>
> Tested-by: Steve deRosier <derosier@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

2 patches applied to ath-next branch of ath.git, thanks.

e881a6584941 ath6kl: constify usb_device_id
76b07b30c46b ath9k: constify usb_device_id

-- 
https://patchwork.kernel.org/patch/9890987/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
