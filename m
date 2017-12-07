Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38567 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752121AbdLGBga (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Dec 2017 20:36:30 -0500
Date: Wed, 6 Dec 2017 17:36:29 -0800
From: Kyle McMartin <kyle@infradead.org>
To: Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-firmware@kernel.org
Subject: Re: [PATCH V2] brcm: add CYW4373 firmwares and Cypress license file
Message-ID: <20171207013629.GF1875@bombadil.infradead.org> (sfid-20171207_023634_273365_A060BE75)
References: <20171201084243.GA58942@aremote07.aus.cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171201084243.GA58942@aremote07.aus.cypress.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 01, 2017 at 02:43:00AM -0600, Chi-Hsien Lin wrote:
> Add the CYW4373 SDIO and USB firmware files, along with the corresponding
> Cypress license file.
> 
> Signed-off-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>
> ---
>  LICENCE.cypress            | 139 +++++++++++++++++++++++++++++++++++++++++++++
>  WHENCE                     |   5 ++
>  brcm/brcmfmac4373-sdio.bin | Bin 0 -> 457994 bytes
>  brcm/brcmfmac4373.bin      | Bin 0 -> 479232 bytes
>  4 files changed, 144 insertions(+)
>  create mode 100644 LICENCE.cypress
>  create mode 100644 brcm/brcmfmac4373-sdio.bin
>  create mode 100644 brcm/brcmfmac4373.bin
> 

pulled, thanks chi-hsien.

regards, kyle
