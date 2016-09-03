Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58075 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753036AbcICRCL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 13:02:11 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2] brcmfmac: Add USB ID for Cisco Linksys AE1200
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20160822224007.300-1-ismael@iodev.co.uk>
To: Ismael Luceno <ismael@iodev.co.uk>
Cc: linux-wireless@vger.kernel.org, Ismael Luceno <ismael@iodev.co.uk>,
        brcm80211-dev-list@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Message-Id: <20160903170132.1FE4162182@smtp.codeaurora.org> (sfid-20160903_190214_641283_BCA6C811)
Date: Sat,  3 Sep 2016 17:01:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ismael Luceno <ismael@iodev.co.uk> wrote:
> The AE1200 comes with different revisions of the BCM43235 chipset,
> but all have the same USB ID. Only revision 3 can be supported.
> 
> Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>

Thanks, 1 patch applied to wireless-drivers-next.git:

bccf3ffc8c6d brcmfmac: Add USB ID for Cisco Linksys AE1200

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9294493/
