Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49685 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbcCGMTv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 07:19:51 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/21] brcmfmac: change function name
 forbrcmf_cfg80211_wait_vif_event_timeout()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1455704830-10088-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20160307121950.CDA876067A@smtp.codeaurora.org> (sfid-20160307_132005_135250_9CD91C31)
Date: Mon,  7 Mar 2016 12:19:50 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Dropping the '_timeout' from the function name as the fact that a timeout
> value is passed makes it obvious a timeout is used. Also helps to keep code
> lines a bit shorter and easier to stick to 80 char boundary.
> 
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 20 patches applied to wireless-drivers-next.git:

a9eb0c4b73e7 brcmfmac: change function name for brcmf_cfg80211_wait_vif_event_timeout()
d536733442d1 brcmfmac: Limit memory allocs to <64K
6ea09153b6cc brcmfmac: check for wowl support before enumerating feature flag
73345fd21298 brcmfmac: Configure country code using device specific settings
0aedbcaf6f18 brcmfmac: Add length checks on firmware events
52f22fb21764 brcmfmac: add neighbor discovery offload ip address table configuration
cd2bc19c61b2 brcmfmac: check return for ARP ip setting iovar
6ac27689b01e brcmfmac: use device memsize config from fw if defined
9300bf8610fd brcmfmac: use bar1 window size as provided by pci subsystem
bc86fdb9ac02 brcmfmac: add support for the PCIE 4366c0 chip
d457a44fd85c brcmfmac: remove pcie gen1 support
e9217b4b62a7 brcmfmac: increase timeout for tx eapol
d84d99e00777 brcmfmac: move module init and exit to common
5c22fb85102a brcmfmac: add wowl gtk rekeying offload support
8ea56be0869f brcmfmac: move platform data retrieval code to common
73ef9e640e94 brcmfmac: keep ARP and ND offload enabled during WOWL
4d7928959832 brcmfmac: switch to new platform data
af5b5e62f72e brcmfmac: merge platform data and module paramaters
219e0f747ad6 brcmfmac: integrate add_keyext in add_key
240d61a9ddeb brcmfmac: add 802.11w management frame protection support

1 patches skipped:

[17/21] brcmfmac: fix sdio sg table alloc crash

There was a conflict so please rebase that patch:

Applying: brcmfmac: fix sdio sg table alloc crash
fatal: sha1 information is lacking or useless (drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 brcmfmac: fix sdio sg table alloc crash

Kalle Valo
