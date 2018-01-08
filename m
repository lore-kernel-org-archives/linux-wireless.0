Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35054 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753865AbeAHRaO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Jan 2018 12:30:14 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: eeprom: fix typo in mt76x2_get_power_info_5g()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <2ae397aff0b058615a558a2352067fad2c9201e6.1513248071.git.lorenzo.bianconi@redhat.com>
References: <2ae397aff0b058615a558a2352067fad2c9201e6.1513248071.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, colin.king@canonical.com,
        linux-wireless@vger.kernel.org
Message-Id: <20180108173014.2BA866079C@smtp.codeaurora.org> (sfid-20180108_183019_737774_63560180)
Date: Mon,  8 Jan 2018 17:30:14 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Fix typo in 5GHz power vs channel eeprom parsing
> 
> Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Felix Fietkau <nbd@nbd.name>
> Reported-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

c3929a980b16 mt76x2: eeprom: fix typo in mt76x2_get_power_info_5g()

-- 
https://patchwork.kernel.org/patch/10111813/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
