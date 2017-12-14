Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44568 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdLNMlZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 07:41:25 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/10] brcmfmac: Split brcmf_sdiod_buffrw function up.
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1512735035-342-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1512735035-342-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20171214124125.1824B60A54@smtp.codeaurora.org> (sfid-20171214_134129_277007_E75088CD)
Date: Thu, 14 Dec 2017 12:41:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> From: Ian Molton <ian@mnementh.co.uk>
> 
> This function needs to be split up into separate read / write variants
> for clarity.
> 
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

10 patches applied to wireless-drivers-next.git, thanks.

8f13c87ccc49 brcmfmac: Split brcmf_sdiod_buffrw function up.
6e24dd012bfd brcmfmac: whitespace fixes in brcmf_sdiod_send_buf()
a7323378dcf1 brcmfmac: Clarify if using braces.
71bd508d7ded brcmfmac: Rename / replace old IO functions with simpler ones.
eeef8a5da781 brcmfmac: Tidy register definitions a little
a7c3aa1509e2 brcmfmac: Remove brcmf_sdiod_addrprep()
c900072bd6fa brcmfmac: remove unnecessary call to brcmf_sdiod_set_backplane_window()
e4c05fc3c0a6 brcmfmac: Cleanup offsetof()
5cfe38f1f8d3 brcmfmac: Remove unused macro.
21a10846d09d brcmfmac: Remove repeated calls to brcmf_chip_get_core()

-- 
https://patchwork.kernel.org/patch/10102409/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
