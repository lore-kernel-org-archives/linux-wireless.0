Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56743 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449AbcGHNmW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 09:42:22 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [01/12] rtl8xxxu: Set all ieee80211_rx_status values in
 parse_rx_desc()
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1467045130-18874-2-git-send-email-Jes.Sorensen@redhat.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Message-Id: <20160708134222.15A6F61154@smtp.codeaurora.org> (sfid-20160708_154226_241010_E10F6DF6)
Date: Fri,  8 Jul 2016 13:42:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
> 
> This needs to be handled locally in the parse_rx_desc() function in
> order to be able to handle aggregated packets in the future.
> 
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

Thanks, 12 patches applied to wireless-drivers-next.git:

c14ee43b8ae2 rtl8xxxu: Set all ieee80211_rx_status values in parse_rx_desc()
a635df8a41ac rtl8xxxu: Move skb delivery into parse_tx_desc() handler
2db125d4af4c rtl8xxxu: Obtain ieee80211_rx_status within parse_rx_desc()
41892729cf60 rtl8xxxu: Correct rxdesc16 definition
040b97be6056 rtl8xxxu: Add support for aggregated RX packets on gen1 parts
04319ae2f609 rtl8xxxu: Allocate larger RX skbs when aggregation is enabled
1e5b3b3fe9e0 rtl8xxxu: Adjust RX skb size to include space for phystats
91dcbb717531 rtl8xxxu: Enable aggregation for rtl8723au
0a20ed8bd057 rtl8xxxu: Enable aggregation for rtl8192cu/rtl8188cu/rtl8188ru
82cce22acd8e rtl8xxxu: Make DMA aggregation optional by setting a module parameter
614e389f36a9 rtl8xxxu: gen1: Set aggregation timeout (REG_RXDMA_AGG_PG_TH + 1) as well
fd83f1227826 rtl8xxxu: gen1: Add module parameters to adjust DMA aggregation parameters

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9200883/

