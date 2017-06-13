Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56296 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752097AbdFMF67 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 01:58:59 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [resend] brcmfmac: p2p and normal ap access are not always
 possible at the same time
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170526105747.16874-2-hdegoede@redhat.com>
References: <20170526105747.16874-2-hdegoede@redhat.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Message-Id: <20170613055859.3BEBF607DC@smtp.codeaurora.org> (sfid-20170613_075906_058906_B7EED59F)
Date: Tue, 13 Jun 2017 05:58:59 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans de Goede <hdegoede@redhat.com> wrote:

> The firmware responding with -EBUSY when trying to add an extra virtual-if
> is a normal thing, do not print an error for this.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Arend, what should I do with this patch? Take it?

-- 
https://patchwork.kernel.org/patch/9750341/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
