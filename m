Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59464 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752139AbeC0JKT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Mar 2018 05:10:19 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: mt76: use mt76_poll_msec routine in mt76pci_load_firmware()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <b2abf42bbd5e5f41082bd17df018dcb203aa2f86.1521128408.git.lorenzo.bianconi@redhat.com>
References: <b2abf42bbd5e5f41082bd17df018dcb203aa2f86.1521128408.git.lorenzo.bianconi@redhat.com>
To: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc: nbd@nbd.name, linux-wireless@vger.kernel.org
Message-Id: <20180327091018.EF6A96070A@smtp.codeaurora.org> (sfid-20180327_111035_352653_C47CA1DA)
Date: Tue, 27 Mar 2018 09:10:18 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> Use mt76_poll_msec() in mt76pci_load_firmware to check if the firmware
> has been started instead of explicitly poll MCU running register
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

db2ad7c25a9a mt76: use mt76_poll_msec routine in mt76pci_load_firmware()

-- 
https://patchwork.kernel.org/patch/10285377/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
