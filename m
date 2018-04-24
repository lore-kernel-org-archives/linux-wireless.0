Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58728 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751129AbeDXR3o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Apr 2018 13:29:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76x2: make mt76x2_mac_reset routine static
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <3ac4534e4e14515843c8cb5fbd9accecfcef40d0.1522767292.git.lorenzo.bianconi@redhat.com>
References: <3ac4534e4e14515843c8cb5fbd9accecfcef40d0.1522767292.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180424172943.7D8A56085F@smtp.codeaurora.org> (sfid-20180424_192946_772305_DE998782)
Date: Tue, 24 Apr 2018 17:29:43 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Add static qualifier to mt76x2_mac_reset routine and remove the
> prototype from mt76x2_mac.h since it is used just in mt76x2_init.c
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Acked-by: Felix Fietkau <nbd@nbd.name>

Patch applied to wireless-drivers-next.git, thanks.

00dfae9a0ab7 mt76x2: make mt76x2_mac_reset routine static

-- 
https://patchwork.kernel.org/patch/10321389/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
