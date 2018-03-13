Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56384 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933504AbeCMQeJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Mar 2018 12:34:09 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: remove unnecessary len variable in mt76x2_eeprom_load()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180228222012.503-1-lorenzo.bianconi@redhat.com>
References: <20180228222012.503-1-lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180313163408.C842B6070A@smtp.codeaurora.org> (sfid-20180313_173433_310467_7B1CFFFE)
Date: Tue, 13 Mar 2018 16:34:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Substitute unnecessary len variable in mt76x2_eeprom_load() with
> MT7662_EEPROM_SIZE macro since len is used just to store eeprom
> default size.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

fbae9c7490b7 mt76x2: remove unnecessary len variable in mt76x2_eeprom_load()

-- 
https://patchwork.kernel.org/patch/10249983/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
