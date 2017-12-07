Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57770 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755528AbdLGNMZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 08:12:25 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/10] brcmfmac: Fix parameter order in brcmf_sdiod_f0_writeb()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1510605347-7629-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1510605347-7629-2-git-send-email-arend.vanspriel@broadcom.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Message-Id: <20171207131224.A57486081C@smtp.codeaurora.org> (sfid-20171207_141422_556075_0CA26BEE)
Date: Thu,  7 Dec 2017 13:12:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:

> From: Ian Molton <ian@mnementh.co.uk>
> 
> All the other IO functions are the other way round in this
> driver. Make this one match.
> 
> Signed-off-by: Ian Molton <ian@mnementh.co.uk>
> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>

10 patches applied to wireless-drivers-next.git, thanks.

1fd3ae124d5e brcmfmac: Fix parameter order in brcmf_sdiod_f0_writeb()
1e6f676f43aa brcmfmac: Register sizes on hardware are not dependent on compiler types
0fcc9fe00484 brcmfmac: Split brcmf_sdiod_regrw_helper() up.
b9b0d290bc0c brcmfmac: Clean up brcmf_sdiod_set_sbaddr_window()
ea243e9077b3 brcmfmac: Remove dead IO code
4a3338ba2a74 brcmfmac: Remove bandaid for SleepCSR
993a98a42e6e brcmfmac: Remove brcmf_sdiod_request_data()
3508a056a1f4 brcmfmac: Fix asymmetric IO functions.
12e3e74e2820 brcmfmac: Remove noisy debugging.
dd8a2d49e4ed brcmfmac: Rename bcmerror to err

-- 
https://patchwork.kernel.org/patch/10056667/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
