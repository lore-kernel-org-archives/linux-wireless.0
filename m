Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53162 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754960AbdCTROi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 13:14:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v3,1/3] brcmfmac: Do not print the firmware version as an error
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170308135017.29867-1-hdegoede@redhat.com>
References: <20170308135017.29867-1-hdegoede@redhat.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Message-Id: <20170320171437.3C88960854@smtp.codeaurora.org> (sfid-20170320_181456_202744_45C83D84)
Date: Mon, 20 Mar 2017 17:14:37 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hans de Goede <hdegoede@redhat.com> wrote:
> Using pr_err for things which are not errors is a bad idea. E.g. it
> will cause the plymouth bootsplash screen to drop back to the text
> console so that the user can see the error, which is not what we
> normally want to happen.
> 
> Instead add a new brcmf_info macro and use that.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

3 patches applied to wireless-drivers-next.git, thanks.

d79fe4cb70d8 brcmfmac: Do not print the firmware version as an error
26e537884a8e brcmfmac: Do not complain about country code "00"
b9472a2e3e45 brcmfmac: Handle status == BRCMF_E_STATUS_ABORT in cfg80211_escan_handler

-- 
https://patchwork.kernel.org/patch/9611177/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
