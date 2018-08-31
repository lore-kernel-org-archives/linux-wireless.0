Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:41276 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727471AbeHaUCn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 16:02:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [PATCH] mt76: verify evt type in usb mcu response
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <56664707fd600dc2ff49c6e845b0d573a9cf9c89.1535106415.git.lorenzo.bianconi@redhat.com>
References: <56664707fd600dc2ff49c6e845b0d573a9cf9c89.1535106415.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180831155435.4A01E606CF@smtp.codeaurora.org> (sfid-20180831_175438_849664_351F9DE1)
Date: Fri, 31 Aug 2018 15:54:35 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Verify if evt field is set to EVT_CMD_DONE in usb mcu
> response messages. This is a preliminary patch for usb_mcu layer
> unification between mt76x0u and mt76x2u driver.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

ac5d5b3f199e mt76: verify evt type in usb mcu response

-- 
https://patchwork.kernel.org/patch/10575189/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
