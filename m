Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34531 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755696AbbI2H3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2015 03:29:23 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [01/12] brcmfmac: consolidate ifp lookup in driver core
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1440620104-2715-2-git-send-email-arend@broadcom.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Message-Id: <20150929072923.29284140B8B@smtp.codeaurora.org> (sfid-20150929_092939_042914_1B9A6152)
Date: Tue, 29 Sep 2015 07:29:23 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> In rx path the firmware provide an interface index which is used to
> map to a struct brcmf_if instance. However, this involves some trick
> that is done in two places. This is changed by having driver core
> providing brcmf_get_ifp() function.
> 
> Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

Thanks, 12 patches applied to wireless-drivers-next.git:

75effb03ee8e brcmfmac: consolidate ifp lookup in driver core
796cfb65e3ed brcmfmac: make brcmf_proto_hdrpull() return struct brcmf_if instance
ee6e3a3414a4 brcmfmac: change parameters for brcmf_remove_interface()
1c626cf472fc brcmfmac: only call brcmf_cfg80211_detach() when attach was successful
ddddfed2f9d8 brcmfmac: correct detection of p2pdev interface event
46f3b6ee4838 brcmfmac: use brcmf_get_ifp() to map ifidx to struct brcmf_if instance
054e68add659 brcmfmac: pass struct brcmf_if instance in brcmf_txfinalize()
291da87b6910 brcmfmac: add mapping for interface index to bsscfg index
9d6c1dc4f913 brcmfmac: add dedicated debug level for firmware console logging
03cca20a6ee1 brcmfmac: remove ifidx parameter from brcmf_fws_txstatus_suppressed()
c67d41ba6ff3 brcmfmac: change prototype for brcmf_fws_hdrpull()
95ef12394a4d brcmfmac: introduce brcmf_net_detach() function

Kalle Valo
