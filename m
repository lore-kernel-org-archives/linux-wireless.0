Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:46886 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751391AbdHJI5U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Aug 2017 04:57:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,01/20] ar5523: constify usb_device_id
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1502295823-20824-2-git-send-email-arvind.yadav.cs@gmail.com>
References: <1502295823-20824-2-git-send-email-arvind.yadav.cs@gmail.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: petkan@nucleusys.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Message-Id: <20170810085720.2830F60132@smtp.codeaurora.org> (sfid-20170810_105739_432990_C69789EF)
Date: Thu, 10 Aug 2017 08:57:20 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arvind Yadav <arvind.yadav.cs@gmail.com> wrote:

> usb_device_id are not supposed to change at runtime. All functions
> working with usb_device_id provided by <linux/usb.h> work with
> const usb_device_id. So mark the non-const structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

17 patches applied to wireless-drivers-next.git, thanks.

c5c60b2d577e ar5523: constify usb_device_id
76f6a5c80a4b carl9170: constify usb_device_id
22796d149229 at76c50x: constify usb_device_id
c4291319b6fe orinoco: constify usb_device_id
54c9f21605d8 p54: constify usb_device_id
3673c417f509 libertas: constify usb_device_id
8a3132fa6bbb libertas_tf: constify usb_device_id
7516dbd470e3 mwifiex: constify usb_device_id
e2717b312750 mt7601u: constify usb_device_id
88ee79a1a11c rt2500usb: constify usb_device_id
c7bb7d79cf4f rt2800usb: constify usb_device_id
543e4f87508b rt73usb: constify usb_device_id
e0b081b20523 rtl8187: constify usb_device_id
5033d70de169 rtl8xxxu: constify usb_device_id
3a55a4afd187 rtl8192cu: constify usb_device_id
b924ffd7a4cd zd1201: constify usb_device_id
ecf23a788e13 zd1211rw: constify usb_device_id

-- 
https://patchwork.kernel.org/patch/9890989/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
