Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33306 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753023AbeDXRcb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:32:31 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: fix tx_alc_enabled check
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <8143b57af86d4bdd5764f86cf53a0cfdcbfe9bea.1522828102.git.lorenzo.bianconi@redhat.com>
References: <8143b57af86d4bdd5764f86cf53a0cfdcbfe9bea.1522828102.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180424173231.247F160863@smtp.codeaurora.org> (sfid-20180424_193243_250296_BEBDD1FF)
Date: Tue, 24 Apr 2018 17:32:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Fix mt76x2_temp_tx_alc_enabled routine since in order to enable tx_alc
> temperature compensation it necessary to take into account BIT(15) of
> MT_EE_TX_POWER_EXT_PA_5G eeprom info
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

bcb0f68ae2ed mt76x2: fix tx_alc_enabled check

-- 
https://patchwork.kernel.org/patch/10322203/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
