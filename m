Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54916 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750911AbdHaM7H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 08:59:07 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] brcmfmac: Log chip id and revision
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170830135449.1075-1-hdegoede@redhat.com>
References: <20170830135449.1075-1-hdegoede@redhat.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Message-Id: <20170831125907.4DB16617D8@smtp.codeaurora.org> (sfid-20170831_145910_336927_6458394E)
Date: Thu, 31 Aug 2017 12:59:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans de Goede <hdegoede@redhat.com> wrote:

> For debugging some problems, it is useful to know the chip revision
> add a brcmf_info message logging this.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Patch applied to wireless-drivers-next.git, thanks.

f38966a7ace8 brcmfmac: Log chip id and revision

-- 
https://patchwork.kernel.org/patch/9929651/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
